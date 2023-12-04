// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.

// This software is the property of WSO2 LLC. and its suppliers, if any.
// Dissemination of any information or reproduction of any material contained
// herein is strictly forbidden, unless permitted by WSO2 in accordance with
// the WSO2 Software License available at: https://wso2.com/licenses/eula/3.2
// For specific language governing the permissions and limitations under
// this license, please see the license as well as any agreement you’ve
// entered into with WSO2 governing the purchase of this software and any
// associated services.
//
//
// AUTO-GENERATED FILE.
//
// This file is auto-generated by Ballerina.
// Developers are allowed to modify this file as per the requirement.

import ballerinax/health.fhir.r4;

final r4:ResourceAPIConfig apiConfig = {
    resourceType: "AppointmentResponse",
    profiles: [
            "http://hl7.org/fhir/StructureDefinition/AppointmentResponse"        
    ],
    defaultProfile: (),
    searchParameters: [
            {
        name: "location",
        active: true,
        information: {
            description: "This Response is for this Location",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/AppointmentResponse-location"
        }
    },
            {
        name: "appointment",
        active: true,
        information: {
            description: "The appointment that the response is attached to",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/AppointmentResponse-appointment"
        }
    },
            {
        name: "part-status",
        active: true,
        information: {
            description: "The participants acceptance status for this appointment",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/AppointmentResponse-part-status"
        }
    },
            {
        name: "identifier",
        active: true,
        information: {
            description: "An Identifier in this appointment response",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/AppointmentResponse-identifier"
        }
    },
            {
        name: "practitioner",
        active: true,
        information: {
            description: "This Response is for this Practitioner",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/AppointmentResponse-practitioner"
        }
    },
            {
        name: "actor",
        active: true,
        information: {
            description: "The Person, Location/HealthcareService or Device that this appointment response replies for",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/AppointmentResponse-actor"
        }
    },
            {
        name: "patient",
        active: true,
        information: {
            description: "This Response is for this Patient",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/AppointmentResponse-patient"
        }
    }
        ],
    operations: [
    
    ],
    serverConfig: (),
    authzConfig: ()
};
