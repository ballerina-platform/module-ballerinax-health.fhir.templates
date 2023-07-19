import ballerinax/health.fhir.r4.terminology;
import ballerinax/health.fhir.r4;
import ballerina/regex;
import ballerina/http;
import ballerina/time;

public isolated function readCodeSystemById(string id) returns r4:CodeSystem|r4:FHIRError {
    string[] split = regex:split(id, string `\|`);
    return terminology:readCodeSystemById(split[0], split.length() > 1 ? split[1] : ());
}

public isolated function readValueSetById(string id) returns r4:ValueSet|r4:FHIRError {
    string[] split = regex:split(id, string `\|`);
    r4:ValueSet valueSet = check terminology:readValueSetById(split[0], split.length() > 1 ? split[1] : ());
    return valueSet;
}

public isolated function readCodeSystemByUrl(string url) returns r4:CodeSystem|r4:FHIRError {
    string[] split = regex:split(url, string `\|`);
    return terminology:readCodeSystemByUrl(split[0], split.length() > 1 ? split[1] : ());
}

public isolated function readValueSetByUrl(string url) returns r4:ValueSet|r4:FHIRError {
    string[] split = regex:split(url, string `\|`);
    return terminology:readValueSetByUrl(split[0], split.length() > 1 ? split[1] : ());
}

public isolated function searchValueSet(http:Request request) returns r4:Bundle|r4:FHIRError {
    map<string[]> searchParams = request.getQueryParams();
    map<r4:RequestSearchParameter[]> params = prepareRequestSearchParameter(searchParams);

    r4:ValueSet[] valueSets = check terminology:searchValueSets(params);
    r4:BundleEntry[] entries = valueSets.'map(v => <r4:BundleEntry>{'resource: v, search: {mode: r4:MATCH}});

    return {
        'type: r4:BUNDLE_TYPE_SEARCHSET,
        meta: {
            lastUpdated: time:utcToString(time:utcNow())
        },
        total: entries.length(),
        entry: entries
    };
}

public isolated function searchCodeSystem(http:Request request) returns r4:Bundle|r4:FHIRError {
    map<string[]> searchParams = request.getQueryParams();
    map<r4:RequestSearchParameter[]> params = prepareRequestSearchParameter(searchParams);

    r4:CodeSystem[] codeSystems = check terminology:searchCodeSystems(params);
    r4:BundleEntry[] entries = codeSystems.'map(c => <r4:BundleEntry>{'resource: c, search: {mode: r4:MATCH}});

    return {
        'type: r4:BUNDLE_TYPE_SEARCHSET,
        meta: {
            lastUpdated: time:utcToString(time:utcNow())
        },
        total: entries.length(),
        entry: entries
    };
}

public isolated function valueSetExpansionGet(http:Request request, string? id = ()) returns r4:ValueSet|r4:FHIRError {

    map<string[]> searchParams = request.getQueryParams();
    map<r4:RequestSearchParameter[]> searchParameters = prepareRequestSearchParameter(searchParams);

    r4:ValueSet valueSet = {status: "unknown"};
    if id is string {
        valueSet = check terminology:valueSetExpansion(searchParameters, vs = check readValueSetById(id));
    } else {
        string|() system = request.getQueryParamValue("url") ?: ();
        valueSet = check terminology:valueSetExpansion(searchParameters, system = system);
    }
    return valueSet;
}

public isolated function valueSetExpansionPost(http:Request request, string? id = ()) returns r4:ValueSet|r4:FHIRError {

    map<string[]> searchParams = request.getQueryParams();
    map<r4:RequestSearchParameter[]> searchParameters = prepareRequestSearchParameter(searchParams);

    r4:ValueSet valueSet = {status: "unknown"};
    if id is string {
        valueSet = check terminology:valueSetExpansion(searchParameters, vs = check readValueSetById(id));
    } else {
        json|http:ClientError jsonPayload = request.getJsonPayload();

        if jsonPayload is json {
            r4:Parameters|error parameters = jsonPayload.cloneWithType(r4:Parameters);
            if parameters is r4:Parameters && parameters.'parameter is r4:ParametersParameter[] {
                foreach var item in <r4:ParametersParameter[]>parameters.'parameter {
                    match item.name {
                        "valueSet" => {
                            anydata temp = item.'resource is r4:DomainResource ? item.'resource : ();
                            r4:ValueSet|error cloneWithType = temp.cloneWithType(r4:ValueSet);
                            valueSet = cloneWithType is r4:ValueSet ? cloneWithType : valueSet;
                        }
                    }
                }
                valueSet = check terminology:valueSetExpansion(searchParameters, vs = valueSet);
            } else {
                return r4:createFHIRError(
            "Invalid request payload",
            r4:ERROR,
            r4:INVALID_REQUIRED,
            cause = parameters is error ? parameters : (),
            httpStatusCode = http:STATUS_BAD_REQUEST);
            }
        } else {
            string|() system = request.getQueryParamValue("url") ?: ();
            valueSet = check terminology:valueSetExpansion(searchParameters, system = system);
        }
    }
    return valueSet;
}

