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

import ballerina/io;
import ballerina/http;
import ballerina/test;
import health.fhir.templates.r4.metadata.constants;
import health.fhir.templates.r4.metadata.samples;
import health.fhir.templates.r4.metadata.models;

# A resource for generating capability statement
# + return - capability statement as a json
function testError() returns anydata {
    CapabilityStatementGenerator generator = new ("tests/error_resources.json");

    do {
        models:CapabilityStatement|error response = check generator.generate();
        if response is error {
            issueHandler.addServiceError(createServiceError(constants:ERROR, constants:PROCESSING, response));
            return handleServiceErrors(issueHandler)?.body;
        }
        return response;
    } on fail var err {
        issueHandler.addServiceError(createServiceError(constants:ERROR, constants:PROCESSING, err));
        return handleServiceErrors(issueHandler)?.body;
    }
}

# A resource for generating capability statement
# + return - capability statement as a json
function testEmpty() returns anydata {
    CapabilityStatementGenerator generator = test:mock(CapabilityStatementGenerator);
    test:prepare(generator).when("generateCapabilityStatement").thenReturn(mockGenerateCapabilityStatement());
    do {
        models:CapabilityStatement|error response = generator.generate();
        if response is error {
            issueHandler.addServiceError(createServiceError(constants:ERROR, constants:PROCESSING, response));
            return handleServiceErrors(issueHandler)?.body;
        }
        return response;
    } on fail var err {
        issueHandler.addServiceError(createServiceError(constants:ERROR, constants:PROCESSING, err));
        return handleServiceErrors(issueHandler)?.body;
    }
}

@test:Config {groups: ["Service"]}
function testService() returns error? {
    http:Client clientEndpoint = check new ("http://localhost:9090");
    json|error response = clientEndpoint->get("/metadata");
    if response is json {
        test:assertTrue(true);
    } else {
        test:assertTrue(false);
    }
}

@test:Config {groups: ["Service"]}
function testServiceFatalError() returns error? {
    http:Client clientEndpoint = check new ("http://localhost:9090");
    json|error response = clientEndpoint->get("/metadata");
    if response is json {
        test:assertTrue(true);
    } else {
        test:assertTrue(false);
    }
}

@test:Config {groups: ["Service"]}
function testServiceWithSample() returns error? {
    http:Client clientEndpoint = test:mock(http:Client);
    test:prepare(clientEndpoint).when("get").thenReturn(samples:buildCapabilityStatement());
    json|error response = clientEndpoint->get("/metadata");
    json sampleResponse = check io:fileReadJson("./modules/samples/sample_capability_statement.json");
    test:assertEquals(response, sampleResponse);
}

@test:Config {groups: ["Service"]}
function testServiceWithSampleError() returns error? {
    http:Client clientEndpoint = test:mock(http:Client);
    test:prepare(clientEndpoint).when("get").thenReturn(testError());
    models:OperationOutcome|error response = clientEndpoint->get("/metadata");

    if response is models:OperationOutcome {
        test:assertTrue(true);
    } else {
        test:assertFail("Assert failed");
    }
}

public function mockGenerateCapabilityStatement() returns json|error {
    models:CapabilityStatement|error capabilityStatement = mockReadFromConfigs();
    if capabilityStatement is error {
        issueHandler.addServiceError(createServiceError(constants:ERROR, constants:PROCESSING, capabilityStatement));
        return capabilityStatement;
    } else {
        return capabilityStatement.toJson();
    }
}

# method to build capability statement from metadata configurables
# + return - capabilitity statement json object
function mockReadFromConfigs() returns models:CapabilityStatement|error {
    models:CapabilityStatement capabilityStatement = {
        resourceType: constants:CAPABILITY_STATEMENT,
        status: "active",
        kind: "instance",
        fhirVersion: "4.0.1",
        date: "23/03/2022",
        format: [],
        patchFormat: [],
        rest: []
    };

    issueHandler.addServiceError(createServiceError(constants:ERROR, constants:PROCESSING, (error(constants:NO_FHIR_RESOURCES))));
    return capabilityStatement;
}

# method to build capability statement from system data
# + return - capabilitity statement json object
public isolated function SendError() returns json|error {
    panic error("Error");
}
