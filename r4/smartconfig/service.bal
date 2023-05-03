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
import ballerina/time;
import ballerina/http;

SmartConfigurationGenerator smartConfigurationGenerator = new ();
final readonly & models:SmartConfiguration smartConfiguration = check smartConfigurationGenerator.generate().cloneReadOnly();

service class ServiceErrorInterceptor {
    *http:ResponseErrorInterceptor;
    remote function interceptResponseError(error err) returns http:InternalServerError {
        handlers:IssueHandler issueHandler = new ("Service");
        issueHandler.addServiceError(createServiceError(constants:FATAL, constants:PROCESSING, err, constants:INTERNAL_SERVER_ERROR));
        return handleServiceErrors(issueHandler);
    }
}

# The service representing well known API
# Bound to port defined by configs
# Service response error interceptor
ServiceErrorInterceptor serviceErrorInterceptor = new ();

# The service representing well known API
# Bound to port defined by configs
@http:ServiceConfig {
    interceptors: [serviceErrorInterceptor]
}
service / on new http:Listener(9090) {

    # The authorization endpoints accepted by a FHIR resource server are exposed as a Well-Known Uniform Resource Identifiers (URIs) (RFC5785) JSON document.
    # Reference: https://build.fhir.org/ig/HL7/smart-app-launch/conformance.html#using-well-known
    # + return - Smart configuration
    resource isolated function get fhir/r4/\.well\-known/smart\-configuration() returns http:Ok|http:InternalServerError {
        handlers:IssueHandler issueHandler = new ("Service");
        handlers:LogHandler logHandler = new ("Service");

        json|error response = smartConfiguration.toJson();

        if response is json {
            logHandler.Debug("Smart configuration served at " + time:utcNow()[0].toString());
            return handleSuccessResponse(response);
        } else {
            issueHandler.addServiceError(createServiceError(constants:FATAL, constants:PROCESSING, response, constants:INTERNAL_SERVER_ERROR));
            return handleServiceErrors(issueHandler);
        }
    }
}
