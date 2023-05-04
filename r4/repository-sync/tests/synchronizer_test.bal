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

import ballerina/http;
import ballerina/log;
import ballerina/test;
import ballerina/time;

import ballerinax/health.fhir.r4;

string testServerBaseUrl = "/fhir_test_server/r4";
string localhost = "http://localhost:8080";

listener http:Listener listenerEP = check new (8080);

@test:BeforeSuite
function setup() returns error? {
    check listenerEP.attach(FhirMockService, testServerBaseUrl);
    check listenerEP.'start();
    log:printInfo("FHIR mock service has started");

}

@test:Config {enable: true}
function testSynchronizeFhirRepository() {
    do {
        time:Utc now = check time:utcFromString("2023-03-31T06:53:13.829+00:00");
        time:Utc lastInvocation = check time:utcFromString("2023-03-20T06:53:13.829+00:00");
        error? result = synchronizeFhirRepository(lastInvocation, now);

        if (result is error) {
            test:assertTrue(false, "error while fhir bundle transaction");
        }
        test:assertTrue(true);
    }
    on fail error e {
        test:assertTrue(false, msg = string `failed synchronizing fhir repository ${e.message()}`);
    }
}

@test:Config {enable: true}
function testPrepareBundleEntry() {
    do {
        time:Utc now = check time:utcFromString("2023-03-20T05:12:23.588+00:00");
        time:Utc lastInvocation = check time:utcFromString("2019-09-27T05:12:23.588+00:00");
        r4:FHIRResourceEntity[] recentlyUpdatedResources = check fetchRecentlyUpdatedResources(lastInvocation, now);

        r4:BundleEntry[] bundleEntry = [];

        // Transform r4:FHIRResourceEntity to r4:BundleEntry
        _ = check prepareBundleEntry(bundleEntry, recentlyUpdatedResources, r4:PUT);

        foreach r4:BundleEntry entry in bundleEntry {
            r4:FHIRWireFormat 'resource = <r4:FHIRWireFormat>entry?.'resource;
            if ('resource == ()) {
                test:assertTrue(false, "found empty resource in bundle");
            }

            string|json resourceType = check 'resource.resourceType;
            string|json id = check 'resource.id;

            r4:FHIRWireFormat request = <r4:FHIRWireFormat>entry?.request;
            json method = check request?.method;
            json url = check request?.url;
            if (method != r4:PUT || url != string `${resourceType.toString()}/${id.toString()}`) {
                test:assertTrue(false, "found error in bundle");
            }
        }
        test:assertTrue(true);
    }
    on fail error e {
        test:assertTrue(false, msg = string `failed preparing bundle entry ${e.message()}`);
    }
}

@test:AfterSuite
function teardown() returns error? {
    check listenerEP.gracefulStop();
    log:printInfo("FHIR mock service has stopped");

}
