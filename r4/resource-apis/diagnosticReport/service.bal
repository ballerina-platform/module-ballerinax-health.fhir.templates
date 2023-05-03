// // Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com).

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
//
//
// AUTO-GENERATED FILE.
//
// This file is auto-generated by Ballerina Team for implementing resource functions.
// Developers are allowed modify this file as per the requirement.

import ballerina/http;
import ballerina/log;
import ballerinax/health.fhir.r4;

# Generic type to wrap all implemented profiles. 
# Add required profile types here.
# public type DiagnosticReport r4:DiagnosticReport|<Other_DiagnosticReport_Profile>;
public type DiagnosticReport r4:DiagnosticReport;

//add implemented profiles to this map. profileURL:implementation
isolated final map<DiagnosticReportSourceConnect> profileImpl = {
    "http://hl7.org/fhir/StructureDefinition/DiagnosticReport": new InternationalDiagnosticReportSourceConnect()
};

# A service representing a network-accessible API
# bound to port `9090`.
@http:ServiceConfig {
    interceptors: [
        new r4:FHIRReadRequestInterceptor(apiConfig),
        new r4:FHIRCreateRequestInterceptor(apiConfig),
        new r4:FHIRSearchRequestInterceptor(apiConfig),
        new r4:FHIRRequestErrorInterceptor(),
        new r4:FHIRResponseInterceptor(apiConfig),
        new r4:FHIRResponseErrorInterceptor()
    ]
}
service / on new http:Listener(9090) {

    // Search the resource type based on some filter criteria.
    isolated resource function get fhir/r4/DiagnosticReport(http:RequestContext ctx, http:Request request) returns @http:Payload {mediaType: [r4:FHIR_MIME_TYPE_JSON, r4:FHIR_MIME_TYPE_XML]} json|xml|r4:FHIRError|error {

        r4:FHIRContext fhirContext = check r4:getFHIRContext(ctx);
        r4:RequestSearchParameter[]? & readonly profileUrls = fhirContext.getRequestSearchParameter("_profile");
        r4:FHIRRequest resourceName = <r4:FHIRRequest>fhirContext.getFHIRRequest();

        log:printDebug(string `FHIR API request is received. Interaction: SEARCH, [profiles]: ${profileUrls.toBalString()} 
        [resource]: ${resourceName.getResourceType().toBalString()}`);

        //Passing the Interaction processing to the r4 package with current context.
        r4:FHIRError? process = r4:processFHIRSourceConnections(srcConnectImpl, ctx);

        if process is error {
            log:printError("Error in source connection processing");
        }
        log:printDebug("[END]FHIR interaction : search");
        return;
    }
    // Read the current state of a resource by id.
    resource function get fhir/r4/DiagnosticReport/[string id](http:RequestContext ctx) returns @http:Payload {mediaType: [r4:FHIR_MIME_TYPE_JSON, r4:FHIR_MIME_TYPE_XML]} json|xml|r4:FHIRError {

        r4:FHIRContext fhirContext = check r4:getFHIRContext(ctx);
        r4:FHIRRequest resourceName = <r4:FHIRRequest>fhirContext.getFHIRRequest();

        log:printDebug(string `FHIR API request is received. Interaction: READ, 
        [resource]: ${resourceName.getResourceType().toBalString()}`);

        //Passing the Interaction processing to the r4 package with current context.
        r4:FHIRError? process = r4:processFHIRSourceConnections(srcConnectImpl, ctx);

        if process is error {
            log:printError("Error in source connection processing");
        }
        log:printDebug("[END]FHIR interaction : read");
        return;

    }
    // Create a new resource with a server assigned id.
    resource function post fhir/r4/DiagnosticReport(http:RequestContext ctx, http:Request request) returns @http:Payload {mediaType: [r4:FHIR_MIME_TYPE_JSON, r4:FHIR_MIME_TYPE_XML]} json|r4:FHIRError {

        r4:FHIRContext fhirContext = check r4:getFHIRContext(ctx);
        r4:FHIRRequest resourceName = <r4:FHIRRequest>fhirContext.getFHIRRequest();

        log:printDebug(string `FHIR API request is received. Interaction: CREATE, 
        [resource]: ${resourceName.getResourceType().toBalString()}`);

        //Passing the Interaction processing to the r4 package with current context.
        r4:FHIRError? process = r4:processFHIRSourceConnections(srcConnectImpl, ctx);

        if process is error {
            log:printError("Error in source connection processing");
        }
        log:printDebug("[END]FHIR interaction : create");
        return {};

    }

}
