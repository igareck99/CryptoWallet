@import MatrixSDK;
#import <objc/runtime.h>
#import "MXRoom+Reply.h"
#import "MXSendReplyEventDefaultStringLocalizer.h"

NSString *const kMXMessageTypeContact = @"ms.aura.contact";
NSString *const kMXReplyOrigSelector = @"getReplyContentBodiesWithEventToReply:textMessage:formattedTextMessage:replyContentBody:replyContentFormattedBody:stringLocalizer:";
NSString *const kMXReplySwizzledSelector = @"swizzled_getReplyContentBodiesWithEventToReply:textMessage:formattedTextMessage:replyContentBody:replyContentFormattedBody:stringLocalizer:";

@interface MXRoom ()

- (void)getReplyContentBodiesWithEventToReply:(MXEvent*)eventToReply
								  textMessage:(NSString*)textMessage
						 formattedTextMessage:(NSString*)formattedTextMessage
							 replyContentBody:(NSString**)replyContentBody
					replyContentFormattedBody:(NSString**)replyContentFormattedBody
							  stringLocalizer:(id<MXSendReplyEventStringLocalizerProtocol>)stringLocalizer;

- (NSString*)replyMessageBodyFromSender:(NSString*)sender
                      senderMessageBody:(NSString*)senderMessageBody
                 isSenderMessageAnEmote:(BOOL)isSenderMessageAnEmote
                isSenderMessageAReplyTo:(BOOL)isSenderMessageAReplyTo
                           replyMessage:(NSString*)replyMessage;

- (NSString*)replyMessageFormattedBodyFromEventToReply:(MXEvent*)eventToReply
                            senderMessageFormattedBody:(NSString*)senderMessageFormattedBody
                                isSenderMessageAnEmote:(BOOL)isSenderMessageAnEmote
                                 replyFormattedMessage:(NSString*)replyFormattedMessage;

@end


@implementation MXRoom (Reply)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector: @"canReplyToEvent:" withSelector: @"swizzled_canReplyToEvent:"];
        [self swizzleSelector: kMXReplyOrigSelector withSelector: kMXReplySwizzledSelector];
    });
}

+ (void)swizzleSelector:(nonnull NSString *)origSel
           withSelector:(nonnull NSString *)swizzledSel {
    Class class = [self class];
    
    SEL originalSelector = NSSelectorFromString(origSel);
    SEL swizzledSelector = NSSelectorFromString(swizzledSel);

    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

    IMP originalImp = method_getImplementation(originalMethod);
    IMP swizzledImp = method_getImplementation(swizzledMethod);

    class_replaceMethod(class,
            swizzledSelector,
            originalImp,
            method_getTypeEncoding(originalMethod));
    class_replaceMethod(class,
            originalSelector,
            swizzledImp,
            method_getTypeEncoding(swizzledSelector));
}

- (BOOL)swizzled_canReplyToEvent:(MXEvent *)eventToReply {
    if ([eventToReply.wireContent[@"msgtype"] isEqualToString:kMXMessageTypeContact]) {
        return YES;
    }
    return [self swizzled_canReplyToEvent: eventToReply];
}

- (void)swizzled_getReplyContentBodiesWithEventToReply:(MXEvent*)eventToReply
                                  textMessage:(NSString*)textMessage
                         formattedTextMessage:(NSString*)formattedTextMessage
                             replyContentBody:(NSString**)replyContentBody
                    replyContentFormattedBody:(NSString**)replyContentFormattedBody
                              stringLocalizer:(id<MXSendReplyEventStringLocalizerProtocol>)stringLocalizer {
    
    NSString *msgtype;
    MXJSONModelSetString(msgtype, eventToReply.content[kMXMessageTypeKey]);
    
    if (![msgtype isEqualToString: kMXMessageTypeContact]) {
        [self swizzled_getReplyContentBodiesWithEventToReply:eventToReply
                                                 textMessage:textMessage
                                        formattedTextMessage:formattedTextMessage
                                            replyContentBody:replyContentBody
                                   replyContentFormattedBody:replyContentFormattedBody
                                             stringLocalizer:stringLocalizer];
    }
    
    BOOL eventToReplyIsAlreadyAReply = eventToReply.isReplyEvent;
    BOOL isSenderMessageAnEmote = [msgtype isEqualToString:kMXMessageTypeEmote];
    
    NSString *eventToReplyMessageBody = eventToReply.content[kMXMessageBodyKey];
    NSString *eventToReplyMessageFormattedBody;
    if ([eventToReply.content[@"format"] isEqualToString:kMXRoomMessageFormatHTML]) {
        eventToReplyMessageFormattedBody = eventToReply.content[@"formatted_body"];
    }
    NSString *senderMessageBody = eventToReplyMessageBody;
    NSString *senderMessageFormattedBody = eventToReplyMessageFormattedBody ?: eventToReplyMessageBody;
    
    *replyContentBody = [self replyMessageBodyFromSender:eventToReply.sender
                                       senderMessageBody:senderMessageBody
                                  isSenderMessageAnEmote:isSenderMessageAnEmote
                                 isSenderMessageAReplyTo:eventToReplyIsAlreadyAReply
                                            replyMessage:textMessage];
    
    // As formatted body is mandatory for a reply message, use non formatted to build it
    NSString *finalFormattedTextMessage = formattedTextMessage ?: textMessage;
    
    *replyContentFormattedBody = [self replyMessageFormattedBodyFromEventToReply:eventToReply
                                                      senderMessageFormattedBody:senderMessageFormattedBody
                                                          isSenderMessageAnEmote:isSenderMessageAnEmote
                                                           replyFormattedMessage:finalFormattedTextMessage];
}

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
