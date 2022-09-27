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

#import "MXToDeviceSyncResponse.h"

#import "MXEvent.h"

@implementation MXToDeviceSyncResponse

+ (id)modelFromJSON:(NSDictionary *)JSONDictionary
{
    MXToDeviceSyncResponse *toDeviceSyncResponse = [[MXToDeviceSyncResponse alloc] init];
    if (toDeviceSyncResponse)
    {
        MXJSONModelSetMXJSONModelArray(toDeviceSyncResponse.events, MXEvent, JSONDictionary[@"events"]);
    }
    return toDeviceSyncResponse;
}

- (NSDictionary *)JSONDictionary
{
    NSMutableDictionary *JSONDictionary = [NSMutableDictionary dictionary];
    
    NSMutableArray *jsonEvents = [NSMutableArray arrayWithCapacity:self.events.count];
    for (MXEvent *event in self.events)
    {
        [jsonEvents addObject:event.JSONDictionary];
    }
    JSONDictionary[@"events"] = jsonEvents;
    
    return JSONDictionary;
}

@end
