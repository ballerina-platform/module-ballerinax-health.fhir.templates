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

final r4:ResourceAPIConfig apiConfig = {
    resourceType: "Encounter",
    profiles: [
        "http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter"    
    ],
    defaultProfile: (),
    searchParameters: [
        {
            name: "location",
            active: true,
            information: {
                description: "--Location-the-encounter-takes-place-------NOTE----This-US-Core-SearchParameter-definition-extends-the-usage-context-of-the--Conformance-expectation-extension-(http-//hl7.org/fhir/R4/extension-capabilitystatement-expectation.html)----multipleAnd----multipleOr----comparator----modifier----chain",
                builtin: false,
                documentation: "http://hl7.org/fhir/us/core/SearchParameter/us-core-encounter-location"
            }
        },
        {
            name: "patient",
            active: true,
            information: {
                description: "--The-patient-or-group-present-at-the-encounter-------NOTE----This-US-Core-SearchParameter-definition-extends-the-usage-context-of-the--Conformance-expectation-extension-(http-//hl7.org/fhir/R4/extension-capabilitystatement-expectation.html)----multipleAnd----multipleOr----comparator----modifier----chain",
                builtin: false,
                documentation: "http://hl7.org/fhir/us/core/SearchParameter/us-core-encounter-patient"
            }
        },
        {
            name: "status",
            active: true,
            information: {
                description: "--planned---arrived---triaged---in-progress---onleave---finished---cancelled-+-------NOTE----This-US-Core-SearchParameter-definition-extends-the-usage-context-of-the--Conformance-expectation-extension-(http-//hl7.org/fhir/R4/extension-capabilitystatement-expectation.html)----multipleAnd----multipleOr----comparator----modifier----chain",
                builtin: false,
                documentation: "http://hl7.org/fhir/us/core/SearchParameter/us-core-encounter-status"
            }
        },
        {
            name: "type",
            active: true,
            information: {
                description: "--Specific-type-of-encounter-------NOTE----This-US-Core-SearchParameter-definition-extends-the-usage-context-of-the--Conformance-expectation-extension-(http-//hl7.org/fhir/R4/extension-capabilitystatement-expectation.html)----multipleAnd----multipleOr----comparator----modifier----chain",
                builtin: false,
                documentation: "http://hl7.org/fhir/us/core/SearchParameter/us-core-encounter-type"
            }
        },
        {
            name: "identifier",
            active: true,
            information: {
                description: "--Identifier(s)-by-which-this-encounter-is-known-------NOTE----This-US-Core-SearchParameter-definition-extends-the-usage-context-of-the--Conformance-expectation-extension-(http-//hl7.org/fhir/R4/extension-capabilitystatement-expectation.html)----multipleAnd----multipleOr----comparator----modifier----chain",
                builtin: false,
                documentation: "http://hl7.org/fhir/us/core/SearchParameter/us-core-encounter-identifier"
            }
        },
        {
            name: "class",
            active: true,
            information: {
                description: "--Classification-of-patient-encounter-------NOTE----This-US-Core-SearchParameter-definition-extends-the-usage-context-of-the--Conformance-expectation-extension-(http-//hl7.org/fhir/R4/extension-capabilitystatement-expectation.html)----multipleAnd----multipleOr----comparator----modifier----chain",
                builtin: false,
                documentation: "http://hl7.org/fhir/us/core/SearchParameter/us-core-encounter-class"
            }
        },
        {
            name: "discharge-disposition",
            active: true,
            information: {
                description: "Returns-encounters-with-an-discharge-disposition-matching-the-specified-code.",
                builtin: false,
                documentation: "http://hl7.org/fhir/us/core/SearchParameter/us-core-encounter-discharge-disposition"
            }
        },
        {
            name: "_id",
            active: true,
            information: {
                description: "--Logical-id-of-this-artifact-------NOTE----This-US-Core-SearchParameter-definition-extends-the-usage-context-of-the--Conformance-expectation-extension-(http-//hl7.org/fhir/R4/extension-capabilitystatement-expectation.html)----multipleAnd----multipleOr----comparator----modifier----chain",
                builtin: false,
                documentation: "http://hl7.org/fhir/us/core/SearchParameter/us-core-encounter-id"
            }
        },
        {
            name: "date",
            active: true,
            information: {
                description: "--A-date-within-the-period-the-Encounter-lasted-------NOTE----This-US-Core-SearchParameter-definition-extends-the-usage-context-of-the--Conformance-expectation-extension-(http-//hl7.org/fhir/R4/extension-capabilitystatement-expectation.html)----multipleAnd----multipleOr----comparator----modifier----chain",
                builtin: false,
                documentation: "http://hl7.org/fhir/us/core/SearchParameter/us-core-encounter-date"
            }
        }
        ],
    operations: [
    
    ],
    serverConfig: ()
};
