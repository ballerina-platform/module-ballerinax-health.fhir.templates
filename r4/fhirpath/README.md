## Code to show how to use the Fhirpath API Service. 

```
import ballerina/io;
import ballerinax/health.fhir.r4;
import ballerina/http;

public function main() returns error? {
    http:Client fhirPathClient = check new ("Fhirpath_api_running_URL");

    # accessing multiple fhir paths
    string [] fhirPath = ["Patient.address[1].line[0]","Patient.active","Patient.address[0].line[0]","Patient.address.use"];
    # accessing single fhir path
    //string fhirPath = "Patient.address[1].line[0]";
    json payload = {
        "fhirPath": fhirPath,
        "fhirResource" : patient.toJson() };

    http:Request request = new;
    request.setJsonPayload(payload);
    http:Response response = check fhirPathClient->/fhir/r4/fhirpath.post(request);
    map<json>|error resultmap =response.getJsonPayload().ensureType();
    if (resultmap is map<json>) {
        
        foreach string path in fhirPath{
            json|error data = resultmap[path].result;
            if data is json {
                io:println("FHIRPath: ", path);
                io:println("Result: ", data);
                io:println();
            } else {
                io:println("FHIRPath: ", path);
                io:println("Result Error: ", resultmap[path].resultenError);
                io:println();
            }
        } 
    } else {
        io:println("Error");
    }  
}

r4:Patient patient = {
        "resourceType" : "Patient",
        "id": "1",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/StructureDefinition/Patient"
            ]
        },
        "active":true,
        "name":[
            {
                "use":"official",
                "family":"Chalmers",
                "given":[
                    "Peter",
                    "James"
                ]
            },
            {
                "use":"usual",
                "given":[
                    "Jim"
                ]
            }
        ],
        "gender":"male",
        "birthDate":"1974-12-25",
        "managingOrganization":{
            "reference":"Organization/1",
            "display":"Burgers University Medical Center"
        },
        "address":[
            {
                "use":"home",
                "line":[
                    "534 Erewhon St",
                    "sqw"
                ],
                "city":"PleasantVille",
                "district":"Rainbow",
                "state":"Vic",
                "postalCode":"3999",
                "country":"Australia"
            },
            {
                "use":"work",
                "line":[
                    "33[0] 6th St"
                ],
                "city":"Melbourne",
                "district":"Rainbow",
                "state":"Vic",
                "postalCode":"3000",
                "country":"Australia"
            }
        ]
    };

```
## Steps to Run the program
1. Download the ballerina tool distribution by navigating to https://ballerina.io/downloads/
2. Copy the above into a Ballerina project and pull the required ballerina modules.
3. Start the FHIRPath API service. 
4. Run the program using the command `bal run`.

## Expected Outcome for multiple Fhirpaths
```
{
    "Patient.address[1].line[0]": {
        "result": "33[0] 6th St"
    },
    "Patient.active": {
        "result": true
    },
    "Patient.address[0].line[0]": {
        "result": "534 Erewhon St"
    },
    "Patient.address": {
        "result": [
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
    }
}
```

## Expected Outcome for single Fhirpaths
```
{
    "Patient.address[1].line[0]": {
        "result": "33[0] 6th St"
    }
}
```

