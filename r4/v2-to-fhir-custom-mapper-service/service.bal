// Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com).

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
import ballerinax/health.hl7v2commons;

// You can implement custom mapping logic within resource functions for each segment in the HL7v2 message to 
// convert it to a FHIR resource.
service /v2tofhir on new http:Listener(9091) {

    resource function post segment/nk1(@http:Payload hl7v2commons:Nk1 nk1) returns json|error {
        return {};
    }

    resource function post segment/pid(@http:Payload hl7v2commons:Pid pid) returns json|error {
        return {};
    }

    resource function post segment/pd1(@http:Payload hl7v2commons:Pd1 pd1) returns json|error {
        return {};
    }

    resource function post segment/pv1(@http:Payload hl7v2commons:Pv1 pv1) returns json|error {
        return {};
    }

    resource function post segment/dg1(@http:Payload hl7v2commons:Dg1 dg1) returns json|error {
        return {};
    }

    resource function post segment/al1(@http:Payload hl7v2commons:Al1 al1) returns json|error {
        return {};
    }

    resource function post segment/evn(@http:Payload hl7v2commons:Evn evn) returns json|error {
        return {};
    }

    resource function post segment/msh(@http:Payload hl7v2commons:Msh msh) returns json|error {
        return {};
    }

    resource function post segment/pv2(@http:Payload hl7v2commons:Pv2 pv2) returns json|error {
        return {};
    }

    resource function post segment/obx(@http:Payload hl7v2commons:Obx obx) returns json|error {
        return {};
    }

    resource function post segment/orc(@http:Payload hl7v2commons:Orc orc) returns json|error {
        return {};
    }

    resource function post segment/obr(@http:Payload hl7v2commons:Obr obr) returns json|error {
        return {};
    }

    resource function post segment/nte(@http:Payload hl7v2commons:Nte nte) returns json|error {
        return {};
    }

    resource function post segment/sft(@http:Payload hl7v2commons:Stf stf) returns json|error {
        return {};
    }

    resource function post segment/mrg(@http:Payload hl7v2commons:Mrg mrg) returns json|error {
        return {};
    }

    resource function post segment/rxa(@http:Payload hl7v2commons:Rxa rxa) returns json|error {
        return {};
    }

    resource function post segment/rxo(@http:Payload hl7v2commons:Rxo rxo) returns json|error {
        return {};
    }

    resource function post segment/rxr(@http:Payload hl7v2commons:Rxr rxr) returns json|error {
        return {};
    }

    resource function post segment/in1(@http:Payload hl7v2commons:In1 in1) returns json|error {
        return {};
    }

    resource function post segment/in3(@http:Payload hl7v2commons:In3 in3) returns json|error {
        return {};
    }

    resource function post segment/pr1(@http:Payload hl7v2commons:Pr1 pr1) returns json|error {
        return {};
    }

    resource function post segment/txa(@http:Payload hl7v2commons:Txa txa) returns json|error {
        return {};
    }

    resource function post segment/aig(@http:Payload hl7v2commons:Aig aig) returns json|error {
        return {};
    }

    resource function post segment/ail(@http:Payload hl7v2commons:Ail ail) returns json|error {
        return {};
    }

    resource function post segment/aip(@http:Payload hl7v2commons:Aip aip) returns json|error {
        return {};
    }

    resource function post segment/ais(@http:Payload hl7v2commons:Ais ais) returns json|error {
        return {};
    }

    resource function post segment/sch(@http:Payload hl7v2commons:Sch sch) returns json|error {
        return {};
    }

    resource function post segment/rol(@http:Payload hl7v2commons:Rol rol) returns json|error {
        return {};
    }

}
