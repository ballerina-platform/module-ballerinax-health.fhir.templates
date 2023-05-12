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
import wso2healthcare/healthcare.fhir.r4;

# A resource for generating capability statement
# + return - capability statement as a json
function testError() returns r4:FHIRError {
    error response = error("Test Error");
    return r4:createFHIRError(response.message(), r4:FATAL, r4:TRANSIENT_EXCEPTION, response.detail().toString(), cause = response);
}

@test:Config {groups: ["Service"]}
function testService() returns error? {
    http:Client clientEndpoint = check new ("http://localhost:9090");
    http:Response _ = check clientEndpoint->get("/fhir/r4/metadata");
}

@test:Config {groups: ["Service"]}
function testServiceFatalError() returns error? {
    http:Client clientEndpoint = check new ("http://localhost:9090");
    json|error response = clientEndpoint->get("/fhir/r4/metadata");
    if response is json {
        test:assertTrue(true);
    } else {
        test:assertTrue(false);
    }
}

@test:Config {groups: ["Service"]}
function testServiceWithSample() returns error? {
    r4:CapabilityStatement sampleCapabilityStatement = {
        resourceType: CAPABILITY_STATEMENT,
        status: "active",
        kind: "instance",
        fhirVersion: "4.0.1",
        date: "23/03/2022",
        format: ["json"],
        patchFormat: [],
        rest: []
    };
    http:Client clientEndpoint = test:mock(http:Client);
    test:prepare(clientEndpoint).when("get").thenReturn(sampleCapabilityStatement);
    r4:CapabilityStatement response = check clientEndpoint->get("/fhir/r4/metadata");
    test:assertEquals(response, sampleCapabilityStatement);
}

public function mockGenerateCapabilityStatement() returns r4:CapabilityStatement|error {
    r4:CapabilityStatement capabilityStatement = check mockReadFromConfigs();
    return capabilityStatement;
}

# method to build capability statement from metadata configurables
# + return - capabilitity statement json object
function mockReadFromConfigs() returns r4:CapabilityStatement|error {
    return {
        resourceType: CAPABILITY_STATEMENT,
        status: "active",
        kind: "instance",
        fhirVersion: "4.0.1",
        date: "23/03/2022",
        format: [],
        patchFormat: [],
        rest: []
    };
}
