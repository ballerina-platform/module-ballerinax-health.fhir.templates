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
import ballerinax/health.fhir.r4;

// Implement this function type if you want to customize the default authorization logic for practitioners.
type AuthorizePractitionersType isolated function (string patientId, string practitionerId) returns AuthzResponse;

// Implement this function type if you want to customize the default authorization logic for privileged users.
type AuthorizePrivilegeUsersType isolated function (AuthzRequest & readonly authzRequest) returns AuthzResponse;

// Default authorization logic for practitioners.
AuthorizePractitionersType authzPractitioner = authorizePractitioners;
// Default authorization logic for privileged users.
AuthorizePrivilegeUsersType authzPrivilegeUsers = authorizePrivilegeUsers;

// start of - records related to the API 
type AuthzRequest record {
    // This is coming from the health.fhir.r4 modules.
    r4:FHIRSecurity fhirSecurity;
    // Set this, if the user is trying to access data of a specific patient.
    string patientId?;
    // Set this, if there's a privilege user concept.
    string privilegedClaimUrl?;
};

enum AuthzScope {
    PATIENT, PRACTITIONER, PRIVILEGED
};

type AuthzResponse record {
    boolean isAuthorized;
    AuthzScope scope?;
};

// end of - records related to the API

configurable string PATIENT_ID_CLAIM = "patient";
configurable string PRACTITIONER_ID_CLAIM = "practitioner";

// This service is intended to be called by FHIR API templates released by the WSO2.
// However, there is no restriction to use this service with any other FHIR API implementation.
service / on new http:Listener(9090) {

    isolated resource function post authorize(AuthzRequest & readonly authzRequest) returns AuthzResponse {
        string? pid = authzRequest.patientId;
        if (pid is ()) {
            // Trying to retrieve data of more than one patient requires privileged access.
            return authzPrivilegeUsers(authzRequest);
        }
        anydata|error authenticatedPatientId = getClaimValue(PATIENT_ID_CLAIM, authzRequest);
        if (authenticatedPatientId is string) {
            // When the user is authenticated as a patient.
            if (pid == authenticatedPatientId) {
                // Patient is authorized to access ONLY his/her own data.
                return {isAuthorized: true, scope: PATIENT};
            }
            // A patient can be a practitioner or a privilged user as well, hence letting the flow to continue
        }
        anydata|error authenticatedPractitionerId = getClaimValue(PRACTITIONER_ID_CLAIM, authzRequest);
        if (authenticatedPractitionerId is string) {
            // When the user is authenticated as a practitioner
            if (authzPractitioner(pid, authenticatedPractitionerId).isAuthorized) {
                // Practitioner is authorized to access data of the patient he/she is associated with
                return {isAuthorized: true, scope: PRACTITIONER};
            }
        }
        // Lastly, check whether the user is a privileged user
        // This is done lastly in patient access case to determine the correct fine-grained scope.
        return authzPrivilegeUsers(authzRequest);
    }
}
