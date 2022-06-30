#import "CXProviderConfiguration+Calls.h"
#import <objc/runtime.h>

@implementation CXProviderConfiguration (Calls)

+ (void)load {
	[CXProviderConfiguration swizzleMethods];
}

+ (void)swizzleMethods {
	method_exchangeImplementations(class_getInstanceMethod(self, @selector(maximumCallGroups)), class_getInstanceMethod(self, @selector(swizzled_maximumCallGroups)));
	method_exchangeImplementations(class_getInstanceMethod(self, @selector(maximumCallsPerCallGroup)), class_getInstanceMethod(self, @selector(swizzled_maximumCallsPerCallGroup)));
}

- (void) setMaximumCallGroups:(NSUInteger)maximumCallGroups {}

- (void) setMaximumCallsPerCallGroup:(NSUInteger)maximumCallsPerCallGroup {}

- (NSUInteger) maximumCallGroups {
	NSLog(@"CXProviderConfiguration: maximumCallGroups");
	return  2;
}

- (NSUInteger) maximumCallsPerCallGroup {
	NSLog(@"CXProviderConfiguration: maximumCallsPerCallGroup");
	return  2;
}

- (NSUInteger) swizzled_maximumCallGroups {
	NSLog(@"CXProviderConfiguration: swizzled_maximumCallGroups");
	return  2;
}

- (NSUInteger) swizzled_maximumCallsPerCallGroup {
	NSLog(@"CXProviderConfiguration: swizzled_maximumCallsPerCallGroup");
	return  2;
}


@end
