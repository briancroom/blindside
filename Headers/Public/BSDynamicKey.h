#import <Foundation/Foundation.h>

#import "BSNullabilityCompat.h"

#define BS_DYNAMIC [BSDynamicKey key]

NS_ASSUME_NONNULL_BEGIN

@interface BSDynamicKey : NSObject<NSCopying>

+ (BSDynamicKey *)key;
+ (BSDynamicKey *)key:(id)key;

@end

NS_ASSUME_NONNULL_END
