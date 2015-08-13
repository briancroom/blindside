#import <Foundation/Foundation.h>

#import "BSBinder.h"
#import "BSInjector.h"
#import "BSNullabilityCompat.h"

NS_ASSUME_NONNULL_BEGIN

@interface BSInjectorImpl : NSObject<BSBinder, BSInjector>

- (instancetype)initWithParentInjector:(nullable id<BSInjector>)injector NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
