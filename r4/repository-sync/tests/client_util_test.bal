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

@test:Config {enable: false}
function testFetchLastInvocationTime() {
    time:Utc|error lastInvocationTime = fetchLastInvocationTime();
    if (lastInvocationTime is error) {
        test:assertTrue(false, msg = "error in fetching last invocation time of the scheduler");
    }
    test:assertTrue(true);
}

@test:Config {enable: false}
function testPushCurrentInvocationTime() {
    time:Utc now = time:utcNow();
    error? lastInvocationTime = pushCurrentInvocationTime(now);
    if (lastInvocationTime is error) {
        test:assertTrue(false, msg = "error in pushing current invocation time of the scheduler");
    }
    test:assertTrue(true);
}

@test:Config {enable: true}
function testProcessAndReturnBundleEntries() {
    r4:Patient patient = {
        resourceType: "Patient",
        id: "783035c",
        meta: {
            versionId: "1",
            lastUpdated: "2023-02-20T05:12:23.588+00:00",
            'source: "#QWJfEUiyIewNuZpa"
        },
        text: {
            status: "generated",
            div: "<div xmlns=\"http://www.w3.org/1999/xhtml\"><table class=\"hapiPropertyTable\"><tbody/></table></div>"
        },
        identifier: [
            {
                system: "urn:oid:1.2.36.146.595.217.0.1",
                value: "12345"
            }
        ],
        name: [
            {
                "family": "Chalmers",
                "given": [
                    "Peter",
                    "James"
                ]
            }
        ],
        gender: "male",
        birthDate: "1974-12-25"
    };

    r4:BundleEntry[] bundleEntry = [
        {
            'resource: patient
        }
    ];

    map<r4:BundleEntry[]>|error processedBundleEntries = processAndReturnBundleEntries(bundleEntry);
    if (processedBundleEntries is error || processedBundleEntries.length() < 1) {
        test:assertTrue(false, msg = "failed processing bundleEntry");
    }
    test:assertTrue(true);
}
