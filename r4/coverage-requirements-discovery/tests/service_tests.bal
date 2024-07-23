import ballerina/http;
import ballerina/test;

http:Client testClient = check new ("http://localhost:8081/");

@test:Config {groups: ["discovery_endpoint_tests", "positive"]}
function get_cds_discovery_endpoint_response() returns error? {
    http:Response response = check testClient->get("/cds-services");
    test:assertEquals(response.statusCode, 200, "Status code should be 200");
    json expected = {
        "services": [
            {
                "hook": "patient-view",
                "title": "Static CDS Service Example",
                "description": "An example of a CDS Service that returns a static set of cards",
                "id": "static-patient-greeter",
                "prefetch": {
                    "patientToGreet": "Patient/{{context.patientId}}"
                }
            },
            {
                "hook": "patient-view",
                "title": "Static CDS Service Example",
                "description": "An example of a CDS Service that returns a static set of cards",
                "id": "static-patient-greeter2",
                "prefetch": {
                    "patientToGreet": "Patient/{{context.patientId}}",
                    "patientToGreet2": "Patient/{{context.patientId}}"
                }
            },
            {
                "hook": "order-dispatch",
                "title": "Static CDS Service Example",
                "description": "An example of a CDS Service that returns a static set of cards",
                "id": "static-order-dispatch1"
            },
            {
                "hook": "order-dispatch",
                "title": "Static CDS Service Example",
                "description": "An example of a CDS Service that returns a static set of cards",
                "id": "static-order-dispatch2",
                "prefetch": {}
            },
            {
                "hook": "order-select",
                "title": "Static CDS Service Example",
                "description": "An example of a CDS Service that returns a static set of cards",
                "id": "static-order-select"
            }
        ]
    };
    test:assertEquals(response.getJsonPayload(), expected);
}

@test:Config {groups: ["service_endpoint", "negative"]}
function call_cds_service_wrong_id() returns error? {
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "hook": "patient-view",
        "context": {
            "userId": "Practitioner/example",
            "patientId": "1288992",
            "encounterId": "89284"
        }
    };
    json expected = {
        "message": "Can not find a cds service with the name: wrong-id" //Id is wrong here
    };
    http:Response res = check testClient->post("/cds-services/wrong-id", payload);
    test:assertEquals(res.statusCode, 404);
    test:assertEquals(res.getJsonPayload(), expected);
}

@test:Config {groups: ["service_endpoint", "positive"]}
function call_a_cds_service_which_has_no_prefetch() returns error? {
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "hook": "order-dispatch",
        "context": {
            "patientId": "1288992",
            "dispatchedOrders": [
                "ServiceRequest/proc002"
            ],
            "performer": "Organization/some-performer",
            "fulfillmentTasks": [
                {
                    "resourceType": "Task",
                    "status": "draft",
                    "intent": "order",
                    "code": {
                        "coding": [
                            {
                                "system": "http://hl7.org/fhir/CodeSystem/task-code",
                                "code": "fulfill"
                            }
                        ]
                    },
                    "focus": {
                        "reference": "ServiceRequest/proc002"
                    },
                    "for": {
                        "reference": "Patient/1288992"
                    },
                    "authoredOn": "2016-03-10T22:39:32-04:00",
                    "lastModified": "2016-03-10T22:39:32-04:00",
                    "requester": {
                        "reference": "Practitioner/456"
                    },
                    "owner": {
                        "reference": "Organziation/some-performer"
                    }
                }
            ]
        }
    };
    http:Response res = check testClient->post("/cds-services/static-order-dispatch1", payload);
    test:assertEquals(res.statusCode, 200);
}

@test:Config {groups: ["service_endpoint", "positive"]}
function call_a_cds_service_which_has_empty_prefetch_list() returns error? {
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "hook": "order-dispatch",
        "context": {
            "patientId": "1288992",
            "dispatchedOrders": [
                "ServiceRequest/proc002"
            ],
            "performer": "Organization/some-performer",
            "fulfillmentTasks": [
                {
                    "resourceType": "Task",
                    "status": "draft",
                    "intent": "order",
                    "code": {
                        "coding": [
                            {
                                "system": "http://hl7.org/fhir/CodeSystem/task-code",
                                "code": "fulfill"
                            }
                        ]
                    },
                    "focus": {
                        "reference": "ServiceRequest/proc002"
                    },
                    "for": {
                        "reference": "Patient/1288992"
                    },
                    "authoredOn": "2016-03-10T22:39:32-04:00",
                    "lastModified": "2016-03-10T22:39:32-04:00",
                    "requester": {
                        "reference": "Practitioner/456"
                    },
                    "owner": {
                        "reference": "Organziation/some-performer"
                    }
                }
            ]
        }
    };
    http:Response res = check testClient->post("/cds-services/static-order-dispatch2", payload);
    test:assertEquals(res.statusCode, 200);
}

