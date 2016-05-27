#import <Foundation/Foundation.h>

#import "BSNullabilityCompat.h"

#define BS_DYNAMIC [BSDynamicKey key]
#define BS_DYNAMIC_KEY(ARG_KEY) [BSDynamicKey key:ARG_KEY]

NS_ASSUME_NONNULL_BEGIN

/**
 * Represents a dynamic parameter, either positional or keyed. Instances are
 * generally created using the BS_DYNAMIC (positional) or BS_DYNAMIC_KEY (keyed)
 * macros
 */
@interface BSDynamicKey : NSObject <NSCopying>

+ (BSDynamicKey *)key;
+ (BSDynamicKey *)key:(id)key;

@end

NS_ASSUME_NONNULL_END
