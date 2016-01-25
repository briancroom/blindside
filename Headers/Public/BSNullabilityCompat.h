
#if __has_feature(nullability)

#ifndef NS_ASSUME_NONNULL_BEGIN
#define NS_ASSUME_NONNULL_BEGIN _Pragma("clang assume_nonnull begin")
#define NS_ASSUME_NONNULL_END   _Pragma("clang assume_nonnull end")
#endif

#ifndef __nullable
#define __nullable _Nullable
#endif

#ifndef __nonnull
#warning "Defining __nonnull"
#define __nonnull _Nonnull
#endif

#else
#ifndef NS_ASSUME_NONNULL_BEGIN

#define NS_ASSUME_NONNULL_BEGIN
#define NS_ASSUME_NONNULL_END
#define nullable
#define nonnull
#define null_unspecified
#define null_resettable
#define __nullable
#define __nonnull
#define __null_unspecified

#endif
#endif


#ifndef NS_UNAVAILABLE
#define NS_UNAVAILABLE __attribute__((unavailable))
#endif
