#import <Foundation/Foundation.h>

#import "BSProvider.h"
#import "BSNullabilityCompat.h"

@protocol BSInjector;

NS_ASSUME_NONNULL_BEGIN

/**
 * Typedef for blocks used by Blindside. Such blocks take a collection of arguments and return
 * an id. Blocks that don't need arguments may ignore the args object.
 *
 * @param args A collection of dynamic args provided by the caller of the BSInjector method
 *        getInstance:withArguments:. If a block does not need arguments, this param can be
 *        ignored.
 *
 * @param injector The BSInjector invoking the block. Can be used by blocks that need
 *        it and ignored by blocks that don't.
 */
typedef __nonnull id(^BSBlock)(id<BSArgumentCollection> args, id<BSInjector> injector);

/**
 * Used internally by Blindside when a key is bound to a block. BSBlockProvider 
 * implements the BSProvider interface by acting as a wrapper around the block.
 */
@interface BSBlockProvider : NSObject<BSProvider> 

/**
 * Returns a BSBlockProvider that wraps the block
 */
+ (BSBlockProvider *)providerWithBlock:(BSBlock)block;

@end

NS_ASSUME_NONNULL_END
