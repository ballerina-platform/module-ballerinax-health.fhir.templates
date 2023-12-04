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
    resourceType: "Goal",
    profiles: [
            "http://hl7.org/fhir/StructureDefinition/Goal"        
    ],
    defaultProfile: (),
    searchParameters: [
            {
        name: "category",
        active: true,
        information: {
            description: "E.g. Treatment, dietary, behavioral, etc.",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Goal-category"
        }
    },
            {
        name: "target-date",
        active: true,
        information: {
            description: "Reach goal on or before",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Goal-target-date"
        }
    },
            {
        name: "achievement-status",
        active: true,
        information: {
            description: "in-progress | improving | worsening | no-change | achieved | sustaining | not-achieved | no-progress | not-attainable",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Goal-achievement-status"
        }
    },
            {
        name: "identifier",
        active: true,
        information: {
            description: "[Goal](goal.html): External Ids for this goal",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/clinical-identifier"
        }
    },
            {
        name: "start-date",
        active: true,
        information: {
            description: "When goal pursuit begins",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Goal-start-date"
        }
    },
            {
        name: "patient",
        active: true,
        information: {
            description: "[Goal](goal.html): Who this goal is intended for",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/clinical-patient"
        }
    },
            {
        name: "subject",
        active: true,
        information: {
            description: "Who this goal is intended for",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Goal-subject"
        }
    },
            {
        name: "lifecycle-status",
        active: true,
        information: {
            description: "proposed | planned | accepted | active | on-hold | completed | cancelled | entered-in-error | rejected",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Goal-lifecycle-status"
        }
    }
        ],
    operations: [
    
    ],
    serverConfig: (),
    authzConfig: ()
};
