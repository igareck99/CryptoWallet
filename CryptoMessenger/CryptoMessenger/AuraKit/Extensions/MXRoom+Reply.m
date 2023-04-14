#import "MXRoom+Reply.h"
#import "MXSendReplyEventDefaultStringLocalizer.h"

@interface MXRoom ()

- (void)getReplyContentBodiesWithEventToReply:(MXEvent*)eventToReply
								  textMessage:(NSString*)textMessage
						 formattedTextMessage:(NSString*)formattedTextMessage
							 replyContentBody:(NSString**)replyContentBody
					replyContentFormattedBody:(NSString**)replyContentFormattedBody
							  stringLocalizer:(id<MXSendReplyEventStringLocalizerProtocol>)stringLocalizer;

@end


@implementation MXRoom (Reply)

- (MXHTTPOperation*)sendReplyToEvent:(MXEvent*)eventToReply
					 withTextMessage:(NSString*)textMessage
				formattedTextMessage:(NSString*)formattedTextMessage
				 stringLocalizations:(id<MXSendReplyEventStringLocalizerProtocol>)stringLocalizations
						   localEcho:(MXEvent**)localEcho
					customParameters: (NSDictionary*)customParameters
							 success:(void (^)(NSString *eventId))success
							 failure:(void (^)(NSError *error))failure
{
	if (![self canReplyToEvent:eventToReply]) {
		NSLog(@"[MXRoom] Send reply to this event is not supported");
		return nil;
	}

	id<MXSendReplyEventStringLocalizerProtocol> finalStringLocalizations;

	if (stringLocalizations) {
		finalStringLocalizations = stringLocalizations;
	} else {
		finalStringLocalizations = [MXSendReplyEventDefaultStringLocalizer new];
	}

	MXHTTPOperation* operation = nil;

	NSString *replyToBody;
	NSString *replyToFormattedBody;

	[self getReplyContentBodiesWithEventToReply:eventToReply
											textMessage:textMessage
								   formattedTextMessage:formattedTextMessage
									   replyContentBody:&replyToBody
							  replyContentFormattedBody:&replyToFormattedBody
										stringLocalizer:finalStringLocalizations];

	if (replyToBody && replyToFormattedBody) {
		NSString *eventId = eventToReply.eventId;

		NSDictionary *relatesToDict = @{ @"m.in_reply_to" :
											 @{
												 @"event_id" : eventId
											 }
		};

		NSMutableDictionary *msgContent = [NSMutableDictionary dictionary];

		if (customParameters != nil) {
			msgContent = [NSMutableDictionary dictionaryWithDictionary:customParameters];
		}

		msgContent[@"format"] = kMXRoomMessageFormatHTML;
		msgContent[@"msgtype"] = kMXMessageTypeText;
		msgContent[@"body"] = replyToBody;
		msgContent[@"formatted_body"] = replyToFormattedBody;
		msgContent[@"m.relates_to"] = relatesToDict;

		operation = [self sendMessageWithContent:msgContent
										threadId:nil
									   localEcho:localEcho
										 success:success
										 failure:failure];
		} else {
			NSLog(@"[MXRoom] Fail to generate reply body and formatted body");
		}
	return operation;
}

@end
