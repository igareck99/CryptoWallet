@import CallKit;
#import "MXCallKitAdapter+Updaters.h"

@interface MXCallKitAdapter ()

@property (nonatomic) CXProvider *provider;

@end

@implementation MXCallKitAdapter (Updaters)

- (void)updateMaximumCallGroups:(NSUInteger)maximumCallGroups {
	self.provider.configuration.maximumCallGroups = maximumCallGroups;
}

- (void)updateMaximumCallsPerCallGroup:(NSUInteger)maximumCallsPerCallGroup {
	self.provider.configuration.maximumCallsPerCallGroup = maximumCallsPerCallGroup;
}

@end
