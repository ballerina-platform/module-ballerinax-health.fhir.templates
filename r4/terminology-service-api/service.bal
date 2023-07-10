import ballerina/http;
import ballerinax/health.fhir.r4;

listener http:Listener interceptorListener = new (9090);

service http:InterceptableService / on interceptorListener {

    // Creates the interceptor pipeline. The function can return a single interceptor or an array of interceptors as the interceptor pipeline. If the interceptor pipeline is an array, then the request interceptor services will be executed from head to tail.
    public function createInterceptors() returns FHIRResponseErrorInterceptor {
        return new FHIRResponseErrorInterceptor();
    }

    isolated resource function post fhir/r4/Valueset/lookup(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError {
         r4:CodeSystemConcept[]|r4:CodeSystemConcept concept = check valueSetLookUp(request);
        return concept.toJson();
    }

    isolated resource function post fhir/r4/Valueset/expand(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError {
        r4:ValueSet valueSet = check valueSetExpansion(request);
        return valueSet.toJson();
    }

    isolated resource function post fhir/r4/Valueset/validate_code(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError {
        Parameters parameters = check valueSetValidateCode(request);
        return parameters.toJson();
    }

    isolated resource function post fhir/r4/Valueset/[string id]/validate_code(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError {
        Parameters parameters = check valueSetValidateCode(request, id);
        return parameters.toJson();
    }

    // isolated resource function get fhir/r4/Valueset/url/[string url](http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError|error {
    //     r4:ValueSet valueSet = check readValueSetByUrl(url);
    //     return valueSet.toJson();
    // }

    isolated resource function get fhir/r4/Valueset/[string id](http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError|error {
        r4:ValueSet valueSet = check readValueSetById(id);
        return valueSet.toJson();
    }

    isolated resource function get fhir/r4/Valueset(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError {
        r4:Bundle valueSet = check searchValueSet(request);
        return valueSet.toJson();
    }

    // isolated resource function get fhir/r4/Codesystem/url/[string url](http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError|error {
    //     r4:CodeSystem codeSystem = check readCodeSystemByUrl(url);
    //     return codeSystem.toJson();
    // }

    isolated resource function post fhir/r4/Codesystem/lookup(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError|error {
        r4:CodeSystemConcept[]|r4:CodeSystemConcept codeSystemLookUpResult = check codeSystemLookUp(ctx, request);
        return codeSystemLookUpResult.toJson();
    }

    isolated resource function post fhir/r4/Codesystem/subsumes(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError|error {
        string subsumesResult = check subsumes(ctx, request);
        return {"name": "outcome", "valueCode": subsumesResult}.toJson();
    }

    isolated resource function post fhir/r4/Codesystem/[string id]/lookup(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError|error {
        r4:CodeSystemConcept[]|r4:CodeSystemConcept codeSystemLookUpResult = check codeSystemLookUp(ctx, request, id);
        return codeSystemLookUpResult.toJson();
    }

    isolated resource function get fhir/r4/Codesystem/[string id](http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError|error {
        r4:CodeSystem codeSystem = check readCodeSystemById(id);
        return codeSystem.toJson();
    }

    isolated resource function get fhir/r4/Codesystem(http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError|error {
        r4:Bundle codeSystem = check searchCodeSystem(request);
        return codeSystem.toJson();
    }
}