@test:Config {groups: ["service_endpoint", "positive"]}
function call_cds_service_payload_with_prefetch_data_attached() returns error? {
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "hook": "patient-view",
        "context": {
            "userId": "Practitioner/example",
            "patientId": "1288992",
            "encounterId": "89284"
        },
        "prefetch": {
            "patientToGreet": {
                "resourceType": "Patient",
                "gender": "male",
                "birthDate": "1925-12-23",
                "id": "1288992",
                "active": true
            }
        }
    };
    http:Response res = check testClient->post("/cds-services/static-patient-greeter", payload);
    test:assertEquals(res.statusCode, 200);
}

@test:Config {groups: ["service_endpoint", "positive"]}
function call_cds_service_with_proper_payload() returns error? {
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "fhirServer": "http://hapi.fhir.org/baseR4",
        "hook": "patient-view",
        "fhirAuthorization": {
            "access_token": "some-opaque-fhir-access-token",
            "token_type": "Bearer",
            "expires_in": 300,
            "scope": "user/Patient.read user/Observation.read",
            "subject": "cds-service4"
        },
        "context": {
            "userId": "Practitioner/example",
            "patientId": "593380",
            "encounterId": "89284"
        },
        "prefetch": {
            "patientToGreet": {
                "resourceType": "Patient",
                "gender": "male",
                "birthDate": "1925-12-23",
                "id": "1288992",
                "active": true
            }
        }
    };
    json expected = {
        "cards": [],
        "systemActions": []
    };
    http:Response res = check testClient->post("/cds-services/static-patient-greeter", payload);
    test:assertEquals(res.statusCode, 200);
    test:assertEquals(res.getJsonPayload(), expected);
}

@test:Config {groups: ["service_endpoint", "negative"]}
function call_cds_service_with_unkown_fields_in_payload() returns error? {
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "hook": "patient-view",
        "context": {
            "userId": "Practitioner/example",
            "patientId": "1288992",
            "encounterId": "89284",
            "unkownField": "value" // This is a unkown field in the Context record
        }
    };
    http:Response res = check testClient->post("/cds-services/static-appointment-book1", payload);
    test:assertEquals(res.statusCode, 400);
}

@test:Config {groups: ["service_endpoint", "negative"]}
function call_cds_service_payload_with_no_prefetch_data_and_fhirServer() returns error? {
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "hook": "patient-view",
        "context": {
            "userId": "Practitioner/example",
            "patientId": "1288992",
            "encounterId": "89284"
        }
    };
    json expected = {
        "message": "Can not find fhirServer url in the request"
    };
    http:Response res = check testClient->post("/cds-services/static-patient-greeter", payload);
    test:assertEquals(res.statusCode, 400);
    test:assertEquals(res.getJsonPayload(), expected);
}

@test:Config {groups: ["service_endpoint", "negative"]}
function call_cds_service_payload_with_no_prefetch_data_and_fhirAuthorization() returns error? {
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "fhirServer": "http://hooks.smarthealthit.org:9080",
        "hook": "patient-view",
        "context": {
            "userId": "Practitioner/example",
            "patientId": "1288992",
            "encounterId": "89284"
        }
    };
    json expected = {
        "message": "Can not find fhirAuthorization in the request"
    };
    http:Response res = check testClient->post("/cds-services/static-patient-greeter", payload);
    test:assertEquals(res.statusCode, 400);
    test:assertEquals(res.getJsonPayload(), expected);
}

@test:Config {groups: ["service_endpoint", "negative"]}
function call_cds_service_wrong_prefetch_template_data() returns error? {
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "fhirServer": "http://hapi.fhir.org/baseR4",
        "hook": "patient-view",
        "fhirAuthorization": {
            "access_token": "some-opaque-fhir-access-token",
            "token_type": "Bearer",
            "expires_in": 300,
            "scope": "user/Patient.read user/Observation.read",
            "subject": "cds-service4"
        },
        "context": {
            "userId": "Practitioner/example",
            "patientId": "wrong-id", //Wrong Patient id
            "encounterId": "89284"
        },
        "prefetch": {
            "patientToGreet": {
                "resourceType": "Patient",
                "gender": "male",
                "birthDate": "1925-12-23",
                "id": "1288992",
                "active": true
            }
        }
    };
    json expected = {
        "message": "FHIR data retrieved for : http://hapi.fhir.org/baseR4/Patient/wrong-id is not valid"
    };
    http:Response res = check testClient->post("/cds-services/static-patient-greeter2", payload);
    test:assertEquals(res.statusCode, 412);
    test:assertEquals(res.getJsonPayload(), expected);
}

