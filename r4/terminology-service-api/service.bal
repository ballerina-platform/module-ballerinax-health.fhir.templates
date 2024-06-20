import ballerina/http;
import ballerinax/health.fhir.r4;
import ballerina/log;

listener http:Listener interceptorListener = new (9090);

service http:InterceptableService / on interceptorListener {

    public function createInterceptors() returns r4:FHIRResponseErrorInterceptor {
        return new r4:FHIRResponseErrorInterceptor();
    }

    isolated resource function get fhir/r4/Valueset/\$expand(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError {
        log:printDebug(string `FHIR Terminology request is received. Interaction: ValueSet Expand`);

        r4:ValueSet valueSet = check valueSetExpansionGet(request);
        return valueSet.toJson();
    }

    isolated resource function post fhir/r4/Valueset/\$expand(http:RequestContext ctx, http:Request request) returns http:Response|r4:FHIRError {
        log:printDebug(string `FHIR Terminology request is received. Interaction: ValueSet Expand`);

        r4:ValueSet valueSet = check valueSetExpansionPost(request);
        http:Response response = new;
        response.statusCode = http:STATUS_OK;
        response.setJsonPayload(valueSet.toJson());
        return response;
    }

    isolated resource function get fhir/r4/Valueset/\$validate\-code(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError {
        log:printDebug(string `FHIR Terminology request is received. Interaction: ValueSet Validate Code`);

        r4:Parameters parameters = check valueSetValidateCodeGet(request);
        return parameters.toJson();
    }

    isolated resource function post fhir/r4/Valueset/\$validate\-code(http:RequestContext ctx, http:Request request) returns http:Response|r4:FHIRError {
        log:printDebug(string `FHIR Terminology request is received. Interaction: ValueSet Validate Code`);

        r4:Parameters parameters = check valueSetValidateCodePost(request);
        http:Response response = new;
        response.statusCode = http:STATUS_OK;
        response.setJsonPayload(parameters.toJson());
        return response;
    }

    isolated resource function get fhir/r4/Valueset/[string id]/\$expand(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError {
        log:printDebug(string `FHIR Terminology request is received. Interaction: ValueSet Expand with ValueSet Id: ${id}`);

        r4:ValueSet valueSet = check valueSetExpansionGet(request, id);
        return valueSet.toJson();
    }

    isolated resource function get fhir/r4/Valueset/[string id]/\$validate\-code(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError {
        log:printDebug(string `FHIR Terminology request is received. Interaction: ValueSet Validate Code with ValueSet Id: ${id}`);

        r4:Parameters parameters = check valueSetValidateCodeGet(request, id);
        return parameters.toJson();
    }

    isolated resource function get fhir/r4/Valueset/[string id](http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError {
        log:printDebug(string `FHIR Terminology request is received. Interaction: ValueSet Get with ValueSet Id: ${id}`);

        r4:ValueSet valueSet = check readValueSetById(id);
        return valueSet.toJson();
    }

    isolated resource function get fhir/r4/Valueset(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError {
        log:printDebug(string `FHIR Terminology request is received. Interaction: ValueSet Search`);

        r4:Bundle valueSet = check searchValueSet(request);
        return valueSet.toJson();
    }

    // ===============================================================================================================================

    isolated resource function get fhir/r4/Codesystem/\$lookup(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError {
        log:printDebug(string `FHIR Terminology request is received. Interaction: CodeSystem Lookup`);

        r4:Parameters codeSystemLookUpResult = check codeSystemLookUpGet(ctx, request);
        return codeSystemLookUpResult.toJson();
    }

    isolated resource function post fhir/r4/Codesystem/\$lookup(http:RequestContext ctx, http:Request request) returns http:Response|r4:FHIRError {
        log:printDebug(string `FHIR Terminology request is received. Interaction: CodeSystem Lookup`);

        r4:Parameters result = check codeSystemLookUpPost(ctx, request);
        http:Response response = new;
        response.statusCode = http:STATUS_OK;
        response.setJsonPayload(result.toJson());
        return response;
    }

    isolated resource function get fhir/r4/Codesystem/\$subsumes(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError {
        log:printDebug(string `FHIR Terminology request is received. Interaction: CodeSystem Subsume`);

        r4:Parameters subsumesResult = check subsumesGet(ctx, request);
        return subsumesResult.toJson();
    }

    isolated resource function post fhir/r4/Codesystem/\$subsumes(http:RequestContext ctx, http:Request request) returns http:Response|r4:FHIRError {
        log:printDebug(string `FHIR Terminology request is received. Interaction: CodeSystem Subsume`);

        r4:Parameters result = check subsumesPost(ctx, request);
        http:Response response = new;
        response.statusCode = http:STATUS_OK;
        response.setJsonPayload(result.toJson());
        return response;
    }

    isolated resource function get fhir/r4/Codesystem/[string id]/\$lookup(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError {
        log:printDebug(string `FHIR Terminology request is received. Interaction: CodeSystem Lookup with Id: ${id}`);

        r4:Parameters codeSystemLookUpResult = check codeSystemLookUpGet(ctx, request, id);
        return codeSystemLookUpResult.toJson();
    }

    isolated resource function get fhir/r4/Codesystem/[string id](http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError {
        log:printDebug(string `FHIR Terminology request is received. Interaction: CodeSystem Get with Id: ${id}`);

        r4:CodeSystem codeSystem = check readCodeSystemById(id);
        return codeSystem.toJson();
    }

    isolated resource function get fhir/r4/Codesystem(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError {
        log:printDebug(string `FHIR Terminology request is received. Interaction: CodeSystem Search`);

        r4:Bundle codeSystem = check searchCodeSystem(request);
        return codeSystem.toJson();
    }

    isolated resource function post fhir/r4/create(http:RequestContext ctx, http:Request request) returns json|error|r4:FHIRError {
        log:printDebug(string `FHIR Terminology request is received. Interaction: Create CodeSystem or ValueSet`);

        return create(request);
    }
}
