#import "BSDynamicKey.h"

NS_ASSUME_NONNULL_BEGIN

@interface BSDynamicKey (Private)

@property (nonatomic, readonly) id wrappedKey;
@property (nonatomic, readonly, getter=isKeywordKey) BOOL keywordKey;

@end

NS_ASSUME_NONNULL_END
