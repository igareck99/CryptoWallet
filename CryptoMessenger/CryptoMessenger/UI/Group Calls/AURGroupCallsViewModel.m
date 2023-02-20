@import JitsiMeetSDK;
#import "MatrixSDK.h"
#import "Base32Encoder.h"
#import "AURGroupCallsViewModel.h"
#import "CryptoMessenger-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface AURGroupCallsViewModel ()

@property(nonatomic) MXSessionEventListener *sessionEventListener;
@property(nonatomic) MXRoom *room;
@property(nonatomic) NSMutableDictionary<NSString *, MXHTTPClient *> *httpClients;
@property(nonatomic) NSMutableDictionary<NSString*, NSMutableDictionary<NSString*, void (^)(JitsiWidget *widget)>*> *successBlockForWidgetCreation;
@property(nonatomic) NSMutableDictionary<NSString*,NSMutableDictionary<NSString*, void (^)(void)>*> *failureBlockForWidgetCreation;


@property(nonatomic) JitsiWidgetService *jitsiWidgetService;
@property(nonatomic) JitsiWidget *widget;
@property (nonatomic, strong) NSString *conferenceId;
@property (nonatomic, strong) NSURL *serverUrl;
@property (nonatomic, strong) NSString *jwtToken;
@property (nonatomic) BOOL startWithVideo;

@property (nonatomic) AURJitsiJWTTokenBuilder *jwtTokenBuilder;

@property (nullable, nonatomic) void(^widgetCallBack)(JitsiWidget *);

@end

NS_ASSUME_NONNULL_END

@implementation AURGroupCallsViewModel

- (instancetype)initWithRoom:(MXRoom *)room
{
	self = [super init];

	if (self) {
		_room = room;
		_jitsiWidgetService = [[JitsiWidgetService alloc] initWithMxSession:room.mxSession];
		_jwtTokenBuilder = [[AURJitsiJWTTokenBuilder alloc] init];
		_httpClients = [[NSMutableDictionary alloc] init];
		_successBlockForWidgetCreation = [NSMutableDictionary dictionary];
		_failureBlockForWidgetCreation = [NSMutableDictionary dictionary];
		[self subscribeToWidgetEvent];
	}
	return self;
}

- (void)createJitsiWidgetInRoom:(MXRoom*)room
					  withVideo:(BOOL)video
						success:(void (^)(JitsiWidget *widget))success
						failure:(void (^)(void))failure
{
	MXHTTPOperation *operation = [MXHTTPOperation new];
	NSString *userId = room.mxSession.myUser.userId;

	// Build data for a jitsi widget
	// Riot-Web still uses V1 type
	NSString *widgetId = [NSString stringWithFormat:@"%@_%@_%@", JistsiConstants.kWidgetTypeJitsiV1, userId, @((uint64_t)([[NSDate date] timeIntervalSince1970] * 1000))];
	NSString *jitsiBaseUrl = room.mxSession.homeserverWellknown.homeServer.baseUrl;

	if (!jitsiBaseUrl) { failure(); return; }

	NSURL *preferredJitsiServerUrl = [NSURL URLWithString:jitsiBaseUrl];

	if (!preferredJitsiServerUrl) { failure(); return; }

	operation = [self createJitsiWidgetContentWithJitsiServerURL:preferredJitsiServerUrl
														  roomId:room.roomId
													 isAudioOnly:!video
														 success:^(NSDictionary<NSString *,id> *widgetContent) {

		MXHTTPOperation *operation2 = [self createWidgetWithId:widgetId
												   withContent:widgetContent
														inRoom:room
													   success:success
													   failure:failure];
		[operation mutateTo:operation2];

	}
														 failure:failure];
}

- (MXHTTPOperation *)createWidgetWithId:(NSString*)widgetId
							withContent:(NSDictionary<NSString*, NSObject*>*)widgetContent
								 inRoom:(MXRoom*)room
								success:(void (^)(JitsiWidget *widget))success
								failure:(void (^)(void))failure
{
	// Create an empty operation that will be mutated later
	MXHTTPOperation *operation = [[MXHTTPOperation alloc] init];

	MXWeakify(self);
	[self checkWidgetPermissionInRoom:room
							  success:^{
		MXStrongifyAndReturnIfNil(self);

		NSString *hash = [NSString stringWithFormat:@"%p", room.mxSession];
		self.successBlockForWidgetCreation[hash][widgetId] = success;
		self.failureBlockForWidgetCreation[hash][widgetId] = failure;
		self.widgetCallBack = success;

		// Send a state event with the widget data
		// TODO: This API will be shortly replaced by a pure modular API
		// TODO: Move to kWidgetMatrixEventTypeString ("m.widget") type but when?
		MXHTTPOperation *operation2 = [room sendStateEventOfType:JistsiConstants.kWidgetModularEventTypeString
														 content:widgetContent
														stateKey:widgetId
														 success:nil
														 failure:^(NSError *error) { if (failure) { failure(); } }];
		[operation mutateTo:operation2];
	}
							  failure:failure];
	return operation;
}

