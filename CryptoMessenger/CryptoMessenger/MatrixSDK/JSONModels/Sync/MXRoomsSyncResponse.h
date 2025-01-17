// 
// Copyright 2021 The Matrix.org Foundation C.I.C
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "MXJSONModel.h"

@class MXRoomSync;
@class MXInvitedRoomSync;

NS_ASSUME_NONNULL_BEGIN

/**
 `MXRoomsSyncResponse` represents the rooms list in server sync response.
 */
@interface MXRoomsSyncResponse : MXJSONModel

/**
 Joined rooms: keys are rooms ids.
 */
@property (nonatomic, nullable) NSDictionary<NSString*, MXRoomSync*> *join;

/**
 Invitations. The rooms that the user has been invited to: keys are rooms ids.
 */
@property (nonatomic, nullable) NSDictionary<NSString*, MXInvitedRoomSync*> *invite;

/**
 Left rooms. The rooms that the user has left or been banned from: keys are rooms ids.
 */
@property (nonatomic, nullable) NSDictionary<NSString*, MXRoomSync*> *leave;

@end

NS_ASSUME_NONNULL_END
