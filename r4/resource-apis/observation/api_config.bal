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
    resourceType: "Observation",
    profiles: [
            "http://hl7.org/fhir/StructureDefinition/Observation"        
    ],
    defaultProfile: (),
    searchParameters: [
            {
        name: "combo-code-value-concept",
        active: true,
        information: {
            description: "Code and coded value parameter pair, including in components",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-combo-code-value-concept"
        }
    },
            {
        name: "code",
        active: true,
        information: {
            description: "[Observation](observation.html): The code of the observation type",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/clinical-code"
        }
    },
            {
        name: "status",
        active: true,
        information: {
            description: "The status of the observation",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-status"
        }
    },
            {
        name: "component-code-value-concept",
        active: true,
        information: {
            description: "Component code and component coded value parameter pair",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-component-code-value-concept"
        }
    },
            {
        name: "code-value-concept",
        active: true,
        information: {
            description: "Code and coded value parameter pair",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-code-value-concept"
        }
    },
            {
        name: "value-date",
        active: true,
        information: {
            description: "The value of the observation, if the value is a date or period of time",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-value-date"
        }
    },
            {
        name: "data-absent-reason",
        active: true,
        information: {
            description: "The reason why the expected value in the element Observation.value[x] is missing.",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-data-absent-reason"
        }
    },
            {
        name: "code-value-quantity",
        active: true,
        information: {
            description: "Code and quantity value parameter pair",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-code-value-quantity"
        }
    },
            {
        name: "component-data-absent-reason",
        active: true,
        information: {
            description: "The reason why the expected value in the element Observation.component.value[x] is missing.",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-component-data-absent-reason"
        }
    },
            {
        name: "identifier",
        active: true,
        information: {
            description: "[Observation](observation.html): The unique id for a particular observation",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/clinical-identifier"
        }
    },
            {
        name: "combo-value-quantity",
        active: true,
        information: {
            description: "The value or component value of the observation, if the value is a Quantity, or a SampledData (just search on the bounds of the values in sampled data)",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-combo-value-quantity"
        }
    },
            {
        name: "component-value-concept",
        active: true,
        information: {
            description: "The value of the component observation, if the value is a CodeableConcept",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-component-value-concept"
        }
    },
            {
        name: "device",
        active: true,
        information: {
            description: "The Device that generated the observation data.",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-device"
        }
    },
            {
        name: "part-of",
        active: true,
        information: {
            description: "Part of referenced event",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-part-of"
        }
    },
            {
        name: "code-value-string",
        active: true,
        information: {
            description: "Code and string value parameter pair",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-code-value-string"
        }
    },
            {
        name: "date",
        active: true,
        information: {
            description: "[Observation](observation.html): Obtained date/time. If the obtained element is a period, a date that falls in the period",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/clinical-date"
        }
    },
            {
        name: "based-on",
        active: true,
        information: {
            description: "Reference to the service request.",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-based-on"
        }
    },
            {
        name: "patient",
        active: true,
        information: {
            description: "[Observation](observation.html): The subject that the observation is about (if patient)",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/clinical-patient"
        }
    },
            {
        name: "performer",
        active: true,
        information: {
            description: "Who performed the observation",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-performer"
        }
    },
            {
        name: "specimen",
        active: true,
        information: {
            description: "Specimen used for this observation",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-specimen"
        }
    },
            {
        name: "combo-value-concept",
        active: true,
        information: {
            description: "The value or component value of the observation, if the value is a CodeableConcept",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-combo-value-concept"
        }
    },
            {
        name: "value-concept",
        active: true,
        information: {
            description: "The value of the observation, if the value is a CodeableConcept",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-value-concept"
        }
    },
            {
        name: "method",
        active: true,
        information: {
            description: "The method used for the observation",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-method"
        }
    },
            {
        name: "combo-code-value-quantity",
        active: true,
        information: {
            description: "Code and quantity value parameter pair, including in components",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-combo-code-value-quantity"
        }
    },
            {
        name: "value-quantity",
        active: true,
        information: {
            description: "The value of the observation, if the value is a Quantity, or a SampledData (just search on the bounds of the values in sampled data)",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-value-quantity"
        }
    },
            {
        name: "encounter",
        active: true,
        information: {
            description: "[Observation](observation.html): Encounter related to the observation",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/clinical-encounter"
        }
    },
            {
        name: "component-value-quantity",
        active: true,
        information: {
            description: "The value of the component observation, if the value is a Quantity, or a SampledData (just search on the bounds of the values in sampled data)",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-component-value-quantity"
        }
    },
            {
        name: "code-value-date",
        active: true,
        information: {
            description: "Code and date/time value parameter pair",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-code-value-date"
        }
    },
            {
        name: "derived-from",
        active: true,
        information: {
            description: "Related measurements the observation is made from",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-derived-from"
        }
    },
            {
        name: "focus",
        active: true,
        information: {
            description: "The focus of an observation when the focus is not the patient of record.",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-focus"
        }
    },
            {
        name: "combo-code",
        active: true,
        information: {
            description: "The code of the observation type or component type",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-combo-code"
        }
    },
            {
        name: "component-code-value-quantity",
        active: true,
        information: {
            description: "Component code and component quantity value parameter pair",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-component-code-value-quantity"
        }
    },
            {
        name: "combo-data-absent-reason",
        active: true,
        information: {
            description: "The reason why the expected value in the element Observation.value[x] or Observation.component.value[x] is missing.",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-combo-data-absent-reason"
        }
    },
            {
        name: "has-member",
        active: true,
        information: {
            description: "Related resource that belongs to the Observation group",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-has-member"
        }
    },
            {
        name: "component-code",
        active: true,
        information: {
            description: "The component code of the observation type",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-component-code"
        }
    },
            {
        name: "value-string",
        active: true,
        information: {
            description: "The value of the observation, if the value is a string, and also searches in CodeableConcept.text",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-value-string"
        }
    },
            {
        name: "subject",
        active: true,
        information: {
            description: "The subject that the observation is about",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-subject"
        }
    },
            {
        name: "category",
        active: true,
        information: {
            description: "The classification of the type of observation",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/Observation-category"
        }
    }
        ],
    operations: [
    
    ],
    serverConfig: (),
    authzConfig: ()
};
