import ballerina/http;
import ballerina/test;
import ballerinax/health.fhir.r4;

http:Client testClient = check new ("http://localhost:9090");

// Test functions
@test:Config {}
function testAuthorizingWithAPatient() {
    r4:AuthzRequest authzRequest = {
        "fhirSecurity": {
            "securedAPICall": true,
            "fhirUser": null,
            "jwt": {
                "header": {
                    "alg": "RS256",
                    "typ": "JWT",
                    "kid": "ZjcwNmI2ZDJmNWQ0M2I5YzZiYzJmZmM4YjMwMDFlOTA4MGE3ZWZjZTMzNjU3YWU1MzViYjZkOTkzZjYzOGYyNg"
                },
                "payload": {
                    "iss": "wso2.org/products/am",
                    "exp": 1675923588,
                    "iat": 1675919988,
                    "jti": "1a055f11-a384-4fa0-9e9f-30932b63c9a0",
                    "patient": "123",
                    "http://wso2.org/claims/apiname": "PatientApi",
                    "http://wso2.org/claims/version": "1.0.0",
                    "http://wso2.org/claims/keytype": "PRODUCTION",
                    "http://wso2.org/claims/enduserTenantId": "0",
                    "http://wso2.org/claims/usertype": "Application_User",
                    "http://wso2.org/claims/apicontext": "/8838e292-a122-4dcb-b5da-af938d8aceef/exmz/patientapi/1.0.0"
                }
            }
        },
        "patientId": "123",
        privilegedClaimUrl: "http://wso2.org/claims/privileged"
    };
    r4:AuthzResponse|error response = testClient->/authorize.post(authzRequest);
    test:assertEquals(response, {isAuthorized: true, scope: r4:PATIENT});
}

@test:Config {}
function testAuthorizingWithAPrivilegedUser() {
    r4:AuthzRequest authzRequest = {
        "fhirSecurity": {
            "securedAPICall": true,
            "fhirUser": null,
            "jwt": {
                "header": {
                    "alg": "RS256",
                    "typ": "JWT",
                    "kid": "ZjcwNmI2ZDJmNWQ0M2I5YzZiYzJmZmM4YjMwMDFlOTA4MGE3ZWZjZTMzNjU3YWU1MzViYjZkOTkzZjYzOGYyNg"
                },
                "payload": {
                    "iss": "wso2.org/products/am",
                    "exp": 1675923588,
                    "iat": 1675919988,
                    "jti": "1a055f11-a384-4fa0-9e9f-30932b63c9a0",
                    "privileged": "true",
                    "http://wso2.org/claims/apiname": "PatientApi",
                    "http://wso2.org/claims/version": "1.0.0",
                    "http://wso2.org/claims/keytype": "PRODUCTION",
                    "http://wso2.org/claims/enduserTenantId": "0",
                    "http://wso2.org/claims/usertype": "Application_User",
                    "http://wso2.org/claims/apicontext": "/8838e292-a122-4dcb-b5da-af938d8aceef/exmz/patientapi/1.0.0"
                }
            }
        },
        "patientId": "123",
        privilegedClaimUrl: "privileged"
    };
    r4:AuthzResponse|error response = testClient->/authorize.post(authzRequest);
    test:assertEquals(response, {isAuthorized: true, scope: r4:PRIVILEGED});
}

@test:Config {}
function testAuthorizingWithAPrivilegedUserForAllPatientData() {
    r4:AuthzRequest authzRequest = {
        "fhirSecurity": {
            "securedAPICall": true,
            "fhirUser": null,
            "jwt": {
                "header": {
                    "alg": "RS256",
                    "typ": "JWT",
                    "kid": "ZjcwNmI2ZDJmNWQ0M2I5YzZiYzJmZmM4YjMwMDFlOTA4MGE3ZWZjZTMzNjU3YWU1MzViYjZkOTkzZjYzOGYyNg"
                },
                "payload": {
                    "iss": "wso2.org/products/am",
                    "exp": 1675923588,
                    "iat": 1675919988,
                    "jti": "1a055f11-a384-4fa0-9e9f-30932b63c9a0",
                    "http://abc.org/claims/privileged": "true",
                    "http://wso2.org/claims/apiname": "PatientApi",
                    "http://wso2.org/claims/version": "1.0.0",
                    "http://wso2.org/claims/keytype": "PRODUCTION",
                    "http://wso2.org/claims/enduserTenantId": "0",
                    "http://wso2.org/claims/usertype": "Application_User",
                    "http://wso2.org/claims/apicontext": "/8838e292-a122-4dcb-b5da-af938d8aceef/exmz/patientapi/1.0.0"
                }
            }
        },
        privilegedClaimUrl: "http://abc.org/claims/privileged"
    };
    r4:AuthzResponse|error response = testClient->/authorize.post(authzRequest);
    test:assertEquals(response, {isAuthorized: true, scope: r4:PRIVILEGED});
}

