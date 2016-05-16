#import <Foundation/Foundation.h>

#import "BSNullabilityCompat.h"

#define BS_NULL [BSNull null]

NS_ASSUME_NONNULL_BEGIN

@interface BSNull : NSObject<NSCopying>

+ (BSNull *)null;

@end

NS_ASSUME_NONNULL_END
