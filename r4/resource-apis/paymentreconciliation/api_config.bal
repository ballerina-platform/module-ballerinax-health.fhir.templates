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
    resourceType: "PaymentReconciliation",
    profiles: [
            "http://hl7.org/fhir/StructureDefinition/PaymentReconciliation"        
    ],
    defaultProfile: (),
    searchParameters: [
            {
        name: "identifier",
        active: true,
        information: {
            description: "The business identifier of the ExplanationOfBenefit",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/PaymentReconciliation-identifier"
        }
    },
            {
        name: "status",
        active: true,
        information: {
            description: "The status of the payment reconciliation",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/PaymentReconciliation-status"
        }
    },
            {
        name: "requestor",
        active: true,
        information: {
            description: "The reference to the provider who submitted the claim",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/PaymentReconciliation-requestor"
        }
    },
            {
        name: "request",
        active: true,
        information: {
            description: "The reference to the claim",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/PaymentReconciliation-request"
        }
    },
            {
        name: "disposition",
        active: true,
        information: {
            description: "The contents of the disposition message",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/PaymentReconciliation-disposition"
        }
    },
            {
        name: "created",
        active: true,
        information: {
            description: "The creation date",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/PaymentReconciliation-created"
        }
    },
            {
        name: "payment-issuer",
        active: true,
        information: {
            description: "The organization which generated this resource",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/PaymentReconciliation-payment-issuer"
        }
    },
            {
        name: "outcome",
        active: true,
        information: {
            description: "The processing outcome",
            builtin: false,
            documentation: "http://hl7.org/fhir/SearchParameter/PaymentReconciliation-outcome"
        }
    }
        ],
    operations: [
    
    ],
    serverConfig: (),
    authzConfig: ()
};
