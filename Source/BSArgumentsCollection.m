#import "BSArgumentCollection.h"
#import "BSDynamicKey+Private.h"

@implementation NSArray (BSArgumentCollection)

- (NSUInteger)indexedArgumentCount {
    return self.count;
}

- (id)argumentAtIndex:(NSUInteger)index {
    return [self objectAtIndex:index];
}

- (id)argumentForKey:(id)argKey {
    return nil;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return [self argumentAtIndex:idx];
}

- (id)objectForKeyedSubscript:(id)key {
    return [self argumentForKey:key];
}

- (id<BSArgumentCollection>)keyedArguments {
    return @[];
}

@end


@implementation NSDictionary (BSArgumentCollection)

- (NSUInteger)indexedArgumentCount {
    return 0;
}

- (id)argumentAtIndex:(NSUInteger)index {
    return nil;
}

- (id)argumentForKey:(id)argKey {
    id key = [argKey respondsToSelector:@selector(wrappedKey)] ? [argKey wrappedKey] : argKey;
    return [self objectForKey:key];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return [self argumentAtIndex:idx];
}

- (id)objectForKeyedSubscript:(id)key {
    return [self argumentForKey:key];
}

- (id<BSArgumentCollection>)keyedArguments {
    return self;
}

@end
