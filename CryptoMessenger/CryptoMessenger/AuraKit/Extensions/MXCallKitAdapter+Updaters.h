#import <MatrixSDK/MatrixSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface MXCallKitAdapter (Updaters)

- (void)updateMaximumCallGroups:(NSUInteger)maximumCallGroups;

- (void)updateMaximumCallsPerCallGroup:(NSUInteger)maximumCallsPerCallGroup;

@end

NS_ASSUME_NONNULL_END
