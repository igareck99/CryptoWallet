#import "MXRoom.h"

NS_ASSUME_NONNULL_BEGIN

@interface MXRoom (Reply)

- (MXHTTPOperation*_Nullable)sendReplyToEvent:(MXEvent * _Nullable)eventToReply
							  withTextMessage:(NSString *_Nonnull)textMessage
						 formattedTextMessage:(NSString* _Nullable)formattedTextMessage
						  stringLocalizations:(id<MXSendReplyEventStringLocalizerProtocol> _Nullable)stringLocalizations
									localEcho:(MXEvent *_Nullable *_Nullable)localEcho
							 customParameters: (nullable NSDictionary*)customParameters
									  success:(void (^_Nullable)(NSString * _Nullable eventId))success
									  failure:(void (^_Nullable)(NSError * _Nullable error))failure;

@end

NS_ASSUME_NONNULL_END
