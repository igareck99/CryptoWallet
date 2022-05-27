#import <MatrixSDK/MatrixSDK.h>

@interface MXRoom (Reply)

- (MXHTTPOperation*_Nullable)sendReplyToEvent:(MXEvent*)eventToReply
							  withTextMessage:(NSString*_Nonnull)textMessage
						 formattedTextMessage:(nullable NSString*)formattedTextMessage
						  stringLocalizations:(nullable id<MXSendReplyEventStringsLocalizable>)stringLocalizations
									localEcho:(MXEvent**)localEcho
							 customParameters: (nullable NSDictionary*)customParameters
									  success:(void (^)(NSString *eventId))success
									  failure:(void (^)(NSError *error))failure;

@end
