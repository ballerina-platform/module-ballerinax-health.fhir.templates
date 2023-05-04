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

import ballerinax/health.clients.fhir;

// Mock service that responds to fhir bundle transactions
http:Service FhirMockService = service object {
    @http:ResourceConfig {
        consumes: ["application/fhir+json", "application/json"]
    }
    resource function post .(http:Request payload) returns http:Response {
        http:Response response = new;
        do {
            response.statusCode = http:STATUS_OK;
            json responsePayload = check payload.getJsonPayload();
            responsePayload = check responsePayload.mergeJson({ id: "00bae8c1-c161-4d37-9b5b-bceef5ebbead" });
            response.setPayload(responsePayload, fhir:FHIR_JSON);
        } on fail var e {
            response.statusCode = http:STATUS_BAD_REQUEST;
            response.setPayload({err: e.message()}, fhir:FHIR_JSON);
        }
        return response;
    }
};
