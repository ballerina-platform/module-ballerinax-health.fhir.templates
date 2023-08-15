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
import ballerinax/health.fhir.r4;
import ballerina/log;

// This is done ONLY for reference and by no means for a production use case. 
// Customize this logic to suit your requirements.
// This uses sample in-memory data.

isolated function authorizePractitioners(string patientId, string practitionerId) returns r4:AuthzResponse {
    // This is a sample implementation using some dummy data and inmemory tables.
    map<string> filteredHospitalIds = patients.reduce(isolated function(map<string> hospitalIds, PatientTable patient) returns map<string> {
        if (patient.patientId == patientId) {
            // Filter all the matching patients and get the hospital ids.
            hospitalIds[patient.hospitalId] = patient.patientId;
        }
        return hospitalIds;
    }, {});
    // Filter all the matching practitioners.
    PractitionerTable[] practitionersHospitals = practitioners.filter(isolated function(PractitionerTable practitioner) returns boolean {
        return practitioner.practitionerId == practitionerId;
    });
    final map<string> & readonly hospitalIds = filteredHospitalIds.cloneReadOnly();
    // Check whether the practitioner is authorized to access the patient data.
    // Practitioner has to be registered in at least one hospital that the patient is registered in.
    foreach PractitionerTable practitioner in practitionersHospitals {
        if (hospitalIds.hasKey(practitioner.hospitalId)) {
            return {isAuthorized: true, scope: r4:PRACTITIONER};
        }
    }
    return {isAuthorized: false};
}

isolated function authorizePrivilegeUsers(r4:AuthzRequest authzRequest) returns r4:AuthzResponse {
    string? privilegedClaimUrl = authzRequest.privilegedClaimUrl;
    if (privilegedClaimUrl is string) {
        anydata|error authenticatedPriviledgedClaim = getClaimValue(privilegedClaimUrl, authzRequest);
        if (authenticatedPriviledgedClaim is string && "true".equalsIgnoreCaseAscii(authenticatedPriviledgedClaim)) {
            log:printDebug("[Authorize Privileged User] Privileged claim url is set to `true`.", claim_url = privilegedClaimUrl);
            return {isAuthorized: true, scope: r4:PRIVILEGED};
        }
        log:printDebug("[Authorize Privileged User] Privileged claim url is not set to `true`.", claim_url = privilegedClaimUrl,
        claim_value = authenticatedPriviledgedClaim is anydata ? authenticatedPriviledgedClaim : "null");
    }
    log:printDebug("[Authorize Privileged User] Privileged claim url is not set in the request.");
    return {isAuthorized: false};
}

isolated function getClaimValue(string claimName, r4:AuthzRequest payload) returns anydata|error {
    r4:JWT? & readonly jwt = payload.fhirSecurity.jwt;
    if (jwt is r4:JWT && jwt.payload.hasKey(claimName)) {
        log:printDebug("[Get Claim Value] Claim found.", claim_name = claimName, claim_value = jwt.payload[claimName]);
        return jwt.payload[claimName];
    }
    log:printDebug("[Get Claim Value] Claim not found.", claim_name = claimName);
    return error("Claim not found.");
}

// start of - records related to the data model 
type PatientTable record {
    string patientId;
    string hospitalId;
};

type PractitionerTable record {
    string practitionerId;
    string hospitalId;
};

final readonly & PatientTable[] patients = [
    {patientId: "1", hospitalId: "1"},
    {patientId: "1", hospitalId: "2"},
    {patientId: "2", hospitalId: "1"},
    {patientId: "3", hospitalId: "2"},
    {patientId: "4", hospitalId: "2"},
    {patientId: "4", hospitalId: "3"}
];

final PractitionerTable[] & readonly practitioners = [
    {practitionerId: "1", hospitalId: "1"},
    {practitionerId: "1", hospitalId: "2"},
    {practitionerId: "2", hospitalId: "1"},
    {practitionerId: "3", hospitalId: "2"},
    {practitionerId: "4", hospitalId: "3"}
];

// end of - records related to the data model
