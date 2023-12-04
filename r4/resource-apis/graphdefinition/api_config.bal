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
    resourceType: "GraphDefinition",
    profiles: [
            "http://hl7.org/fhir/StructureDefinition/GraphDefinition"        
    ],
    defaultProfile: (),
    searchParameters: [
            {
        name: "status",
        active: true,
        information: {
            description: "[GraphDefinition](graphdefinition.html): The current status of the graph definition",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/conformance-status"
        }
    },
            {
        name: "context-type",
        active: true,
        information: {
            description: "[GraphDefinition](graphdefinition.html): A type of use context assigned to the graph definition",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/conformance-context-type"
        }
    },
            {
        name: "jurisdiction",
        active: true,
        information: {
            description: "[GraphDefinition](graphdefinition.html): Intended jurisdiction for the graph definition",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/conformance-jurisdiction"
        }
    },
            {
        name: "context-type-value",
        active: true,
        information: {
            description: "[GraphDefinition](graphdefinition.html): A use context type and value assigned to the graph definition",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/conformance-context-type-value"
        }
    },
            {
        name: "description",
        active: true,
        information: {
            description: "[GraphDefinition](graphdefinition.html): The description of the graph definition",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/conformance-description"
        }
    },
            {
        name: "context-type-quantity",
        active: true,
        information: {
            description: "[GraphDefinition](graphdefinition.html): A use context type and quantity- or range-based value assigned to the graph definition",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/conformance-context-type-quantity"
        }
    },
            {
        name: "context-quantity",
        active: true,
        information: {
            description: "[GraphDefinition](graphdefinition.html): A quantity- or range-valued use context assigned to the graph definition",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/conformance-context-quantity"
        }
    },
            {
        name: "context",
        active: true,
        information: {
            description: "[GraphDefinition](graphdefinition.html): A use context assigned to the graph definition",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/conformance-context"
        }
    },
            {
        name: "name",
        active: true,
        information: {
            description: "[GraphDefinition](graphdefinition.html): Computationally friendly name of the graph definition",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/conformance-name"
        }
    },
            {
        name: "start",
        active: true,
        information: {
            description: "Type of resource at which the graph starts",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/GraphDefinition-start"
        }
    },
            {
        name: "publisher",
        active: true,
        information: {
            description: "[GraphDefinition](graphdefinition.html): Name of the publisher of the graph definition",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/conformance-publisher"
        }
    },
            {
        name: "url",
        active: true,
        information: {
            description: "[GraphDefinition](graphdefinition.html): The uri that identifies the graph definition",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/conformance-url"
        }
    },
            {
        name: "version",
        active: true,
        information: {
            description: "[GraphDefinition](graphdefinition.html): The business version of the graph definition",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/conformance-version"
        }
    },
            {
        name: "date",
        active: true,
        information: {
            description: "[GraphDefinition](graphdefinition.html): The graph definition publication date",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/conformance-date"
        }
    }
        ],
    operations: [
    
    ],
    serverConfig: (),
    authzConfig: ()
};
