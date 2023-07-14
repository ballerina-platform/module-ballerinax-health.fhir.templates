import ballerina/http;
import ballerinax/health.fhir.r4;
import ballerina/log;

listener http:Listener interceptorListener = new (9090);

service http:InterceptableService / on interceptorListener {

    // Creates the interceptor pipeline. The function can return a single interceptor or an array of interceptors as the interceptor pipeline. If the interceptor pipeline is an array, then the request interceptor services will be executed from head to tail.
    public function createInterceptors() returns r4:FHIRResponseErrorInterceptor {
        return new r4:FHIRResponseErrorInterceptor();
    }

    isolated resource function post fhir/r4/Valueset/lookup(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError {
        log:printDebug(string `FHIR Terminology request is received. Interaction: ValueSet Lookup`);

        r4:Parameters concept = check valueSetLookUp(request);
        return concept.toJson();
    }

    isolated resource function post fhir/r4/Valueset/expand(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError {
        log:printDebug(string `FHIR Terminology request is received. Interaction: ValueSet Expand`);

        r4:ValueSet valueSet = check valueSetExpansion(request);
        return valueSet.toJson();
    }

    isolated resource function post fhir/r4/Valueset/validate_code(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError {
        log:printDebug(string `FHIR Terminology request is received. Interaction: ValueSet Validate Code`);

        r4:Parameters parameters = check valueSetValidateCode(request);
        return parameters.toJson();
    }

    isolated resource function post fhir/r4/Valueset/[string id]/lookup(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError {
        log:printDebug(string `FHIR Terminology request is received. Interaction: ValueSet Lookup with ValueSet Id: ${id}`);

        r4:Parameters concept = check valueSetLookUp(request, id);
        return concept.toJson();
    }

    isolated resource function post fhir/r4/Valueset/[string id]/expand(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError {
        log:printDebug(string `FHIR Terminology request is received. Interaction: ValueSet Expand with ValueSet Id: ${id}`);

        r4:ValueSet valueSet = check valueSetExpansion(request, id);
        return valueSet.toJson();
    }

    isolated resource function post fhir/r4/Valueset/[string id]/validate_code(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError {
        log:printDebug(string `FHIR Terminology request is received. Interaction: ValueSet Validate Code with ValueSet Id: ${id}`);

        r4:Parameters parameters = check valueSetValidateCode(request, id);
        return parameters.toJson();
    }

    isolated resource function get fhir/r4/Valueset/[string id](http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError|error {
        log:printDebug(string `FHIR Terminology request is received. Interaction: ValueSet Get with ValueSet Id: ${id}`);

        r4:ValueSet valueSet = check readValueSetById(id);
        return valueSet.toJson();
    }

    isolated resource function get fhir/r4/Valueset(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError {
        log:printDebug(string `FHIR Terminology request is received. Interaction: ValueSet Search`);

        r4:Bundle valueSet = check searchValueSet(request);
        return valueSet.toJson();
    }

    isolated resource function post fhir/r4/Codesystem/lookup(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError|error {
        log:printDebug(string `FHIR Terminology request is received. Interaction: CodeSystem Lookup`);

        r4:Parameters codeSystemLookUpResult = check codeSystemLookUp(ctx, request);
        return codeSystemLookUpResult.toJson();
    }

    isolated resource function post fhir/r4/Codesystem/subsumes(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError|error {
        log:printDebug(string `FHIR Terminology request is received. Interaction: CodeSystem Subsume`);

        r4:Parameters subsumesResult = check subsumes(ctx, request);
        return subsumesResult.toJson();
    }

    isolated resource function post fhir/r4/Codesystem/[string id]/lookup(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError|error {
        log:printDebug(string `FHIR Terminology request is received. Interaction: CodeSystem Lookup with Id: ${id}`);

        r4:Parameters codeSystemLookUpResult = check codeSystemLookUp(ctx, request, id);
        return codeSystemLookUpResult.toJson();
    }

    isolated resource function get fhir/r4/Codesystem/[string id](http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError|error {
        log:printDebug(string `FHIR Terminology request is received. Interaction: CodeSystem Get with Id: ${id}`);

        r4:CodeSystem codeSystem = check readCodeSystemById(id);
        return codeSystem.toJson();
    }

    isolated resource function get fhir/r4/Codesystem(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError|error {
        log:printDebug(string `FHIR Terminology request is received. Interaction: CodeSystem Search`);

        r4:Bundle codeSystem = check searchCodeSystem(request);
        return codeSystem.toJson();
    }
}
