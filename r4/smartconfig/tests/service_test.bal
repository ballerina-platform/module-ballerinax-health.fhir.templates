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
import health.fhir.templates.r4.smartconfiguration.constants;
import health.fhir.templates.r4.smartconfiguration.handlers;
import health.fhir.templates.r4.smartconfiguration.models;

const test_port = 6060;

http:Client testClient = check new ("http://localhost:" + test_port.toString());

service "test/.well-known/smart-configuration" on new http:Listener(test_port) {

    # A resource for generating smart configuration
    # + return - smart configuration as a json
    resource function get .() returns json|http:InternalServerError {
        SmartConfigurationGenerator generator = new ();
        handlers:IssueHandler issueHandler = new ("Tests");
        do {
            models:SmartConfiguration|error response = check trap generator.generate();
            if response is error {
                issueHandler.addServiceError(createServiceError(constants:ERROR, constants:PROCESSING, response));
                return handleServiceErrors(issueHandler);
            }
            return response.toJson();
        } on fail var err {
            issueHandler.addServiceError(createServiceError(constants:FATAL, constants:PROCESSING, err));
            return handleServiceErrors(issueHandler);
        }
    }

    # A resource for generating capability statement
    # + return - capability statement as a json
    resource function get err() returns json|http:InternalServerError {
        handlers:IssueHandler issueHandler = new ("Tests");
        do {
            json|error response = check trap self.sendError();
            if response is error {
                issueHandler.addServiceError(createServiceError(constants:ERROR, constants:PROCESSING, response));
                return handleServiceErrors(issueHandler);
            }
            return response;
        } on fail var err {
            issueHandler.addServiceError(createServiceError(constants:FATAL, constants:PROCESSING, err));
            return handleServiceErrors(issueHandler);
        }
    }

    function sendError() returns json|error? {
        panic error("This is a custom error");
    }
}

@test:Config {groups: ["Service"]}
function testService() returns error? {
    http:Client testClient = check new ("http://localhost:" + test_port.toString());
    json|error response = testClient->get("/.well-known/smart-configuration");
    if response is json {
        test:assertTrue(true, "Test service success");
    } else {
        test:assertFail(response.message());
    }
}

@test:Config {groups: ["Service"]}
function testServiceWithSample() returns error? {
    json|error response = testClient->get("/test/.well-known/smart-configuration");
    json sampleResponse = check io:fileReadJson("./modules/sample/sample_smart_configuration.json");
    test:assertEquals(response, sampleResponse);
}

@test:Config {groups: ["Service"]}
function testServiceWithSampleError() returns error? {
    http:Response response = check testClient->get("/test/.well-known/smart-configuration/err");
    json customError = {
        "issue": [
            {
                "severity": "fatal",
                "code": "exception",
                "diagnostics": "This is a custom error"
            }
        ]
    };
    test:assertEquals(response.getJsonPayload(), customError);
}

handlers:IssueHandler issueHandler = new ("test");

@test:Config {groups: ["Handler"]}
function testErrorHandlerError() returns error? {
    do {
        issueHandler.addServiceError(createServiceError(constants:ERROR, constants:EXCEPTION, error("Test Error")));

        issueHandler.addServiceError(createServiceError(constants:WARNING, constants:EXCEPTION, error("Test Error")));

        issueHandler.addServiceError(createServiceError(constants:FATAL, constants:EXCEPTION, error("Test Fatal")));

        issueHandler.addServiceError(createServiceError(constants:INFORMATION, constants:EXCEPTION, error("Test Information")));

        test:assertTrue(true, "Error success");
    } on fail var err {
        test:assertFalse(false, err.message());
    }
}

@test:Config {groups: ["Handler"]}
function testLogHandlerDebug() returns error? {
    handlers:LogHandler logHandler = new ("test");
    do {
        logHandler.Debug("This is a test debug");
        test:assertTrue(true, "Debug log success");
    } on fail var err {
        test:assertFalse(false, err.message());
    }
}

SmartConfigurationGenerator generator = new ();

@test:Config {groups: ["Generator"]}
function testGeneratorReadFromConfig() returns error? {
    models:SmartConfiguration|error config = trap generator.generate();

    if config is models:SmartConfiguration {
        test:assertTrue(true, "Test read from config success");
    } else {
        test:assertFail("Test Failed");
    }
}

@test:Config {groups: ["Generator"]}
function testGenerateCapabilityStatement() returns error? {
    models:SmartConfiguration|error system = trap generator.generate();

    if system is models:SmartConfiguration {
        test:assertTrue(true, "Test generate capability statement success");
    } else {
        test:assertFail("Test Failed");
    }
}
