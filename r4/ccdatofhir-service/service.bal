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
import ballerina/log;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4utils.ccdatofhir;

# This service supports transform CCDA documents to FHIR based on the CCDA to FHIR mapping Implementation Guide.
# Link to the IG: http://hl7.org/fhir/us/ccda/2023May/CF-index.html
# The service is exposed at `/transform` path and the service is listening to HTTP requests at port `9090`.
service / on new http:Listener(9090) {

    # CCDA to FHIR transform service
    # + return - Transformed FHIR bundle for the given CCDA document.
    resource function post transform(http:RequestContext ctx, http:Request request) returns http:Response {

        xml|error xmlPayload = request.getXmlPayload();
        http:Response response = new;
        if xmlPayload is error {
            response.statusCode = http:STATUS_BAD_REQUEST;
            string diagnosticMsg = xmlPayload.message();
            error? cause = xmlPayload.cause();
            if cause is error {
                diagnosticMsg = cause.message();
            }
            r4:OperationOutcome operationOutcome = r4:errorToOperationOutcome(r4:createFHIRError(
                "Invalid xml document.", r4:CODE_SEVERITY_ERROR, r4:TRANSIENT_EXCEPTION, diagnostic = diagnosticMsg));
            log:printError(string `Invalid xml document.`, diagnosic = diagnosticMsg);
            response.setJsonPayload(operationOutcome.toJson());
            return response;
        }
        // Pass the xml payload to the CCDA to FHIR transform util function in the FHIR R4 utils package.
        r4:Bundle|r4:FHIRError ccdaToFhir = ccdatofhir:ccdaToFhir(xmlPayload);
        // If the success scenario, return the transformed FHIR bundle.
        if ccdaToFhir is r4:Bundle {
            response.statusCode = http:STATUS_OK;
            log:printDebug(string`Transformed message: ${ccdaToFhir.toJsonString()}`);
            response.setJsonPayload(ccdaToFhir.toJson());
            return response;
        }
        log:printError("Error occurred in CCDA to FHIR transformation.", ccdaToFhir);
        response.statusCode = http:STATUS_INTERNAL_SERVER_ERROR;
        response.setJsonPayload(r4:errorToOperationOutcome(ccdaToFhir).toJson());
        return response;
    }
}