- (nullable MXHTTPOperation *)createJitsiWidgetContentWithJitsiServerURL:(NSURL *)jitsiServerURL
																  roomId:(NSString *)roomId
															 isAudioOnly:(BOOL) isAudioOnly
																 success:(void (^)(NSDictionary <NSString *, id>*))success
																 failure:(void (^)(void))failure
{
	NSString *serverDomain = [jitsiServerURL.host copy];

	if (!serverDomain) { return NULL; }

	return [self getJitsiWellKnownWihtUrl:jitsiServerURL
								  success:^{

		NSDictionary <NSString *, id>*widgetContent = [self createJitsiContentDataWithUrl:serverDomain
																			jitsiAuthType:JistsiConstants.openIDTokenJWT
																				   roomId:roomId
																			  isAudioOnly:isAudioOnly];
		if (!widgetContent) { failure(); return; }
		success(widgetContent);
	}
								  failure:failure];
}

- (nullable MXHTTPOperation *)getJitsiWellKnownWihtUrl:(NSURL *)url
											   success:(void (^)(void))success
											   failure:(void (^)(void))failure
{
	// TODO: Пока убрал логику с запросом на /.well
	// непонятно нужно ли это нам
	MXHTTPClient *client = [self makeMXHTTPClientWithUrl:url];
	if (!client) { failure(); return nil; }
	success();
	return nil;
}

- (nullable MXHTTPClient *)makeMXHTTPClientWithUrl:(NSURL *)url {

	NSString *urlString = url.absoluteString;
	MXHTTPClient *existingClient = [self.httpClients objectForKey: urlString];

	if (existingClient) { return existingClient; }

	MXHTTPClient *client = [[MXHTTPClient alloc] initWithBaseURL: urlString andOnUnrecognizedCertificateBlock: NULL];
	self.httpClients[urlString] = client;
	return client;
}

- (nullable NSDictionary <NSString *, id>*)createJitsiContentDataWithUrl:(NSString *)url
														   jitsiAuthType:(NSString *)jitsiAuthType
																  roomId:(NSString *)roomId
															 isAudioOnly:(BOOL)isAudioOnly
{
	BOOL isMatrixRoomId = [MXTools isMatrixRoomIdentifier: roomId];
	if (!isMatrixRoomId) { return NULL; }

	// Create a random enough jitsi conference id
	// Note: the jitsi server automatically creates conference when the conference
	// id does not exist yet
	NSUInteger widgetIdLength = 7;
	NSString *widgetSessionId = [[NSProcessInfo.processInfo.globallyUniqueString substringToIndex:widgetIdLength] lowercaseString];

	NSString *conferenceID;
	NSString *authenticationTypeString;
	//	NSString *openIDTokenJWT = @"openidtoken-jwt";
	if ([jitsiAuthType isEqualToString: JistsiConstants.openIDTokenJWT]) {

		// For compatibility with Jitsi, use base32 without padding.
		// More details here:
		// https://github.com/matrix-org/prosody-mod-auth-matrix-user-verification
		conferenceID = [Base32Encoder base32StringWithString:roomId];
		authenticationTypeString = JistsiConstants.openIDTokenJWT;
	} else {

		NSString *matrixRoomIdPrefix = @"!";
		NSString *homeServerSeparator = @":";
		NSArray *components = [roomId componentsSeparatedByString: homeServerSeparator];

		if ([components count] > 1) {
			NSRange range = NSMakeRange(0, [components count] - 1);
			NSString *localRoomId = [components.firstObject stringByReplacingCharactersInRange: range withString: matrixRoomIdPrefix];
			conferenceID = [NSString stringWithFormat:@"%@%@", localRoomId, widgetSessionId];
		} else {
			conferenceID = widgetSessionId;
		}
		authenticationTypeString = NULL;
	}

	// Build widget url
	// Riot-iOS does not directly use it but extracts params from it (see `[JitsiViewController openWidget:withVideo:]`)
	// This url can be used as is inside a web container (like iframe for Riot-web)
    NSString *appUrlString = url;
//    @"https://meet.auramsg.co";

	// We mix v1 and v2 param for backward compability
	NSArray *v1queryStringParts = @[
		[NSString stringWithFormat:@"confId=%@", conferenceID],
		[NSString stringWithFormat:@"isAudioConf=%@", isAudioOnly ? @"true" : @"false"],
		@"displayName=$matrix_display_name",
		@"avatarUrl=$matrix_avatar_url",
		@"email=$matrix_user_id"
	];

	NSString *v1Params = [v1queryStringParts componentsJoinedByString: @"&"];

	NSString *widgetStringURL = [NSString stringWithFormat: @"%@/widgets/jitsi.html?%@", appUrlString, v1Params];

	// Build widget data
	// We mix v1 and v2 widget data for backward compability
	JitsiWidgetData *jitsiWidgetData = [[JitsiWidgetData alloc] initWithDomain:appUrlString
																  conferenceId:conferenceID
																   isAudioOnly:isAudioOnly
															authenticationType:NULL]; // jitsiAuthType

	NSDictionary *v2WidgetData = [jitsiWidgetData JSONDictionary];

	NSMutableDictionary *v1AndV2WidgetData = [v2WidgetData mutableCopy];
	v1AndV2WidgetData[@"widgetSessionId"] = [widgetSessionId copy];

	NSDictionary *widgetContent = @{
		@"url": widgetStringURL,
		@"type": JistsiConstants.kWidgetTypeJitsiV1,
		@"data": [v1AndV2WidgetData copy]
	};
	return [widgetContent copy];
}

