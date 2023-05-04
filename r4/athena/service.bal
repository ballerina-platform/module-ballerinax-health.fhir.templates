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

configurable string base = ?;
configurable string tokenUrl = ?;
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string[] scopes = ?;
configurable string customDomain = ?;

http:OAuth2ClientCredentialsGrantConfig athenahealthOauth = {
    tokenUrl: tokenUrl,
    clientId: clientId,
    clientSecret: clientSecret,
    scopes: scopes
};

fhir:FHIRConnectorConfig athenahealthConfig = {
    baseURL: base,
    mimeType: fhir:FHIR_JSON,
    authConfig: athenahealthOauth
};

final fhir:FHIRConnector fhirConnectorObj = check new (athenahealthConfig);

@http:ServiceConfig{
    interceptors: [new fhir:URLRewriteInterceptor(base, customDomain)]
}
service http:Service / on new http:Listener(9090) {
    
    // Get resource by ID
    isolated resource function get fhir/r4/[string resType]/[string id]() returns http:Response {
        
        fhir:FHIRResponse|fhir:FHIRError fhirResponse = fhirConnectorObj->getById(resType, id);
        return fhir:handleResponse(fhirResponse);
    }

    // Create a resource
    isolated resource function post fhir/r4/[string resType](@http:Payload json|xml resPayload) returns http:Response {
        
        string|error rtype = fhir:extractResourceType(resPayload);
        if rtype is error {
            return fhir:handleError(string `${rtype.message()} : ${resType}`, http:STATUS_BAD_REQUEST);
        }
        if (rtype != resType) {
            return fhir:handleError("Request payload mismatch with requested resource.");
        }
        fhir:FHIRResponse|fhir:FHIRError fhirResponse = fhirConnectorObj->create(resPayload);
        return fhir:handleResponse(fhirResponse);
    }

    // Patch a resource
    isolated resource function patch fhir/r4/[string resType]/[string id](http:Request request, @http:Payload json|xml resPayload) returns http:Response {
        
        fhir:PatchContentType patchType;
        string contentType = request.getContentType();
        if (contentType is fhir:PatchContentType) {
            patchType = <fhir:PatchContentType>contentType;
        } else {
            return fhir:handleError(string `Unsupported Patch Content Type : ${contentType}`);
        }
        fhir:FHIRResponse|fhir:FHIRError fhirResponse = fhirConnectorObj->patch(resType, id, resPayload, patchContentType = patchType);
        return fhir:handleResponse(fhirResponse);
    }

    // Delete a resource
    isolated resource function delete fhir/r4/[string resType]/[string id]() returns http:Response {
        
        fhir:FHIRResponse|fhir:FHIRError fhirResponse = fhirConnectorObj->delete(resType, id);
        return fhir:handleResponse(fhirResponse);
    }

    // Update a resource
    isolated resource function put fhir/r4/[string resType](@http:Payload json|xml resPayload) returns http:Response {
        
        string|error rtype = fhir:extractResourceType(resPayload);
        if rtype is error {
            return fhir:handleError(string `${rtype.message()} : ${resType}`, http:STATUS_BAD_REQUEST);
        }
        if (rtype != resType) {
            return fhir:handleError("Request payload mismatch with requested resource.");
        }
        fhir:FHIRResponse|fhir:FHIRError fhirResponse = fhirConnectorObj->update(resPayload);
        return fhir:handleResponse(fhirResponse);
    }

    // Get metadata
    isolated resource function get fhir/r4/metadata(http:Request r) returns http:Response {
        
        fhir:FHIRResponse|fhir:FHIRError fhirResponse = fhirConnectorObj->getConformance();
        return fhir:handleResponse(fhirResponse);
    }

    // Search through a resource type
    isolated resource function get fhir/r4/[string resType](http:Request request) returns http:Response {
        
        fhir:FHIRResponse|fhir:FHIRError fhirResponse = fhirConnectorObj->search(resType, request.getQueryParams());
        return fhir:handleResponse(fhirResponse);
    
    }

    isolated resource function 'default [string... paths](http:Request req) returns http:Response {
        return fhir:handleError("Unsupported");
    }
}
