#import "BSInjectorImpl.h"
#import "BSBinder.h"
#import "BSModule.h"
#import "BSProvider.h"
#import "BSInitializerProvider.h"
#import "BSInstanceProvider.h"
#import "BSInitializer.h"
#import "BSScope.h"
#import "BSProperty.h"
#import "BSPropertySet.h"
#import "BSClassProvider.h"
#import "BSNull.h"
#import "NSObject+Blindside.h"
#import "BSUtils.h"
#import <objc/runtime.h>

static NSString *const BSNoProviderException = @"BSNoProviderException";
static NSString *const BSCyclicDependencyException = @"BSCyclicDependencyException";
static NSString *const BSInFlightKeysDictKey = @"BSInFlightKeysDictKey";

@interface BSInjectorImpl ()

@property(nonatomic, strong) id<BSInjector> parentInjector;
@property(nonatomic, strong) NSMutableDictionary *providers;
@property(nonatomic, strong) NSMutableDictionary *scopes;

- (void)injectInjector:(id)object;
- (id)getInstance:(id)key withArgArray:(NSArray *)args;

@end

@implementation BSInjectorImpl

@synthesize providers = _providers, scopes = _scopes;

- (instancetype)init {
    return [self initWithParentInjector:nil];
}

- (instancetype)initWithParentInjector:(id<BSInjector>)parentInjector {
    if (self = [super init]) {
        _parentInjector = parentInjector;
        _providers = [NSMutableDictionary dictionary];
        _scopes = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)bind:(id)key toInstance:(id)instance {
    BSInstanceProvider *provider = [BSInstanceProvider provider:instance];
    [self setProvider:provider forKey:key];
}

- (void)bind:(id)key toProvider:(id<BSProvider>)provider {
    [self setProvider:provider forKey:key];
}

- (void)bind:(id)key toBlock:(BSBlock)block {
    BSBlockProvider *provider = [BSBlockProvider providerWithBlock:block];
    [self setProvider:provider forKey:key];
}

- (void)bind:(id)key toClass:(Class)class {
    if (key == class) {
        [self clearProviderForKey:key];
    } else {
        BSClassProvider *provider = [BSClassProvider providerWithClass:class];
        [self bind:key toProvider:provider];
    }
}

- (void)bind:(id)key toClass:(Class)class withScope:(id<BSScope>)scope {
    [self bind:key toClass:class];
    [self bind:key withScope:scope];
}

- (void)bind:(id)key withScope:(id<BSScope>)scope {
    [self setScope:scope forKey:key];

    if (![self explicitlyBoundProviderForKey:key]) {
        [self bind:key toProvider:[self synthesizedProviderForKey:key]];
    }
}

- (void)injectInjector:(id)object {
    objc_property_t objc_property = class_getProperty([object class], "injector");
    if (objc_property == NULL) {
        return;
    }

    const char *attributes = property_getAttributes(objc_property);
    NSString *attrStr = [NSString stringWithUTF8String:attributes];
    NSRange startRange = [attrStr rangeOfString:@"<BSInjector>"];

    if (startRange.location != NSNotFound) {
        [object setValue:self forKey:@"injector"];
    }
}

- (id)getInstance:(id)key {
    return [self getInstance:key withArgs:nil];
}

- (id)getInstance:(id)key withArgs:(id)arg1, ... {
    NSMutableArray *args = [NSMutableArray array];
    AddVarArgsToNSMutableArray(arg1, args);
    return [self getInstance:key withArgArray:args];
}

- (id)getInstance:(id)key withArgArray:(NSArray *)args {
    id<BSProvider> provider = [self explicitlyBoundProviderForKey:key];

    if (!provider) {
        if (self.parentInjector) {
            return [self.parentInjector getInstance:key withArgArray:args];
        } else {
            provider = [self synthesizedProviderForKey:key];
        }
    }

    id<BSScope> scope = [self scopeForKey:key];
    if (provider && scope) {
        provider = [scope scope:provider];
    }

    if (provider == nil && ![BS_DYNAMIC isEqual:key]) {
        [NSException raise:BSNoProviderException format:@"Injector could not getInstance for key (%@) with args %@", key, args];
    }

    return [self performWithInFlightKey:key block:^id{
        id instance = [provider provide:args injector:self];
        [self injectInjector:instance];

        return instance;
    }];
}

- (void)injectProperties:(id)instance {
    if ([[instance class] respondsToSelector:@selector(bsProperties)]) {
        BSPropertySet *propertySet = [[instance class] performSelector:@selector(bsProperties)];
        for (BSProperty *property in propertySet) {
            id value = [self getInstance:property.injectionKey];
            value = (value==[BSNull null]) ? nil : value;

            [instance setValue:value forKey:property.propertyNameString];
        }
    }
    [self injectInjector:instance];
    if ([instance respondsToSelector:@selector(bsAwakeFromPropertyInjection)]) {
        [instance bsAwakeFromPropertyInjection];
    }
}

- (void)setProvider:(id<BSProvider>)provider forKey:(id)key {
    [self.providers setObject:provider forKey:[self internalKey:key]];
}

- (void)clearProviderForKey:(id)key {
    [self.providers removeObjectForKey:[self internalKey:key]];
}

- (id<BSProvider>)explicitlyBoundProviderForKey:(id)key {
    return [self.providers objectForKey:[self internalKey:key]];
}

- (id<BSProvider>)synthesizedProviderForKey:(id)key {
    if ([key respondsToSelector:@selector(bsInitializer)]) {
        BSInitializer *initializer = [key performSelector:@selector(bsInitializer)];
        if (initializer != nil) {
            return [BSInitializerProvider providerWithInitializer:initializer];
        }
    }

    if ([key respondsToSelector:@selector(bsCreateWithArgs:injector:)]) {
        __weak id this = self;
        return [BSBlockProvider providerWithBlock:^id(NSArray *args, id<BSInjector> injector) {
            return [key performSelector:@selector(bsCreateWithArgs:injector:) withObject:args withObject:this];
        }];
    }

    return nil;
}

- (void)setScope:(id<BSScope>)scope forKey:(id)key {
    [self.scopes setObject:scope forKey:[self internalKey:key]];
}

- (id<BSScope>)scopeForKey:(id)key {
    return [self.scopes objectForKey:[self internalKey:key]];
}

- (id)internalKey:(id)key {
    if ([NSStringFromClass([key class]) isEqualToString:@"Protocol"]) {
        return [NSString stringWithFormat:@"@protocol(%@)", NSStringFromProtocol(key)];
    }
    return key;
}

#pragma mark - In-Flight Key Tracking

- (id)performWithInFlightKey:(id)key block:(id (^)(void))block {
    if ([self isKeyInFlight:key]) {
        [NSException raise:BSCyclicDependencyException format:@"Cyclic dependency found on key %@. The dependency chain was:\n%@", key, [self cyclicDependencyChainDescription]];
    }

    [self addInFlightKey:key];

    id ret;
    @try {
        ret = block();
    } @catch (NSException *exception) {
        @throw;
    } @finally {
        [self removeInFlightKey:key];
    }

    return ret;
}

- (BOOL)isKeyInFlight:(id)key {
    return [[self inFlightKeys] containsObject:[self internalKey:key]];
}

- (void)addInFlightKey:(id)key {
    [[self inFlightKeys] addObject:[self internalKey:key]];
}

- (void)removeInFlightKey:(id)key {
    [[self inFlightKeys] removeObject:[self internalKey:key]];
}

- (void)clearInFlightKeys {
    [[self inFlightKeys] removeAllObjects];
}

- (NSMutableOrderedSet *)inFlightKeys {
    NSMutableOrderedSet *set = [[NSThread currentThread].threadDictionary objectForKey:BSInFlightKeysDictKey];
    if (!set) {
        set = [NSMutableOrderedSet orderedSet];
        [[NSThread currentThread].threadDictionary setObject:set forKey:BSInFlightKeysDictKey];
    }
    return set;
}

- (NSString *)cyclicDependencyChainDescription {
    NSOrderedSet *keys = [self inFlightKeys];
    NSArray *chain = [[keys array] arrayByAddingObject:[keys objectAtIndex:0]];
    return [chain componentsJoinedByString:@" -> "];
}

@end