@test:Config {groups: ["service_endpoint", "negative"]}
function call_cds_serive_wrong_fhir_server_url() returns error? {
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "fhirServer": "http://hapi.fhir.org/baseR4sd",
        "hook": "patient-view",
        "fhirAuthorization": {
            "access_token": "some-opaque-fhir-access-token",
            "token_type": "Bearer",
            "expires_in": 300,
            "scope": "user/Patient.read user/Observation.read",
            "subject": "cds-service4"
        },
        "context": {
            "userId": "Practitioner/example",
            "patientId": "wrong-id",
            "encounterId": "89284"
        },
        "prefetch": {
            "patientToGreet": {
                "resourceType": "Patient",
                "gender": "male",
                "birthDate": "1925-12-23",
                "id": "1288992",
                "active": true
            }
        }
    };
    json expected = {
        "message": "FHIR data retrieved for : http://hapi.fhir.org/baseR4sd/Patient/wrong-id is not JSON"
    };
    http:Response res = check testClient->post("/cds-services/static-patient-greeter2", payload);
    test:assertEquals(res.statusCode, 412);
    test:assertEquals(res.getJsonPayload(), expected);
}

@test:Config {groups: ["service_endpoint", "negative"]}
function call_cds_serive_wrong_fhir_server_url2() returns error? {
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "fhirServer": "ghh://hapi.fhir.org/baseR4/",
        "hook": "patient-view",
        "fhirAuthorization": {
            "access_token": "some-opaque-fhir-access-token",
            "token_type": "Bearer",
            "expires_in": 300,
            "scope": "user/Patient.read user/Observation.read",
            "subject": "cds-service4"
        },
        "context": {
            "userId": "Practitioner/example",
            "patientId": "wrong-id",
            "encounterId": "89284"
        },
        "prefetch": {
            "patientToGreet": {
                "resourceType": "Patient",
                "gender": "male",
                "birthDate": "1925-12-23",
                "id": "1288992",
                "active": true
            }
        }
    };
    json expected = {
        "message": "Can not make a HTTP client for the server url: ghh://hapi.fhir.org/baseR4"
    };
    http:Response res = check testClient->post("/cds-services/static-patient-greeter2", payload);
    test:assertEquals(res.statusCode, 400);
    test:assertEquals(res.getJsonPayload(), expected);
}

@test:Config {groups: ["service_endpoint", "negative"]}
function call_cds_with_unkown_fields_in_request() returns error? {
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "hook": "patient-view",
        "context": {
            "userId": "Practitioner/example",
            "patientId": "593380",
            "encounterId": "89284",
            "unkown-field": "unlown-value"
        }
    };
    json expected = {
        "message": "Unkown field context.unkown-field"
    };
    http:Response res = check testClient->post("/cds-services/static-patient-greeter", payload);
    test:assertEquals(res.statusCode, 400);
    test:assertEquals(res.getJsonPayload(), expected);
}

@test:Config {groups: ["service_endpoint", "negative"]}
function call_cds_with_wrong_context_object() returns error? {
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "hook": "order-select",
        "context": {
            "userId": "Practitioner/example",
            "patientId": "593380",
            "encounterId": "89284"
        }
    };
    json expected = {
        "message": "Context validation failed: order-select",
        "description": "Context should only contains set of data allowed by the specification: https://cds-hooks.hl7.org/hooks/order-select/STU1/order-select/#context"
    };
    http:Response res = check testClient->post("/cds-services/static-order-select", payload);
    test:assertEquals(res.statusCode, 400);
    test:assertEquals(res.getJsonPayload(), expected);
}

@test:Config {groups: ["service_endpoint", "negative"]}
function call_cds_with_wrong_hook_type() returns error? {
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "hook": "order-select", //It should be patient-view
        "context": {
            "userId": "Practitioner/example",
            "patientId": "593380",
            "encounterId": "89284"
        }
    };
    json expected = {
        "message": "CDS service static-patient-greeter is a not type of order-select. It should be patient-view type hook"
    };
    http:Response res = check testClient->post("/cds-services/static-patient-greeter", payload);
    test:assertEquals(res.statusCode, 400);
    test:assertEquals(res.getJsonPayload(), expected);
}

@test:Config {groups: ["service_endpoint", "negative"]}
function call_cds_feedback_endpoint() returns error? {
    json payload = {
        "feedback": [
            {
                "card": "4e0a3a1e-3283-4575-ab82-028d55fe2719",
                "outcome": "accepted",
                "acceptedSuggestions": [
                    {
                        "id": "e56e1945-20b3-4393-8503-a1a20fd73152"
                    }
                ],
                "outcomeTimestamp": "2021-12-11T10:05:31Z"
            }
        ]
    };
    json expected = {
        "message": "Rule respository backend not implemented/ connected yet"
    };
    http:Response res = check testClient->post("/cds-services/static-patient-greeter/feedback", payload);
    test:assertEquals(res.statusCode, 501);
    test:assertEquals(res.getJsonPayload(), expected);
}