// Negative test function
@test:Config {}
function testAuthorizingWithADifferentPatient() {
    r4:AuthzRequest authzRequest = {
        "fhirSecurity": {
            "securedAPICall": true,
            "fhirUser": null,
            "jwt": {
                "header": {
                    "alg": "RS256",
                    "typ": "JWT",
                    "kid": "ZjcwNmI2ZDJmNWQ0M2I5YzZiYzJmZmM4YjMwMDFlOTA4MGE3ZWZjZTMzNjU3YWU1MzViYjZkOTkzZjYzOGYyNg"
                },
                "payload": {
                    "iss": "wso2.org/products/am",
                    "exp": 1675923588,
                    "iat": 1675919988,
                    "jti": "1a055f11-a384-4fa0-9e9f-30932b63c9a0",
                    "patient": "1234",
                    "http://wso2.org/claims/apiname": "PatientApi",
                    "http://wso2.org/claims/version": "1.0.0",
                    "http://wso2.org/claims/keytype": "PRODUCTION",
                    "http://wso2.org/claims/enduserTenantId": "0",
                    "http://wso2.org/claims/usertype": "Application_User",
                    "http://wso2.org/claims/apicontext": "/8838e292-a122-4dcb-b5da-af938d8aceef/exmz/patientapi/1.0.0"
                }
            }
        },
        "patientId": "123",
        privilegedClaimUrl: "http://wso2.org/claims/privileged"
    };
    r4:AuthzResponse|error response = testClient->/authorize.post(authzRequest);
    test:assertEquals(response, {isAuthorized: false});
}

@test:Config {}
function testAuthorizingWithAnUnprivilegedUser() {
    r4:AuthzRequest authzRequest = {
        "fhirSecurity": {
            "securedAPICall": true,
            "fhirUser": null,
            "jwt": {
                "header": {
                    "alg": "RS256",
                    "typ": "JWT",
                    "kid": "ZjcwNmI2ZDJmNWQ0M2I5YzZiYzJmZmM4YjMwMDFlOTA4MGE3ZWZjZTMzNjU3YWU1MzViYjZkOTkzZjYzOGYyNg"
                },
                "payload": {
                    "iss": "wso2.org/products/am",
                    "exp": 1675923588,
                    "iat": 1675919988,
                    "jti": "1a055f11-a384-4fa0-9e9f-30932b63c9a0",
                    "http://wso2.org/claims/apiname": "PatientApi",
                    "http://wso2.org/claims/version": "1.0.0",
                    "http://wso2.org/claims/keytype": "PRODUCTION",
                    "http://wso2.org/claims/enduserTenantId": "0",
                    "http://wso2.org/claims/usertype": "Application_User",
                    "http://wso2.org/claims/apicontext": "/8838e292-a122-4dcb-b5da-af938d8aceef/exmz/patientapi/1.0.0"
                }
            }
        },
        "patientId": "123",
        privilegedClaimUrl: "http://wso2.org/claims/privileged"
    };
    r4:AuthzResponse|error response = testClient->/authorize.post(authzRequest);
    test:assertEquals(response, {isAuthorized: false});

    authzRequest = {
        "fhirSecurity": {
            "securedAPICall": true,
            "fhirUser": null,
            "jwt": {
                "header": {
                    "alg": "RS256",
                    "typ": "JWT",
                    "kid": "ZjcwNmI2ZDJmNWQ0M2I5YzZiYzJmZmM4YjMwMDFlOTA4MGE3ZWZjZTMzNjU3YWU1MzViYjZkOTkzZjYzOGYyNg"
                },
                "payload": {
                    "iss": "wso2.org/products/am",
                    "exp": 1675923588,
                    "iat": 1675919988,
                    "jti": "1a055f11-a384-4fa0-9e9f-30932b63c9a0",
                    "http://wso2.org/claims/privileged": "false",
                    "http://wso2.org/claims/apiname": "PatientApi",
                    "http://wso2.org/claims/version": "1.0.0",
                    "http://wso2.org/claims/keytype": "PRODUCTION",
                    "http://wso2.org/claims/enduserTenantId": "0",
                    "http://wso2.org/claims/usertype": "Application_User",
                    "http://wso2.org/claims/apicontext": "/8838e292-a122-4dcb-b5da-af938d8aceef/exmz/patientapi/1.0.0"
                }
            }
        },
        "patientId": "123",
        privilegedClaimUrl: "http://wso2.org/claims/privileged"
    };
    response = testClient->/authorize.post(authzRequest);
    test:assertEquals(response, {isAuthorized: false});
}

@test:Config {}
function testAuthorizingWithAnUnprivilegedUserForAllPatientData() {
    r4:AuthzRequest authzRequest = {
        "fhirSecurity": {
            "securedAPICall": true,
            "fhirUser": null,
            "jwt": {
                "header": {
                    "alg": "RS256",
                    "typ": "JWT",
                    "kid": "ZjcwNmI2ZDJmNWQ0M2I5YzZiYzJmZmM4YjMwMDFlOTA4MGE3ZWZjZTMzNjU3YWU1MzViYjZkOTkzZjYzOGYyNg"
                },
                "payload": {
                    "iss": "wso2.org/products/am",
                    "exp": 1675923588,
                    "iat": 1675919988,
                    "jti": "1a055f11-a384-4fa0-9e9f-30932b63c9a0",
                    "patient": "1234",
                    "http://wso2.org/claims/apiname": "PatientApi",
                    "http://wso2.org/claims/version": "1.0.0",
                    "http://wso2.org/claims/keytype": "PRODUCTION",
                    "http://wso2.org/claims/enduserTenantId": "0",
                    "http://wso2.org/claims/usertype": "Application_User",
                    "http://wso2.org/claims/apicontext": "/8838e292-a122-4dcb-b5da-af938d8aceef/exmz/patientapi/1.0.0"
                }
            }
        },
        privilegedClaimUrl: "http://wso2.org/claims/privileged"
    };
    r4:AuthzResponse|error response = testClient->/authorize.post(authzRequest);
    test:assertEquals(response, {isAuthorized: false});
}
