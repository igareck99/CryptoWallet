@import Foundation;

@class MXRoom;
@class JitsiWidget;

NS_ASSUME_NONNULL_BEGIN

@interface AURGroupCallsViewModel : NSObject

- (instancetype)initWithRoom:(MXRoom *)room;

- (void)createJitsiWidgetInRoom:(MXRoom *)room
					  withVideo:(BOOL)video
						success:(void (^)(JitsiWidget *widget))success
						failure:(void (^)(void))failure;

- (void)openWidget:(JitsiWidget *)widget
		 withVideo:(BOOL)aVideo
		   success:(void (^)(NSString *conferenceId, NSString *jwtToken, NSURL *serverUrl))success
		   failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