- (void)checkWidgetPermissionInRoom:(MXRoom *)room
							success:(dispatch_block_t)success
							failure:(void (^)(void))failure {
	[room state:^(MXRoomState *roomState) {
		NSError *error;

		// Check user's power in the room
		MXRoomPowerLevels *powerLevels = roomState.powerLevels;
		NSInteger oneSelfPowerLevel = [powerLevels powerLevelOfUserWithUserID:room.mxSession.myUser.userId];

		// The user must be able to send state events to manage widgets
		if ((oneSelfPowerLevel < powerLevels.stateDefault) || error) {
			failure();
		} else {
			success();
		}
	}];
}

- (void)subscribeToWidgetEvent
{
	__weak __typeof__(self) weakSelf = self;

	NSString *hash = [NSString stringWithFormat:@"%p", self.room.mxSession];

	NSArray *eventsOfTypes = @[JistsiConstants.kWidgetMatrixEventTypeString, JistsiConstants.kWidgetModularEventTypeString];
	self.sessionEventListener = [self.room.mxSession listenToEventsOfTypes:eventsOfTypes
																   onEvent:^(MXEvent *event, MXTimelineDirection direction, id customObject) {

		typeof(self) self = weakSelf;

		if (self && direction == MXTimelineDirectionForwards) {
			// stateKey = widgetId
			NSString *widgetId = event.stateKey;
			if (!widgetId) { return; }

			JitsiWidget *widget = [[JitsiWidget alloc] initWithEvent:event session:self.room.mxSession];
			if (widget) {
				// If it is a widget we have just created, indicate its creation is complete
				if (self.successBlockForWidgetCreation[hash][widgetId]) {
					self.successBlockForWidgetCreation[hash][widgetId](widget);
				} else if (self.widgetCallBack) {
					self.widgetCallBack(widget);
				}

				// TODO: Раскомментировать при необхожимости
				// Broadcast the generic notification
//				[[NSNotificationCenter defaultCenter] postNotificationName:kWidgetManagerDidUpdateWidgetNotification object:widget];
			} else {
				if (self.failureBlockForWidgetCreation[hash][widgetId]) {
					self.failureBlockForWidgetCreation[hash][widgetId]();
				}
			}

			self.widgetCallBack = NULL;
			[self.successBlockForWidgetCreation[hash] removeObjectForKey:widgetId];
			[self.failureBlockForWidgetCreation[hash] removeObjectForKey:widgetId];
		}
	}];

	self.successBlockForWidgetCreation[hash] = [NSMutableDictionary dictionary];
	self.failureBlockForWidgetCreation[hash] = [NSMutableDictionary dictionary];
}

