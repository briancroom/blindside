#import <Foundation/Foundation.h>

#import "BSNullabilityCompat.h"
#import "BSArgumentCollection.h"

@class BSInitializer, BSPropertySet;
@protocol BSInjector;

NS_ASSUME_NONNULL_BEGIN

@interface NSObject(Blindside)

+ (id)bsCreateWithArgs:(id<BSArgumentCollection>)args injector:(id<BSInjector>)injector;

+ (nullable BSInitializer *)bsInitializer;

+ (nullable BSPropertySet *)bsProperties;

- (void)bsAwakeFromPropertyInjection;

@end

NS_ASSUME_NONNULL_END
