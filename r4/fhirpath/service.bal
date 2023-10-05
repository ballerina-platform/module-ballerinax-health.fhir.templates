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
import ballerinax/health.fhir.r4utils.fhirpath as fhirpath;

# A service representing a network-accessible API for the fhirpath evaluation.
# Bound to port `9090`.
service / on new http:Listener(9090) {

    # API to evaluate Fhirpath expressions.
    #
    # + fhirPathRequest - Request for the API
    # + return - Result Map of Fhirpath evaluations
    isolated resource function post fhirpath (@http:Payload FhirPathRequest fhirPathRequest) returns http:Response {
        map<fhirpath:FhirPathResult> outcome = {};
        map<json> fhirResource = fhirPathRequest.fhirResource;
        string[]|string fhirPath = fhirPathRequest.fhirPath;

        if fhirPath is string[] {
            foreach string individualFhirPath in fhirPath {
                outcome[individualFhirPath] = fhirpath:getFhirPathResult(fhirResource, individualFhirPath);
            }

        } else {
            outcome[fhirPath] = fhirpath:getFhirPathResult(fhirResource, fhirPath);
        }
        http:Response response = new;
        response.setJsonPayload(outcome.toJson());
        return response;
    }
}

# Record to hold FhirPath request parameters.
#
# + fhirResource - Fhir Resource
# + fhirPath - Fhir Path
public type FhirPathRequest record {|
    map<json> fhirResource;
    string[]|string fhirPath;
|};
