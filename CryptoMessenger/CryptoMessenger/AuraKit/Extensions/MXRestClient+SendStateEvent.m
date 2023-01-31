#import "MXRestClient+SendStateEvent.h"

@interface MXRestClient ()

- (MXHTTPOperation*)sendStateEventToRoom:(NSString*)roomId
                               eventType:(MXEventTypeString)eventTypeString
                                 content:(NSDictionary*)content
                                stateKey:(nullable NSString*)stateKey
                                 success:(void (^)(NSString *eventId))success
                                 failure:(void (^)(NSError *error))failure;

@end

@implementation MXRestClient (SendStateEvent)

- (MXHTTPOperation*)aur_sendStateEventToRoom:(NSString*)roomId
                                   eventType:(MXEventTypeString)eventTypeString
                                     content:(NSDictionary*)content
                                    stateKey:(nullable NSString*)stateKey
                                     success:(void (^)(NSString *eventId))success
                                     failure:(void (^)(NSError *error))failure {
    
    return [self sendStateEventToRoom:roomId
                     eventType:eventTypeString
                       content:content
                      stateKey:stateKey
                       success:success
                       failure:failure];
}

@end
