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

import health.fhir.templates.r4.smartconfiguration.constants;
import health.fhir.templates.r4.smartconfiguration.handlers;
import health.fhir.templates.r4.smartconfiguration.models;
import ballerina/http;

# Generator function for Operation Outcome resource
# + issueHandler - Issue handler for issues
# + return - Operation Outcome resource
public isolated function generateOperationOutcomeResource(handlers:IssueHandler issueHandler) returns models:OperationOutcome {
    handlers:LogHandler logHandler = new ("OperationOutcomeGenerator");
    logHandler.Debug("Generating operation outcome started");

    if issueHandler.getIssues() == [] {
        issueHandler.addServiceError(createServiceError(constants:WARNING, constants:NOT_FOUND, error(constants:NO_ISSUES_OP_OUTCOME)));
    }

    models:OperationOutcome operationOutcome = {
        resourceType: constants:OPERATION_OUTCOME,
        issue: []
    };

    logHandler.Debug("Populating operation outcome");

    foreach models:Issue issue in issueHandler.getIssues() {
        operationOutcome.issue.push(issue);
    }

    logHandler.Debug("Generating operation outcome ended");
    return operationOutcome;
}

# Method to handle service errors
#
# + issueHandler - Parameter Description
# + return - internal server error  occured
public isolated function handleServiceErrors(handlers:IssueHandler issueHandler) returns http:InternalServerError {
    models:OperationOutcome operationOutcome = generateOperationOutcomeResource(issueHandler);
    http:InternalServerError errorMessage = {
        mediaType: "application/fhir+json",
        body: operationOutcome
    };
    return errorMessage;
}

# Creates service error
# + severity - service error severity  
# + code - service error code  
# + err - error  
# + message - service error message
# + return - service error
public isolated function createServiceError(constants:IssueSeverity severity, constants:IssueType code, error err,
        string message = constants:CONTACT_SERVER_ADMIN) returns models:ServiceError {
    models:ServiceError serviceError = {
        severity: severity,
        code: code,
        message: message,
        err: err
    };
    return serviceError;
}

# send fhir response method
#
# + payload - json payload
# + return - fhir+json response
public isolated function handleSuccessResponse(anydata payload) returns http:Ok {
    http:Ok reponse = {
        mediaType: "application/json",
        body: payload
    };
    return reponse;
}
