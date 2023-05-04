// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com).

// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/test;
import ballerina/time;

import ballerinax/health.fhir.r4;

@test:Config {enable: true}
function testFetchRecentlyUpdatedResources() {
    do {
        time:Utc now = check time:utcFromString("2023-03-31T06:53:13.829+00:00");
        time:Utc lastInvocation = check time:utcFromString("2023-02-20T06:53:13.829+00:00");
        r4:FHIRResourceEntity[] entities = check fetchRecentlyUpdatedResources(lastInvocation, now);

        if (entities.length()==0) {
            test:assertTrue(false, "fetchRecentlyUpdatedResources() returned empty r4:FHIRResourceEntity array. Either function not working properly or there were no resources updated between the given time bounds.");
        }
        foreach r4:FHIRResourceEntity entity in entities {
            json 'resource = check entity.toJson();
            string lastUpdated = check 'resource.meta.lastUpdated;
            time:Utc lastUpdatedUtc = check time:utcFromString(lastUpdated);
            boolean flag = lastUpdatedUtc>lastInvocation && lastInvocation<now;
            test:assertTrue(flag, "fetchRecentlyUpdatedResources() not working properly");
        }
        test:assertTrue(true);
    }
    on fail error e {
        test:assertTrue(false, msg = string `failed fetching recently updated resources ${e.message()}`);
    }
}
