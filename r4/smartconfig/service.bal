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
import ballerina/time;
import ballerinax/health.fhir.r4;

## The service representing well known API
final readonly & SmartConfiguration smartConfiguration = check generateSmartConfiguration().cloneReadOnly();

# The service representing well known API
# Bound to port defined by configs

service http:InterceptableService / on new http:Listener(9090) {

    public function createInterceptors() returns r4:FHIRResponseErrorInterceptor {
        return new r4:FHIRResponseErrorInterceptor();
    }

    # The authorization endpoints accepted by a FHIR resource server are exposed as a Well-Known Uniform Resource Identifiers (URIs) (RFC5785) JSON document.
    # Reference: https://build.fhir.org/ig/HL7/smart-app-launch/conformance.html#using-well-known
    # + return - Smart configuration
    resource isolated function get fhir/r4/\.well\-known/smart\-configuration() returns json|r4:FHIRError {
        json|error response = smartConfiguration.toJson();

        if response is json {
            LogDebug("Smart configuration served at " + time:utcNow()[0].toString());
            return response;
        } else {
            return r4:createFHIRError(response.message(), r4:FATAL, r4:TRANSIENT_EXCEPTION, response.detail().toString(), cause = response);
        }
    }
}
