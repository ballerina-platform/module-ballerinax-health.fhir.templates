## Code to show how to use the Fhirpath API Service. 

This service is used to evaluate a FHIRPath expression against a FHIR resource.

```
import ballerinax/health.fhir.r4.international401;
import ballerina/http;
import ballerina/io;

public function main() returns () {
    http:Client|http:ClientError fhirpathClient = new ("http://localhost:9090");

    string[]|string fhirpathArray = ["Patient.address[1].line[0]", "Patient.active", "Patient.address[0].line[0]", "Patient.address.use"];
    json payload = {
        "fhirPath": fhirpathArray,
        "fhirResource": patient.toJson()
    };

    http:Request request = new;
    request.setJsonPayload(payload);
    if !(fhirpathClient is error) {
        http:Response|http:ClientError response = fhirpathClient->/fhirpath.post(request);
        if !(response is http:Response) {
            io:println(response.message());
        } else {
            json|http:ClientError jsonPayload = response.getJsonPayload();
            if (jsonPayload is json) {
                io:println(jsonPayload.toString());
            } else {
                io:println(jsonPayload.message());
            }
        }
    }
}

international401:Patient patient = {
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
```

## Expected Outcome

```
{
    "Patient.address[1].line[0]":{
                    "result":"33[0] 6th St"
                    },
    "Patient.active":{ 
                    "result":true
                    },
    "Patient.address[0].line[0]":{
                    "result":"534 Erewhon St"
                    },
    "Patient.address.use":{
                            "result":["home","work"]
                        }
}
```