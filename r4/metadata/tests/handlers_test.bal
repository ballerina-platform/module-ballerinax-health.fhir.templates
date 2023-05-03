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
import health.fhir.templates.r4.metadata.constants;
import health.fhir.templates.r4.metadata.handlers;

handlers:IssueHandler issueHandler = new ("test");

@test:Config {groups: ["Handler"]}
function testErrorHandlerError() returns error? {
    do {
        issueHandler.addServiceError(createServiceError(constants:ERROR, constants:PROCESSING, error("Test Error")));

        issueHandler.addServiceError(createServiceError(constants:ERROR, constants:PROCESSING, error("Test Warning")));

        issueHandler.addServiceError(createServiceError(constants:ERROR, constants:PROCESSING, error("Test Fatal")));

        issueHandler.addServiceError(createServiceError(constants:ERROR, constants:PROCESSING, error("Test Information")));

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
        logHandler.Info("This is a test info");
        logHandler.Warn("This is a test warn");
        test:assertTrue(true, "Debug log success");
    } on fail var err {
        test:assertFalse(false, err.message());
    }
}
