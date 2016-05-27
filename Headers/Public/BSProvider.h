#import <Foundation/Foundation.h>

#import "BSNullabilityCompat.h"
#import "BSArgumentCollection.h"

@protocol BSInjector;

NS_ASSUME_NONNULL_BEGIN

@protocol BSProvider <NSObject>

- (id)provide:(id<BSArgumentCollection>)args injector:(id<BSInjector>)injector;

@end

NS_ASSUME_NONNULL_END
