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

import ballerina/test;
import ballerina/http;

http:Client testClient = check new ("http://localhost:9090");

json fhirResource = {
    "resourceType": "Patient",
    "id": "1",
    "meta": {
        "profile": [
            "http://hl7.org/fhir/StructureDefinition/Patient"
        ]
    },
    "active": true,
    "name": [
        {
            "use": "official",
            "family": "Chalmers",
            "given": [
                "Peter",
                "James"
            ]
        },
        {
            "use": "usual",
            "given": [
                "Jim"
            ]
        }
    ],
    "gender": "male",
    "birthDate": "1974-12-25",
    "managingOrganization": {
        "reference": "Organization/1",
        "display": "Burgers University Medical Center"
    },
    "address": [
        {
            "use": "home",
            "line": [
                "534 Erewhon St",
                "sqw"
            ],
            "city": "PleasantVille",
            "district": "Rainbow",
            "state": "Vic",
            "postalCode": "3999",
            "country": "Australia"
        },
        {
            "use": "work",
            "line": [
                "33[0] 6th St"
            ],
            "city": "Melbourne",
            "district": "Rainbow",
            "state": "Vic",
            "postalCode": "3000",
            "country": "Australia"
        }
    ]
};

@test:Config {}
public function test1() returns error? {
    http:Response response = check testClient->/fhirpath.post({
        fhirResource: fhirResource,
        fhirPath: "Patient.name[0].given[0]"
    });
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertEquals(response.getTextPayload(), string `{"Patient.name[0].given[0]":{"result":"Peter"}}`);
}

@test:Config {}
public function test2() returns error? {
    http:Response response = check testClient->/fhirpath.post({
        fhirResource: fhirResource,
        fhirPath: ["Patient.name[0].given[0]", "Patient.name[0].given[1]"]
    });
    test:assertEquals(response.statusCode, http:STATUS_OK);
    test:assertEquals(response.getTextPayload(), string `{"Patient.name[0].given[0]":{"result":"Peter"}, "Patient.name[0].given[1]":{"result":"James"}}`);
}

@test:Config {}
public function test3() returns error? {
    http:Response response = check testClient->/fhirpath.post({
        fhirResource2: fhirResource,
        fhirPath: ["Patient.name[0].given[0]", "Patient.name[0].given[1]"]
    });
    test:assertEquals(response.statusCode, http:STATUS_BAD_REQUEST);
}
