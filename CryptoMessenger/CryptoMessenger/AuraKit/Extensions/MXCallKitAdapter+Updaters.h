#import "MXCallKitAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface MXCallKitAdapter (Updaters)

+ (instancetype)initCallKitAdapter;
- (void)logData;

- (void)updateMaximumCallGroups:(NSUInteger)maximumCallGroups;

- (void)updateMaximumCallsPerCallGroup:(NSUInteger)maximumCallsPerCallGroup;

@end

NS_ASSUME_NONNULL_END
