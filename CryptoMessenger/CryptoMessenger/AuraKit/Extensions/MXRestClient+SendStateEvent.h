#import "MXRestClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface MXRestClient (SendStateEvent)

/**
 Send a generic state event to a room.

 @param roomId the id of the room.
 @param eventTypeString the type of the event. @see MXEventType.
 @param content the content that will be sent to the server as a JSON object.
 @param stateKey the optional state key.
 @param success A block object called when the operation succeeds. It returns
 the event id of the event generated on the home server
 @param failure A block object called when the operation fails.

 @return a MXHTTPOperation instance.
 */
- (MXHTTPOperation*)aur_sendStateEventToRoom:(NSString*)roomId
                                   eventType:(MXEventTypeString)eventTypeString
                                     content:(NSDictionary*)content
                                    stateKey:(NSString* _Nullable)stateKey
                                     success:(void (^)(NSString *eventId))success
                                     failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
