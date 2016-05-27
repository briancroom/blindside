#import "BSDynamicKey+Private.h"

@interface BSDynamicKey ()
@property (nonatomic, strong, readwrite) id wrappedKey;
@end

@implementation BSDynamicKey

+ (BSDynamicKey *)key {
    return [[self alloc] initWithWrappedKey:nil];
}

+ (BSDynamicKey *)key:(id)key {
    return [[self alloc] initWithWrappedKey:key];
}

- (id)initWithWrappedKey:(id)wrappedKey {
    if (self = [super init]) {
        self.wrappedKey = wrappedKey ?: [NSNull null];
    }
    return self;
}

- (BOOL)isKeywordKey {
    return ![[NSNull null] isEqual:self.wrappedKey];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

-(NSString *)description {
    if (self.wrappedKey) {
        return [NSString stringWithFormat:@"BSDynamicKey(%@)", self.wrappedKey];
    } else {
        return @"BSDynamicKey";
    }
}

- (BOOL)isEqual:(BSDynamicKey *)other {
    if (!other || ![other isKindOfClass:[self class]]) {
        return NO;
    }

    return [self.wrappedKey isEqual:other.wrappedKey];
}

- (NSUInteger)hash {
    return [self.wrappedKey hash];
}

@end
