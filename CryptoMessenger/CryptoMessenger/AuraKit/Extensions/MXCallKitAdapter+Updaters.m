@import CallKit;
@import UIKit;
#import "MXCallKitAdapter+Updaters.h"
#import "MXCallKitConfiguration.h"

@interface MXCallKitAdapter (Updaters)

@property (nonatomic) CXProvider *provider;
@property (nonatomic) CXCallController *callController;
@property (nonatomic) NSMutableDictionary<NSUUID *, MXCall *> *calls;

@end

@implementation MXCallKitAdapter (Updaters)

+ (instancetype)initCallKitAdapter {

	MXCallKitConfiguration *configuration = [[MXCallKitConfiguration alloc] initWithName:@"CryptoMessenger"
																			ringtoneName:nil
																				iconName:@"AppIcon"
																		   supportsVideo: NO];

	CXProviderConfiguration *providerConfiguration = [[CXProviderConfiguration alloc] init];
	providerConfiguration.ringtoneSound = configuration.ringtoneName;
	providerConfiguration.maximumCallGroups = 2;
	providerConfiguration.maximumCallsPerCallGroup = 2;
	providerConfiguration.supportedHandleTypes = [NSSet setWithObject:@(CXHandleTypeGeneric)];
	providerConfiguration.supportsVideo = configuration.supportsVideo;

	if (configuration.iconName) {
		providerConfiguration.iconTemplateImageData = UIImagePNGRepresentation([UIImage imageNamed:configuration.iconName]);
	}

	CXProvider *provider = [[CXProvider alloc] initWithConfiguration:providerConfiguration];

	MXCallKitAdapter *adapter = [[MXCallKitAdapter alloc] initWithConfiguration:configuration];

	adapter.provider = provider;

	if ([adapter conformsToProtocol:@protocol(CXProviderDelegate)]) {
		[provider setDelegate:(id<CXProviderDelegate>)adapter queue:nil];
	}

	return adapter;
}

- (void)logData {
	NSLog(@"CXProvider: maximumCallGroups: @%lu", (unsigned long)self.provider.configuration.maximumCallGroups);
	NSLog(@"CXProvider: maximumCallsPerCallGroup: @%lu", (unsigned long)self.provider.configuration.maximumCallsPerCallGroup);
}

- (void)updateMaximumCallGroups:(NSUInteger)maximumCallGroups {
	self.provider.configuration.maximumCallGroups = maximumCallGroups;
}

- (void)updateMaximumCallsPerCallGroup:(NSUInteger)maximumCallsPerCallGroup {
	self.provider.configuration.maximumCallsPerCallGroup = maximumCallsPerCallGroup;
}

@end
