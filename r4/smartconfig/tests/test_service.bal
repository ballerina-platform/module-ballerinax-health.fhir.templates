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
import ballerina/test;

@test:Config {groups: ["Service"]}
function testService() returns error? {
    http:Client testClient = check new ("https://127.0.0.1:9090");
    json|error response = testClient -> /fhir/r4/\.well\-known/smart\-configuration;
    if response is error {
        test:assertFail(response.message());
    }
    test:assertTrue(true, "Test service success");
}

@test:Config {groups: ["Service"]}
function testServiceWithSample() returns error? {
    http:Client testClient = check new ("http://127.0.0.1:9090");
    json|error response = testClient -> /fhir/r4/\.well\-known/smart\-configuration;
    if response is error {
        test:assertFail(response.message());
    }
    test:assertTrue(true, "Test service success");
}

@test:Config {groups: ["Service"]}
function testServiceWithSampleError() returns error? {
    http:Client testClient = check new ("http://127.0.0.1:9090");
    http:Response response = check testClient -> /fhir/r4/\.well\-known/smart\-configuration.post(message = "");
    json payload = check response.getJsonPayload();
    string resourceType = check payload.resourceType;
    test:assertEquals(resourceType, "OperationOutcome");
}