- (void)openWidget:(JitsiWidget*)widget
		 withVideo:(BOOL)aVideo
		   success:(void (^)(NSString *conferenceId, NSString *jwtToken, NSURL *serverUrl))success
		   failure:(void (^)(NSError *error))failure
{
	self.startWithVideo = aVideo;
	_widget = widget;

	MXWeakify(self);

	[self.jitsiWidgetService makeWidgetUrlWithWidget:widget
											 success:^(NSString * _Nonnull widgetUrl) {

		MXStrongifyAndReturnIfNil(self);

		// Use widget data from Matrix Widget API v2 first
		JitsiWidgetData *jitsiWidgetData = [JitsiWidgetData modelWithDictionary:widget.data];

		[self fillWithWidgetData:jitsiWidgetData];

		void (^verifyConferenceId)(void) = ^() {
			if (!self.conferenceId) {
				// Else try v1
				[self extractWidgetDataFromUrlString:widgetUrl];
			}

			if (self.conferenceId) {
				if (success) { success(self.conferenceId, self.jwtToken, self.serverUrl); }
			} else {
				if (failure) { failure(nil); }
			}
		};

		// Check if the widget requires authentication
		if ([self isOpenIdJWTAuthenticationRequiredFor:jitsiWidgetData]) {
			NSString *roomId = self.widget.roomId;
			MXSession *session = self.widget.session;

			MXWeakify(self);

			// Retrieve the OpenID token and generate the JWT token
			[self getOpenIdJWTTokenWithJitsiServerDomain:jitsiWidgetData.domain
												  roomId:roomId
										   matrixSession:session
												 success:^(NSString * _Nonnull jwtToken) {
				MXStrongifyAndReturnIfNil(self);

				self.jwtToken = jwtToken;
				verifyConferenceId();
			} failure:^(NSError * _Nonnull error) {
				if (failure) { failure(error); }
			}];
		} else {
			verifyConferenceId();
		}

	}
											 failure:^{
		if (failure) { failure(nil); }
	}];
}

/// Get Jitsi JWT token using user OpenID token
- (nullable MXHTTPOperation *)getOpenIdJWTTokenWithJitsiServerDomain:(NSString *)jitsiServerDomain
															  roomId:(NSString *) roomId
													   matrixSession:(MXSession *)matrixSession
															 success:(void(^)(NSString *))success
															 failure:(void(^)(NSError *))failure {

	MXUser *myUser = self.room.mxSession.myUser;
	NSString *userDisplayName = myUser.displayname;
	if (!userDisplayName) { userDisplayName = myUser.userId; }

	NSString *avatarStringURL = myUser.avatarUrl;
	if(!avatarStringURL) { avatarStringURL = @""; }

	return [self.room.mxSession.matrixRestClient openIdToken:^(MXOpenIdToken *tokenObject) {

		if (!tokenObject || !tokenObject.accessToken) {
			NSError *error = [NSError new];
			if (failure) { failure(error); }
			return;
		}

		@try {
			NSString *jwtToken = [self.jwtTokenBuilder buildWithJitsiServerDomain:jitsiServerDomain
																	  openIdToken:tokenObject
																		   roomId:roomId
																	userAvatarUrl:avatarStringURL
																  userDisplayName:userDisplayName
																			error:nil];
			success(jwtToken);
		}
		@catch (NSException *exception) {
			NSError *error = [NSError new];
			if (failure) { failure(error); }
		}
		@finally { }
	}
													 failure:failure];
}

/// Check if Jitsi widget requires "openidtoken-jwt" authentication
- (BOOL)isOpenIdJWTAuthenticationRequiredFor:(JitsiWidgetData *)jitsiWidgetData {
//	return [jitsiWidgetData.authenticationType isEqualToString:JistsiConstants.openIDTokenJWT];
	return NO;
}

// Fill Jitsi data based on Matrix Widget V2 widget data
- (void)fillWithWidgetData:(JitsiWidgetData*)jitsiWidgetData
{
	if (jitsiWidgetData) {
		self.conferenceId = jitsiWidgetData.conferenceId;
		if (jitsiWidgetData.domain) {
            NSString *serverUrlString;
            if ([jitsiWidgetData.domain containsString:@"http"]) {
                serverUrlString = jitsiWidgetData.domain;
            } else {
                serverUrlString = [NSString stringWithFormat:@"https://%@", jitsiWidgetData.domain];
            }
			self.serverUrl = [NSURL URLWithString:serverUrlString];
		}
		self.startWithVideo = !jitsiWidgetData.isAudioOnly;
	}
}

// Extract data based on Matrix Widget V1 URL
- (void)extractWidgetDataFromUrlString:(NSString*)widgetUrlString
{
	// Extract the jitsi conference id from the widget url
	NSString *confId;
	NSURL *url = [NSURL URLWithString:widgetUrlString];
	if (url) {
		NSURLComponents *components = [[NSURLComponents new] initWithURL:url resolvingAgainstBaseURL:NO];
		NSArray *queryItems = [components queryItems];

		for (NSURLQueryItem *item in queryItems) {
			if ([item.name isEqualToString:@"confId"]) {
				confId = item.value;
				break;
			}
		}
	}
	self.conferenceId = confId;
}

@end
