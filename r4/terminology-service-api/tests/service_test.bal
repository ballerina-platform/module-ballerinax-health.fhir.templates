import ballerina/http;
import ballerinax/health.fhir.r4.terminology;
import ballerinax/health.fhir.r4;
import ballerina/test;

http:Client csClient = check new ("http://localhost:9090/fhir/r4/Codesystem");
http:Client vsClient = check new ("http://localhost:9090/fhir/r4/Valueset");

@test:Config {
    groups: ["codesystem", "get_by_id_codesystem", "successful_scenario"]
}
public function getByIdCodeSystem1() returns error? {
    http:Response response = check csClient->get("/account-status");

    json expected = returnCodeSystemData("account-status");
    test:assertEquals(response.getJsonPayload(), expected);
}

@test:Config {
    groups: ["codesystem", "get_by_id_codesystem", "successful_scenario"]
}
public function getByIdCodeSystem2() returns error? {
    http:Response response = check csClient->get("/account-status%7C4.0.1");

    json expected = returnCodeSystemData("account-status");
    test:assertEquals(response.getJsonPayload(), expected);
}

@test:Config {
    groups: ["codesystem", "get_by_id_codesystem", "successful_scenario"]
}
public function searchCodeSystem1() returns error? {
    http:Response response = check csClient->get("?url=http://hl7.org/fhir/account-status");
    json actualJson = check response.getJsonPayload();
    // r4:Bundle actual = check parser:parse(actualJson, r4:Bundle).ensureType();
    r4:Bundle actual = check actualJson.cloneWithType(r4:Bundle);

    r4:Bundle expected = check returnCodeSystemData("account-status-bundle").cloneWithType(r4:Bundle);
    expected.meta.lastUpdated = actual.meta.lastUpdated;

    test:assertEquals(actual.toJson(), expected.toJson());
}

@test:Config {
    groups: ["codesystem", "get_by_id_codesystem", "successful_scenario"]
}
public function searchCodeSystem2() returns error? {
    http:Response response = check csClient->get("?url=http://hl7.org/fhir/account-status");
    json actualJson = check response.getJsonPayload();
    // r4:Bundle actual = check parser:parse(actualJson, r4:Bundle).ensureType();
    r4:Bundle actual = check actualJson.cloneWithType(r4:Bundle);

    r4:Bundle expected = check returnCodeSystemData("account-status-bundle").cloneWithType(r4:Bundle);
    expected.meta.lastUpdated = actual.meta.lastUpdated;

    test:assertEquals(actual.toJson(), expected.toJson());
}

@test:Config {
    groups: ["codesystem", "lookup_codesystem", "successful_scenario"]
}
public function lookupCodeSystem1() returns error? {
    http:Response response = check csClient->get("/%24lookup?system=http://hl7.org/fhir/account-status&code=inactive");
    json actual = check response.getJsonPayload();

    json expected = returnCodeSystemData("account-status-inactive");
    test:assertEquals(actual, expected);
}

@test:Config {
    groups: ["codesystem", "lookup_codesystem", "successful_scenario"]
}
public function lookupCodeSystem2() returns error? {
    http:Response response = check csClient->get("/account-status/%24lookup?code=inactive", ());
    json actual = check response.getJsonPayload();

    json expected = returnCodeSystemData("account-status-inactive");
    test:assertEquals(actual, expected);
}