public isolated function valueSetValidateCodePost(http:Request request) returns r4:Parameters|r4:FHIRError {
    r4:Parameters|r4:FHIRError concept = valueSetLookUpPost(request);
    return validationResultToParameters(concept);
}

public isolated function valueSetValidateCodeGet(http:Request request, string? id = ()) returns r4:Parameters|r4:FHIRError {
    r4:Parameters|r4:FHIRError concept = valueSetLookUpGet(request, id);
    return validationResultToParameters(concept);
}

isolated function validationResultToParameters(r4:Parameters|r4:FHIRError concept) returns r4:Parameters|r4:FHIRError {
    r4:ParametersParameter[] params = [];
    if concept is r4:FHIRError {
        if concept.message().matches(re `Can not find any valid concepts for the code:.*`) {
            params.push({name: "result", valueBoolean: false});
        } else {
            return concept;
        }
    } else {
        if (<r4:ParametersParameter[]>concept.'parameter).length() > 0 {
            foreach var c in <r4:ParametersParameter[]>concept.'parameter {
                _ = c.name == "name" ? params.push({name: "result", valueBoolean: true}) : "";
                _ = c.name == "display" ? params.push(c) : "";
                _ = c.name == "definition" ? params.push(c) : "";
            }
        } else {
            params.push({name: "result", valueBoolean: false});
        }
    }

    return {
        'parameter: params
    };
}

public isolated function codeSystemLookUpGet(http:RequestContext ctx, http:Request request, string? id = ()) returns r4:Parameters|r4:FHIRError {

    string? system = request.getQueryParamValue("system");
    string? codeValue = request.getQueryParamValue("code");

    r4:CodeSystemConcept[]|r4:CodeSystemConcept result;
    if id is string {
        result = check terminology:codeSystemLookUp(<r4:code>codeValue, cs = check readCodeSystemById(id));
    } else if system is string {
        result = check terminology:codeSystemLookUp(<r4:code>codeValue, cs = check readCodeSystemByUrl(system));
    } else {
        return r4:createFHIRError(
            "Can not find a CodeSystem",
            r4:ERROR,
            r4:INVALID_REQUIRED,
            diagnostic = "Either CodeSystem record or system URL should be provided as input",
            httpStatusCode = http:STATUS_BAD_REQUEST);
    }

    return codesystemConceptsToParameters(result);
}

public isolated function codeSystemLookUpPost(http:RequestContext ctx, http:Request request) returns r4:Parameters|r4:FHIRError {
    r4:Coding? codingValue = ();
    r4:uri? system = ();

    json|http:ClientError jsonPayload = request.getJsonPayload();
    if jsonPayload is json {
        r4:Parameters|error parse = jsonPayload.cloneWithType(r4:Parameters);
        if parse is r4:Parameters && parse.'parameter is r4:ParametersParameter[] {
            foreach var item in <r4:ParametersParameter[]>parse.'parameter {
                match item.name {
                    "coding" => {
                        codingValue = item.valueCoding;
                        if (<r4:Coding>codingValue).system is r4:uri {
                            system = (<r4:Coding>codingValue).system;
                        }
                    }
                }
            }
        } else {
            return r4:createFHIRError(
            "Invalid Coding value",
            r4:ERROR,
            r4:INVALID_REQUIRED,
            diagnostic = "Payload should contains a Coding data",
            cause = parse is error ? parse : (),
            httpStatusCode = http:STATUS_BAD_REQUEST);
        }
    } else {
        return r4:createFHIRError(
            "Empty request payload",
            r4:ERROR,
            r4:INVALID_REQUIRED,
            diagnostic = "Payload should contains a Coding data",
            httpStatusCode = http:STATUS_BAD_REQUEST);
    }

    r4:CodeSystemConcept[]|r4:CodeSystemConcept result;
    if codingValue !is r4:Coding {
        return r4:createFHIRError(
            "Invalid request payload",
            r4:ERROR,
            r4:INVALID_REQUIRED,
            diagnostic = "Payload should contains a Coding data",
            httpStatusCode = http:STATUS_BAD_REQUEST);
    } else if system is string {
        result = check terminology:codeSystemLookUp(codingValue, cs = check readCodeSystemByUrl(system));
    } else {
        return r4:createFHIRError(
            "Can not find a CodeSystem",
            r4:ERROR,
            r4:INVALID_REQUIRED,
            diagnostic = "Can not find the system URL in the provided Coding data",
            httpStatusCode = http:STATUS_BAD_REQUEST);
    }

    return codesystemConceptsToParameters(result);
}

