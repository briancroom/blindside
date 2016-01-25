#import <Blindside/Blindside.h>

@interface TestModule : NSObject <BSModule> @end
@implementation TestModule

- (void)configure:(id<BSBinder>)binder {
    [binder bind:@"greeting" toInstance:@"Hello World"];
}

@end

int main(int argc, char * argv[]) {
    @autoreleasepool {
        id<BSInjector> injector = [Blindside injectorWithModule:[TestModule new]];
        NSString *greeting = [injector getInstance:@"greeting"];
        NSLog(@"%@", greeting);
        return YES;
    }
}
