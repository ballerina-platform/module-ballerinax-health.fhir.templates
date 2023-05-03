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
//
//
// AUTO-GENERATED FILE. DO NOT MODIFY.
//
// This file is auto-generated by Ballerina Team for managing utility functions.
// It should not be modified by hand.

import ballerinax/health.fhir.r4;
import ballerina/lang.value;
import ballerina/log;
import ballerina/http;

isolated final readonly & r4:FHIRSourceConnectInteraction srcConnectImpl = {
    read: encounterReadImpl,
    search: encounterSearchImpl,
    create: encounterCreateImpl
};
//Default profile is set to International Resource URL
final readonly & string defaultProfile = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter";

isolated function encounterSearchImpl(map<r4:RequestSearchParameter[]> params, http:RequestContext ctx) returns r4:BundleEntry[]|r4:FHIRError {

    lock {
        r4:FHIRContext fhirContext = check r4:getFHIRContext(ctx);

        value:Cloneable|object {} activeProfile = defaultProfile;

        // Since profile based function implementation is applied for search operation, 
        // active profile is retreived from the context.
        if fhirContext.getRequestSearchParameters().hasKey("_profile") {
            activeProfile = ctx.get("_OH_activeProfile");
        }

        EncounterSourceConnect sourceConnect = profileImpl.get(defaultProfile);
        if activeProfile is string {
            log:printDebug(string `[SearchImpl] Current profile is  ${activeProfile}`);
            sourceConnect = profileImpl.get(activeProfile);
        }
        log:printDebug(string `[SearchImpl] Calling source system with parameters  ${params.toBalString()}`);
        r4:Bundle|Encounter[] encounters = check sourceConnect.search(params.clone(), fhirContext);
        r4:BundleEntry[] entries = [];

        if encounters is r4:Bundle {
            entries = encounters.entry ?: [];
        } else if encounters is Encounter[] {
            foreach Encounter item in encounters {
                r4:BundleEntry entry = {
                    fullUrl: "",
                    'resource: item
                };
                entries.push(entry);
            }
        }
        log:printDebug(string `[SearchImpl] Resultant entries list:  ${entries.toJsonString()}`);
        return entries.clone();
    }
}

isolated function encounterReadImpl(string id, http:RequestContext ctx) returns r4:FHIRResourceEntity|r4:FHIRError {

    lock {
        log:printDebug(string `[ReadImpl] Calling source system with Id:  ${id}`);
        EncounterSourceConnect sourceConnect = profileImpl.get(defaultProfile);
        r4:FHIRContext fhirContext = check r4:getFHIRContext(ctx);

        Encounter encounter = check sourceConnect.read(id, fhirContext);
        log:printDebug(string `[ReadImpl] Retrieved resource:  ${encounter.toJsonString()}`);

        return new (encounter);
    }
}

isolated function encounterCreateImpl(r4:FHIRResourceEntity resourceEntity, http:RequestContext ctx) returns string|r4:FHIRError {

    lock {
        EncounterSourceConnect sourceConnect = profileImpl.get(defaultProfile);
        value:Cloneable resourceRecord = resourceEntity.unwrap();

        if resourceRecord is Encounter {
            log:printDebug(string `[CreateImpl] Request payload: ${resourceRecord.toString()}`);
            r4:FHIRContext fhirContext = check r4:getFHIRContext(ctx);
            string|r4:FHIRError createResponse = check sourceConnect.create(resourceEntity, fhirContext);
            return createResponse;
        } else {
            string diagMsg = string `Expected r4:Encounter FHIR resource model not found. Instead, found a model of type:" ${(typeof resourceRecord).toBalString()}`;
            return r4:createInternalFHIRError("Incoming r4:Encounter resource model not found", r4:ERROR, r4:PROCESSING_NOT_FOUND, diagnostic = diagMsg);
        }
    }
}

public type EncounterSourceConnect object {
    isolated function profile() returns r4:uri;
    isolated function read(string id, r4:FHIRContext ctx) returns Encounter|r4:FHIRError;
    isolated function search(map<r4:RequestSearchParameter[]> searchParameters, r4:FHIRContext ctx) returns r4:Bundle|Encounter[]|r4:FHIRError;
    isolated function create(r4:FHIRResourceEntity encounter, r4:FHIRContext ctx) returns string|r4:FHIRError;
};

public type ProfileImplementations record {
    map<EncounterSourceConnect> sourceConnectImplementations;
};