isolated function codesystemConceptsToParameters(r4:CodeSystemConcept[]|r4:CodeSystemConcept concepts) returns r4:Parameters {
    r4:Parameters parameters = {};
    if concepts is r4:CodeSystemConcept {
        parameters = {
            'parameter: [
                {name: "name", valueString: concepts.code},
                {name: "display", valueString: concepts.display},
                {name: "definition", valueString: concepts.definition}
            ]
        };
    } else {
        r4:ParametersParameter[] p = [];
        foreach r4:CodeSystemConcept item in concepts {
            p.push({name: "name", valueString: item.code},
                    {name: "display", valueString: item.display},
                    {name: "definition", valueString: item.definition});
        }
        parameters = {'parameter: p};
    }
    return parameters;
}

public isolated function subsumes(http:RequestContext ctx, http:Request request) returns r4:Parameters|r4:FHIRError {

    string? 'version = request.getQueryParamValue("version");
    r4:uri? system = request.getQueryParamValue("system");
    r4:code? codeA = request.getQueryParamValue("codeA");
    r4:code? codeB = request.getQueryParamValue("codeB");

    json|http:ClientError jsonPayload = request.getJsonPayload();
    if jsonPayload is json {
        r4:Parameters|error parameters = jsonPayload.cloneWithType(r4:Parameters);
        if parameters is r4:Parameters && parameters.'parameter is r4:ParametersParameter[] {
            r4:Coding codingA = {};
            r4:Coding codingB = {};
            foreach var item in <r4:ParametersParameter[]>parameters.'parameter {
                match item.name {
                    "codingA" => {
                        codingA = item.valueCoding ?: {};
                    }

                    "codingB" => {
                        codingB = item.valueCoding ?: {};
                    }

                    "version" => {
                        'version = item.valueString ?: 'version;
                    }

                    "system" => {
                        system = item.valueUri ?: system;
                    }
                }
            }
            return terminology:subsumes(codingA, codingB, system = system, version = 'version);
        } else {
            return r4:createFHIRError(
            "Invalid payload",
            r4:ERROR,
            r4:INVALID_REQUIRED,
            diagnostic = "The payload should contain 2 Coding concepts to execute this operation",
            httpStatusCode = http:STATUS_BAD_REQUEST);
        }
    } else if system is string && codeA is r4:code && codeB is r4:code {
        return terminology:subsumes(codeA, codeB, system = system, version = 'version);
    } else {
        return r4:createFHIRError(
            "Missing required input parameters",
            r4:ERROR,
            r4:INVALID_REQUIRED,
            diagnostic = "The request should conain 2 code concepts or 2 coding concepts and CodeSystem system URL",
            httpStatusCode = http:STATUS_BAD_REQUEST);
    }
}