@test:Config {
    groups: ["codesystem", "lookup_codesystem", "successful_scenario"]
}
public function lookupCodeSystem3() returns error? {
    r4:Coding|r4:FHIRError coding = terminology:createCoding("http://hl7.org/fhir/account-status", "inactive");
    r4:Parameters p = {'parameter: [{name: "coding", valueCoding: check coding}]};
    http:Response response = check csClient->post("/%24lookup", p);
    json actual = check response.getJsonPayload();

    json expected = returnCodeSystemData("account-status-inactive");
    test:assertEquals(actual, expected);
}

@test:Config {
    groups: ["codesystem", "lookup_codesystem", "failure_scenario"]
}
public function lookupCodeSystem4() returns error? {
    http:Response response = check csClient->post("/%24lookup", ());
    json actualJson = check response.getJsonPayload();
    r4:OperationOutcome actual = check actualJson.cloneWithType(r4:OperationOutcome);
    test:assertEquals((<r4:CodeableConcept>actual.issue[0].details).text, "Empty request payload");
}

@test:Config {
    groups: ["codesystem", "lookup_codesystem", "failure_scenario"]
}
public function lookupCodeSystem5() returns error? {
    http:Response response = check csClient->get("/%24lookup?code=inactive", ());
    json actualJson = check response.getJsonPayload();
    r4:OperationOutcome actual = check actualJson.cloneWithType(r4:OperationOutcome);

    json expectedjson = returnCodeSystemData("lookup-error");
    r4:OperationOutcome expected = check expectedjson.cloneWithType(r4:OperationOutcome);

    expected.issue[0].diagnostics = (<r4:OperationOutcomeIssue[]>actual.issue)[0].diagnostics;
    test:assertEquals(actual, expected);
}

@test:Config {
    groups: ["codesystem", "lookup_codesystem", "failure_scenario"]
}
public function lookupCodeSystem6() returns error? {
    json codingJson = returnCodeSystemData("invalid-json-payload");
    http:Response response = check csClient->post("/%24lookup", codingJson);
    json actualJson = check response.getJsonPayload();
    r4:OperationOutcome actual = check actualJson.cloneWithType(r4:OperationOutcome);

    json expectedjson = returnCodeSystemData("lookup-error2");
    r4:OperationOutcome expected = check expectedjson.cloneWithType(r4:OperationOutcome);

    expected.issue[0].diagnostics = (<r4:OperationOutcomeIssue[]>actual.issue)[0].diagnostics;
    test:assertEquals(actual, expected);
}

@test:Config {
    groups: ["codesystem", "lookup_codesystem", "failure_scenario"]
}
public function lookupCodeSystem7() returns error? {
    http:Response response = check csClient->post("/%24lookup", ());
    json actualJson = check response.getJsonPayload();
    r4:OperationOutcome actual = check actualJson.cloneWithType(r4:OperationOutcome);
    test:assertEquals((<r4:CodeableConcept>actual.issue[0].details).text, "Empty request payload");
}

@test:Config {
    groups: ["codesystem", "lookup_codesystem", "failure_scenario"]
}
public function lookupCodeSystem8() returns error? {
    http:Response response = check csClient->post("/%24lookup", {});
    json actualJson = check response.getJsonPayload();
    r4:OperationOutcome actual = check actualJson.cloneWithType(r4:OperationOutcome);
    test:assertEquals((<r4:CodeableConcept>actual.issue[0].details).text, "Invalid Coding value");
}

@test:Config {
    groups: ["codesystem", "lookup_codesystem", "failure_scenario"]
}
public function lookupCodeSystem9() returns error? {
    r4:Parameters parameters = {'parameter: [{name: "sample"}]};
    http:Response response = check csClient->post("/%24lookup", parameters);
    json actualJson = check response.getJsonPayload();
    r4:OperationOutcome actual = check actualJson.cloneWithType(r4:OperationOutcome);
    test:assertEquals((<r4:CodeableConcept>actual.issue[0].details).text, "Invalid request payload");
}

@test:Config {
    groups: ["codesystem", "lookup_codesystem", "failure_scenario"]
}
public function lookupCodeSystem10() returns error? {
    r4:Coding coding = check terminology:createCoding("http://hl7.org/fhir/account-status", "inactive");
    coding.system = ();
    r4:Parameters parameters = {'parameter: [{name: "coding", valueCoding: coding}]};
    http:Response response = check csClient->post("/%24lookup", parameters);
    json actualJson = check response.getJsonPayload();
    r4:OperationOutcome actual = check actualJson.cloneWithType(r4:OperationOutcome);
    test:assertEquals((<r4:CodeableConcept>actual.issue[0].details).text, "Can not find a CodeSystem");
}

@test:Config {
    groups: ["codesystem", "subsume_codesystem", "successful_scenario"]
}
public function subsumeCodeSystem1() returns error? {
    http:Response response = check csClient->get("/%24subsumes?codeA=Type&codeB=Any&system=http://hl7.org/fhir/abstract-types", ());
    json actual = check response.getJsonPayload();

    json expected = returnCodeSystemData("subsume-notequal");
    test:assertEquals(actual, expected);
}

@test:Config {
    groups: ["codesystem", "subsume_codesystem", "successful_scenario"]
}
public function subsumeCodeSystem2() returns error? {
    http:Response response = check csClient->get("/%24subsumes?codeA=Type&codeB=Type&system=http://hl7.org/fhir/abstract-types", ());
    json actual = check response.getJsonPayload();

    json expected = returnCodeSystemData("subsume-equal");
    test:assertEquals(actual, expected);
}

@test:Config {
    groups: ["codesystem", "subsume_codesystem", "successful_scenario"]
}
public function subsumeCodeSystem3() returns error? {

    r4:Coding codingA = check terminology:createCoding("http://hl7.org/fhir/account-status", "inactive");
    r4:Coding codingB = check terminology:createCoding("http://hl7.org/fhir/account-status", "inactive");

    r4:ParametersParameter cA = {name: "codingA", valueCoding: codingA};
    r4:ParametersParameter cB = {name: "codingB", valueCoding: codingB};
    r4:ParametersParameter system = {name: "system", valueUri: "http://hl7.org/fhir/account-status"};
    r4:Parameters requestPayload = {'parameter: [cA, cB, system]};

    http:Response response = check csClient->post("/%24subsumes", requestPayload);
    json actual = check response.getJsonPayload();

    json expected = returnCodeSystemData("subsume-equal");
    test:assertEquals(actual, expected);
}

@test:Config {
    groups: ["codesystem", "subsume_codesystem", "failure_scenario"]
}
public function subsumeCodeSystem5() returns error? {

    http:Response response = check csClient->get("/%24subsumes?codeA=Type&codeB=Type", ());
    json actualJson = check response.getJsonPayload();
    r4:OperationOutcome actual = check actualJson.cloneWithType(r4:OperationOutcome);

    json expectedjson = returnCodeSystemData("subsume-error");
    r4:OperationOutcome expected = check expectedjson.cloneWithType(r4:OperationOutcome);

    expected.issue[0].diagnostics = (<r4:OperationOutcomeIssue[]>actual.issue)[0].diagnostics;
    test:assertEquals(actual, expected);
}

@test:Config {
    groups: ["codesystem", "subsume_codesystem", "failure_scenario"]
}
public function subsumeCodeSystem6() returns error? {

    json requestJson = returnCodeSystemData("invalid-json-payload");
    http:Response response = check csClient->post("/%24subsumes", requestJson);
    json actualJson = check response.getJsonPayload();
    r4:OperationOutcome actual = check actualJson.cloneWithType(r4:OperationOutcome);

    json expectedjson = returnCodeSystemData("subsume-error2");
    r4:OperationOutcome expected = check expectedjson.cloneWithType(r4:OperationOutcome);

    expected.issue[0].diagnostics = (<r4:OperationOutcomeIssue[]>actual.issue)[0].diagnostics;
    test:assertEquals(actual, expected);
}

@test:Config {
    groups: ["codesystem", "subsume_codesystem", "failure_scenario"]
}
public function subsumeCodeSystem7() returns error? {
    http:Response response = check csClient->post("/%24subsumes", ());
    json actualJson = check response.getJsonPayload();
    r4:OperationOutcome actual = check actualJson.cloneWithType(r4:OperationOutcome);
    test:assertEquals((<r4:CodeableConcept>actual.issue[0].details).text, "Empty request payload or invalid json format");
}

// ===========================Value set======================================

@test:Config {
    groups: ["valueSet", "get_by_id_valueSet", "successful_scenario"]
}
public function getByIdValueSet1() returns error? {
    http:Response response = check vsClient->get("/account-status");

    json expected = returnValueSetData("account-status");
    test:assertEquals(response.getJsonPayload(), expected);
}

@test:Config {
    groups: ["valueSet", "get_by_id_valueSet", "successful_scenario"]
}
public function getByIdValueSet2() returns error? {
    http:Response response = check vsClient->get("/account-status%7C4.0.1");

    json expected = returnValueSetData("account-status");
    test:assertEquals(response.getJsonPayload(), expected);
}

@test:Config {
    groups: ["valueset", "search_valueset", "successful_scenario"]
}
public function searchValueSet1() returns error? {
    http:Response response = check vsClient->get("?url=http://hl7.org/fhir/ValueSet/abstract-types");
    json actualJson = check response.getJsonPayload();
    r4:Bundle actual = check actualJson.cloneWithType(r4:Bundle);

    r4:Bundle expected = check returnValueSetData("account-status-bundle").cloneWithType(r4:Bundle);
    expected.meta.lastUpdated = actual.meta.lastUpdated;
    test:assertEquals(response.getJsonPayload(), expected.toJson());
}

@test:Config {
    groups: ["valueset", "validate_code_valueset", "successful_scenario"]
}
public function validateCodeValueSet1() returns error? {
    http:Response response = check vsClient->get("/%24validate-code?system=http://hl7.org/fhir/ValueSet/account-status&code=inactive", ());
    json actual = check response.getJsonPayload();

    json expected = returnValueSetData("validate-code");
    test:assertEquals(actual, expected);
}

@test:Config {
    groups: ["valueset", "validate_code_valueset", "successful_scenario"]
}
public function validateCodeValueSet2() returns error? {
    json requestPayload = returnValueSetData("account-status-as-parameter");
    http:Response response = check vsClient->post("/%24validate-code", requestPayload);
    json actual = check response.getJsonPayload();

    json expected = returnValueSetData("validate-code");
    test:assertEquals(actual, expected);
}

@test:Config {
    groups: ["valueset", "validate_code_valueset", "successful_scenario"]
}
public function validateCodeValueSet3() returns error? {
    http:Response response = check vsClient->get("/account-status/%24validate-code?code=inactive", ());
    json actual = check response.getJsonPayload();

    json expected = returnValueSetData("validate-code");
    test:assertEquals(actual, expected);
}

@test:Config {
    groups: ["valueset", "validate_code_valueset", "successful_scenario"]
}
public function validateCodeValueSet4() returns error? {
    json requestPayload = returnValueSetData("account-status-as-parameter");
    http:Response response = check vsClient->post("/%24validate-code", requestPayload);
    json actual = check response.getJsonPayload();

    json expected = returnValueSetData("validate-code");
    test:assertEquals(actual, expected);
}

@test:Config {
    groups: ["valueset", "validate_code_valueset", "successful_scenario"]
}
public function validateCodeValueSet5() returns error? {
    json requestPayload = returnValueSetData("account-status-as-parameter2");
    r4:Parameters parameters = check requestPayload.cloneWithType(r4:Parameters);
    r4:CodeableConcept codeableConcept = check r4:terminologyProcessor.createCodeableConcept("http://hl7.org/fhir/ValueSet/account-status", "inactive");
    _ = (<r4:ParametersParameter[]>parameters.'parameter).push({name: "codeableConcept", valueCodeableConcept: codeableConcept});

    http:Response response = check vsClient->post("/%24validate-code", parameters);
    json actual = check response.getJsonPayload();

    json expected = returnValueSetData("validate-code");
    test:assertEquals(actual, expected);
}

@test:Config {
    groups: ["valueset", "validate_code_valueset", "failure_scenario"]
}
public function validateCodeValueSet6() returns error? {
    http:Response response = check vsClient->post("/%24validate-code", ());
    json actualJson = check response.getJsonPayload();
    r4:OperationOutcome actual = check actualJson.cloneWithType(r4:OperationOutcome);

    test:assertEquals((<r4:CodeableConcept>actual.issue[0].details).text, "Empty request payload");
}

@test:Config {
    groups: ["valueset", "validate_code_valueset", "failure_scenario"]
}
public function validateCodeValueSet7() returns error? {
    http:Response response = check vsClient->post("/%24validate-code", {});
    json actualJson = check response.getJsonPayload();
    r4:OperationOutcome actual = check actualJson.cloneWithType(r4:OperationOutcome);

    test:assertEquals((<r4:CodeableConcept>actual.issue[0].details).text, "Invalid request payload");
}

@test:Config {
    groups: ["valueset", "validate_code_valueset", "failure_scenario"]
}
public function validateCodeValueSet8() returns error? {
    json requestPayload = returnValueSetData("coding-as-parameter");
    http:Response response = check vsClient->post("/%24validate-code", requestPayload);
    json actualJson = check response.getJsonPayload();
    r4:OperationOutcome actual = check actualJson.cloneWithType(r4:OperationOutcome);

    test:assertEquals((<r4:CodeableConcept>actual.issue[0].details).text, "Invalid request payload");
}

@test:Config {
    groups: ["valueset", "validate_code_valueset", "failure_scenario"]
}
public function validateCodeValueSet9() returns error? {
    http:Response response = check vsClient->get("/%24validate-code");
    json actualJson = check response.getJsonPayload();
    r4:OperationOutcome actual = check actualJson.cloneWithType(r4:OperationOutcome);

    test:assertEquals((<r4:CodeableConcept>actual.issue[0].details).text, "Can not find a ValueSet");
}

@test:Config {
    groups: ["valueset", "expand_valueset", "successful_scenario"]
}
public function expandValueSet1() returns error? {
    http:Response response = check vsClient->get("/%24expand?url=http://hl7.org/fhir/ValueSet/account-status&filter=account", ());
    json actualJson = check response.getJsonPayload();
    r4:ValueSet actual = check actualJson.cloneWithType(r4:ValueSet);

    json expectedJson = returnValueSetData("expanded-account-status");
    r4:ValueSet expected = check expectedJson.cloneWithType(r4:ValueSet);

    expected.expansion.timestamp = (<r4:ValueSetExpansion>actual.expansion).timestamp;
    test:assertEquals(actual, expected);
}

@test:Config {
    groups: ["valueset", "expand_valueset", "successful_scenario"]
}
public function expandValueSet2() returns error? {
    http:Response response = check vsClient->get("/account-status/%24expand?filter=account", ());
    json actualJson = check response.getJsonPayload();
    r4:ValueSet actual = check actualJson.cloneWithType(r4:ValueSet);

    json expectedJson = returnValueSetData("expanded-account-status");
    r4:ValueSet expected = check expectedJson.cloneWithType(r4:ValueSet);

    expected.expansion.timestamp = (<r4:ValueSetExpansion>actual.expansion).timestamp;
    test:assertEquals(actual, expected);
}

@test:Config {
    groups: ["valueset", "expand_valueset", "successful_scenario"]
}
public function expandValueSet3() returns error? {
    json requestPayload = returnValueSetData("account-status-as-parameter");
    http:Response response = check vsClient->post("/%24expand?filter=account", requestPayload);

    json actualJson = check response.getJsonPayload();
    r4:ValueSet actual = check actualJson.cloneWithType(r4:ValueSet);

    json expectedJson = returnValueSetData("expanded-account-status");
    r4:ValueSet expected = check expectedJson.cloneWithType(r4:ValueSet);

    expected.expansion.timestamp = (<r4:ValueSetExpansion>actual.expansion).timestamp;
    test:assertEquals(actual, expected);
}

@test:Config {
    groups: ["valueset", "expand_valueset", "failure_scenario"]
}
public function expandValueSet4() returns error? {
    http:Response response = check vsClient->post("/%24expand", ());

    json actualJson = check response.getJsonPayload();
    r4:OperationOutcome actual = check actualJson.cloneWithType(r4:OperationOutcome);

    json expectedJson = returnValueSetData("expand-error");
    r4:OperationOutcome expected = check expectedJson.cloneWithType(r4:OperationOutcome);

    expected.issue[0].diagnostics = (<r4:OperationOutcomeIssue[]>actual.issue)[0].diagnostics;
    test:assertEquals(actual, expected);
}

@test:Config {
    groups: ["valueset", "expand_valueset", "failure_scenario"]
}
public function expandValueSet5() returns error? {
    http:Response response = check vsClient->post("/%24expand", {});

    json actualJson = check response.getJsonPayload();
    r4:OperationOutcome actual = check actualJson.cloneWithType(r4:OperationOutcome);
    test:assertEquals((<r4:CodeableConcept>actual.issue[0].details).text, "Invalid request payload");
}
