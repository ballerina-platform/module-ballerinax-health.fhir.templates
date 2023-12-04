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
    resourceType: "TestScript",
    profiles: [
            "http://hl7.org/fhir/StructureDefinition/TestScript"        
    ],
    defaultProfile: (),
    searchParameters: [
            {
        name: "description",
        active: true,
        information: {
            description: "The description of the test script",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/TestScript-description"
        }
    },
            {
        name: "testscript-capability",
        active: true,
        information: {
            description: "TestScript required and validated capability",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/TestScript-testscript-capability"
        }
    },
            {
        name: "url",
        active: true,
        information: {
            description: "The uri that identifies the test script",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/TestScript-url"
        }
    },
            {
        name: "context",
        active: true,
        information: {
            description: "A use context assigned to the test script",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/TestScript-context"
        }
    },
            {
        name: "version",
        active: true,
        information: {
            description: "The business version of the test script",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/TestScript-version"
        }
    },
            {
        name: "jurisdiction",
        active: true,
        information: {
            description: "Intended jurisdiction for the test script",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/TestScript-jurisdiction"
        }
    },
            {
        name: "status",
        active: true,
        information: {
            description: "The current status of the test script",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/TestScript-status"
        }
    },
            {
        name: "date",
        active: true,
        information: {
            description: "The test script publication date",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/TestScript-date"
        }
    },
            {
        name: "name",
        active: true,
        information: {
            description: "Computationally friendly name of the test script",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/TestScript-name"
        }
    },
            {
        name: "context-type-quantity",
        active: true,
        information: {
            description: "A use context type and quantity- or range-based value assigned to the test script",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/TestScript-context-type-quantity"
        }
    },
            {
        name: "context-type",
        active: true,
        information: {
            description: "A type of use context assigned to the test script",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/TestScript-context-type"
        }
    },
            {
        name: "title",
        active: true,
        information: {
            description: "The human-friendly name of the test script",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/TestScript-title"
        }
    },
            {
        name: "context-quantity",
        active: true,
        information: {
            description: "A quantity- or range-valued use context assigned to the test script",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/TestScript-context-quantity"
        }
    },
            {
        name: "context-type-value",
        active: true,
        information: {
            description: "A use context type and value assigned to the test script",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/TestScript-context-type-value"
        }
    },
            {
        name: "publisher",
        active: true,
        information: {
            description: "Name of the publisher of the test script",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/TestScript-publisher"
        }
    },
            {
        name: "identifier",
        active: true,
        information: {
            description: "External identifier for the test script",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/TestScript-identifier"
        }
    }
        ],
    operations: [
    
    ],
    serverConfig: (),
    authzConfig: ()
};
