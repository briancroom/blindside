#import <Foundation/Foundation.h>

#import "BSNullabilityCompat.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * An object representing argument valuesthat are made available when getting an 
 * instance. It can contain positional arguments, accessed using -argumentAtIndex:, or
 * keyed arguments accessed using -argumentForKey:. In either case, subscripting
 * can also be used to access the arguments.
 *
 * Generally, NSArray is used to provide positional arguments, and NSDictionary
 * to provide keyed arguments.
 */
@protocol BSArgumentCollection <NSObject, NSFastEnumeration>

/// The number of positional arguments contained in the receiver.
@property (readonly) NSUInteger indexedArgumentCount;

/// Returns a positional argument for the given index from the receiver, if it exists.
- (nullable id)argumentAtIndex:(NSUInteger)index;

/// Returns a keyed argument from the receiver, if it exists.
- (nullable id)argumentForKey:(id)argKey;

/// Allows accessing positional arguments with the subscript syntax.
- (nullable id)objectAtIndexedSubscript:(NSUInteger)idx;

/// Allows accessing keyed arguments with the subscript syntax.
- (nullable id)objectForKeyedSubscript:(id)key;

/// Returns a version of the collection with the keyed arguments from the receiver.
- (id<BSArgumentCollection>)keyedArguments;

@end

@interface NSArray (BSArgumentCollection) <BSArgumentCollection>
@end

@interface NSDictionary (BSArgumentCollection) <BSArgumentCollection>
@end

NS_ASSUME_NONNULL_END
