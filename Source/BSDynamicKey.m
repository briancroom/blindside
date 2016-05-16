#import "BSDynamicKey.h"

@interface BSDynamicKey ()
@property (nonatomic, strong) id wrappedKey;
@end

@implementation BSDynamicKey

+ (BSDynamicKey *)key {
    return [[self alloc] initWithWrappedKey:[NSNull null]];
}

+ (BSDynamicKey *)key:(id)key {
    return [[self alloc] initWithWrappedKey:key];
}

- (id)initWithWrappedKey:(id)wrappedKey {
    if (self = [super init]) {
        self.wrappedKey = wrappedKey;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
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