public isolated function valueSetLookUpPost(http:Request request) returns r4:Parameters|r4:FHIRError {
    r4:Coding?|r4:CodeableConcept? codingValue = ();
    r4:ValueSet? valueSet = ();

    json|http:ClientError jsonPayload = request.getJsonPayload();
    if jsonPayload is json {
        r4:Parameters|error parse = jsonPayload.cloneWithType(r4:Parameters);
        if parse is r4:Parameters && parse.'parameter is r4:ParametersParameter[] {
            foreach var item in <r4:ParametersParameter[]>parse.'parameter {
                match item.name {
                    "coding" => {
                        codingValue = <r4:Coding>item.valueCoding;
                    }

                    "codeableConcept" =>{
                        codingValue = <r4:CodeableConcept>item.valueCodeableConcept;
                    }

                    "valueSet" => {
                        anydata temp = item.'resource is r4:DomainResource ? item.'resource : ();
                        r4:ValueSet|error cloneWithType = temp.cloneWithType(r4:ValueSet);
                        if cloneWithType is r4:ValueSet {
                            valueSet = cloneWithType;
                        }
                    }
                }
            }
        } else {
            return r4:createFHIRError(
            "Invalid request payload",
            r4:ERROR,
            r4:INVALID_REQUIRED,
            diagnostic = "Payload should contains ValueSet record and Coding data",
            cause = parse is error ? parse : (),
            httpStatusCode = http:STATUS_BAD_REQUEST);
        }
    } else {
        return r4:createFHIRError(
            "Empty request payload",
            r4:ERROR,
            r4:INVALID_REQUIRED,
            diagnostic = "Payload should contains ValueSet record and Coding data",
            httpStatusCode = http:STATUS_BAD_REQUEST);
    }

    if valueSet is r4:ValueSet && (codingValue is r4:Coding || codingValue is r4:CodeableConcept){
        return codesystemConceptsToParameters(check terminology:valueSetLookUp(codingValue, vs = valueSet));
    } else {
        return r4:createFHIRError(
            "Invalid request payload",
            r4:ERROR,
            r4:INVALID_REQUIRED,
            diagnostic = "Payload should contains ValueSet record or Coding data or Codeable Concept data with proper system URL",
            httpStatusCode = http:STATUS_BAD_REQUEST);
    }
}

public isolated function valueSetLookUpGet(http:Request request, string? id = ()) returns r4:Parameters|r4:FHIRError {

    string? system = request.getQueryParamValue("system");
    r4:code? codeValue = request.getQueryParamValue("code");

    r4:CodeSystemConcept[]|r4:CodeSystemConcept result;
    if id is string {
        result = check terminology:valueSetLookUp(<r4:code>codeValue, vs = check readValueSetById(id));
    } else if system is string {
        result = check terminology:valueSetLookUp(<r4:code>codeValue, vs = check readValueSetByUrl(system));
    } else {
        return r4:createFHIRError(
            "Can not find a ValueSet",
            r4:ERROR,
            r4:INVALID_REQUIRED,
            diagnostic = "Either ValueSet record or system URL should be provided as input",
            httpStatusCode = http:STATUS_BAD_REQUEST);
    }
    return codesystemConceptsToParameters(result);
}

isolated function prepareRequestSearchParameter(map<string[]> params) returns map<r4:RequestSearchParameter[]> {
    map<r4:RequestSearchParameter[]> searchParams = {};
    foreach var 'key in params.keys() {
        match 'key {
            "_id" => {
                searchParams["_id"] = [createRequestSearchParameter("_id", params.get("_id")[0])];
            }

            "name" => {
                searchParams["name"] = [createRequestSearchParameter("name", params.get("name")[0])];
            }

            "title" => {
                searchParams["title"] = [createRequestSearchParameter("title", params.get("title")[0])];
            }

            "url" => {
                searchParams["url"] = [createRequestSearchParameter("url", params.get("url")[0])];
            }

            "version" => {
                searchParams["version"] = [createRequestSearchParameter("version", params.get("version")[0])];
            }

            "description" => {
                searchParams["description"] = [createRequestSearchParameter("description", params.get("description")[0])];
            }

            "publisher" => {
                searchParams["publisher"] = [createRequestSearchParameter("publisher", params.get("publisher")[0])];
            }

            "status" => {
                r4:RequestSearchParameter[] tempList = [];
                foreach var value in params.get("status") {
                    tempList.push(createRequestSearchParameter("status", value, 'type = r4:REFERENCE));
                }
                searchParams["status"] = tempList;
            }

            "valueSetVersion" => {
                searchParams["valueSetVersion"] = [createRequestSearchParameter("valueSetVersion", params.get("valueSetVersion")[0])];
            }

            "filter" => {
                searchParams["filter"] = [createRequestSearchParameter("filter", params.get("filter")[0])];
            }

            "_count" => {
                searchParams["_count"] = [createRequestSearchParameter("_count", params.get("_count")[0], 'type = r4:NUMBER)];
            }

            "_offset" => {
                searchParams["_offset"] = [createRequestSearchParameter("_offset", params.get("_offset")[0], 'type = r4:NUMBER)];
            }
        }
    }
    return searchParams;
}

isolated function createRequestSearchParameter(string name, string value, r4:FHIRSearchParameterType? 'type = r4:STRING, r4:FHIRSearchParameterModifier? modifier = r4:MODIFIER_EXACT) returns r4:RequestSearchParameter {
    return {name: name, value: value, 'type: r4:STRING, typedValue: {modifier: modifier}};
}
