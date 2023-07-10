import ballerinax/health.fhir.r4.terminology;
import ballerinax/health.fhir.r4.parser;
import ballerinax/health.fhir.r4;
import ballerina/regex;
import ballerina/http;
import ballerina/time;

type CodeSystenSubsumeRequest record {
    r4:Coding codingA;
    r4:Coding codingB;
    r4:uri? system;
    string? version;
};

type Parameter record {
    string name;
    string? value;
    anydata? 'resource = ();
};

type Parameters record {
    Parameter[] 'parameter;
};

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
    r4:BundleEntry[] entries = valueSets.'map(v=><r4:BundleEntry>{'resource: v, search: {mode: r4:MATCH}});

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
    r4:BundleEntry[] entries = codeSystems.'map(c=><r4:BundleEntry>{'resource: c, search: {mode: r4:MATCH}});

    return {
        'type: r4:BUNDLE_TYPE_SEARCHSET,
        meta: {
            lastUpdated: time:utcToString(time:utcNow())
        },
        total: entries.length(),
        entry: entries
        };
}

public isolated function valueSetExpansion(http:Request request, string? id = ()) returns r4:ValueSet|r4:FHIRError {

    map<r4:RequestSearchParameter[]> searchParameters = {};
    if id is string {
        return terminology:valueSetExpansion(searchParameters, vs = check readValueSetById(id));
    } else {
        json|http:ClientError jsonPayload = request.getJsonPayload();

        if jsonPayload is json {
            r4:ValueSet|error v = parser:parse(jsonPayload, r4:ValueSet).ensureType();
            if v is r4:ValueSet {
                return terminology:valueSetExpansion(searchParameters, vs = v);
            }
        } else {
            string[]? queryParamValues = request.getQueryParamValues("url");
            string|() system = ();
            if queryParamValues is string[] {
                system = queryParamValues[0];
            }
            return terminology:valueSetExpansion(searchParameters, system = system);
        }
    }

    return r4:createFHIRError(
            "Can not find a ValueSet",
            r4:ERROR,
            r4:INVALID_REQUIRED,
            diagnostic = "Either ValueSet record or system URL should be provided as input",
            httpStatusCode = http:STATUS_BAD_REQUEST);
}

public isolated function valueSetValidateCode(http:Request request, string? id = ()) returns Parameters|r4:FHIRError {

    r4:CodeSystemConcept[]|r4:CodeSystemConcept concept = check valueSetLookUp(request, id);

    if concept is r4:CodeSystemConcept {
        return <Parameters>{
            'parameter: [
                {name: "result", value: "true"},
                {name: "display", value: concept.display},
                {name: "definition", value: concept.definition}
            ]
        };
    } else if concept.length() > 0 {
        Parameter[] params = [];
        foreach var c in concept {
            params.push({name: "result", value: "true"});
            params.push({name: "display", value: c.display});
            params.push({name: "definition", value: c.definition});
        }
        return {
            'parameter: params
        };
    } else {
        return {
            'parameter: [{name: "result", value: "false"}]
        };
    }
}

public isolated function codeSystemLookUp(http:RequestContext ctx, http:Request request, string? id = ()) returns r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError {
    r4:code|r4:Coding codeValue = "";

    string? system = request.getQueryParamValue("system");
    string? code = request.getQueryParamValue("code");

    json|http:ClientError jsonPayload = request.getJsonPayload();
    if jsonPayload is json {
        r4:Coding|error parse = parser:parse(jsonPayload, r4:Coding).ensureType();
        if parse is r4:Coding {
            codeValue = parse;
        } else {
            return r4:createFHIRError(
            "Invalide Coding value",
            r4:ERROR,
            r4:INVALID_REQUIRED,
            cause = parse,
            httpStatusCode = http:STATUS_BAD_REQUEST);
        }
    }

    if codeValue is "" && code is string {
        codeValue = code;
    }

    if id is string {
        return terminology:codeSystemLookUp(codeValue, cs = check readCodeSystemById(id));
    } else if system is string {
        return terminology:codeSystemLookUp(codeValue, cs = check readCodeSystemByUrl(system));
    } else {
        return r4:createFHIRError(
            "Can not find a CodeSystem",
            r4:ERROR,
            r4:INVALID_REQUIRED,
            diagnostic = "Either CodeSystem record or system URL should be provided as input",
            httpStatusCode = http:STATUS_BAD_REQUEST);
    }
}

public isolated function valueSetLookUp(http:Request request, string? id = ()) returns r4:CodeSystemConcept[]|r4:CodeSystemConcept|r4:FHIRError {
    r4:code|r4:Coding codeValue = "";

    string? system = request.getQueryParamValue("system");
    string? code = request.getQueryParamValue("code");

    json|http:ClientError jsonPayload = request.getJsonPayload();
    if jsonPayload is json {
        r4:Coding|error parse = parser:parse(jsonPayload, r4:Coding).ensureType();
        if parse is r4:Coding {
            codeValue = parse;
        } else {
            return r4:createFHIRError(
            "Invalide Coding value",
            r4:ERROR,
            r4:INVALID_REQUIRED,
            cause = parse,
            httpStatusCode = http:STATUS_BAD_REQUEST);
        }
    }

    if codeValue is "" && code is string {
        codeValue = code;
    }

    if id is string {
        return terminology:valueSetLookUp(codeValue, vs = check readValueSetById(id));
    } else if system is string {
        return terminology:valueSetLookUp(codeValue, vs = check readValueSetByUrl(system));
    } else {
        return r4:createFHIRError(
            "Can not find a CodeSystem",
            r4:ERROR,
            r4:INVALID_REQUIRED,
            diagnostic = "Either ValueSet record or system URL should be provided as input",
            httpStatusCode = http:STATUS_BAD_REQUEST);
    }
}

public isolated function subsumes(http:RequestContext ctx, http:Request request) returns string|r4:FHIRError {

    string? 'version = request.getQueryParamValue("version");
    r4:uri? system = request.getQueryParamValue("system");
    r4:code? codeA = request.getQueryParamValue("codeA");
    r4:code? codeB = request.getQueryParamValue("codeB");

    json|http:ClientError jsonPayload = request.getJsonPayload();
    if jsonPayload is json {
        CodeSystenSubsumeRequest|error parsedPayload = jsonPayload.cloneWithType(CodeSystenSubsumeRequest);

        if parsedPayload is CodeSystenSubsumeRequest {
            r4:Coding codingA = parsedPayload.codingA;
            r4:Coding codingB = parsedPayload.codingB;
            'version = parsedPayload.version ?: request.getQueryParamValue("version") ?: 'version;
            system = parsedPayload.system ?: request.getQueryParamValue("system") ?: system;

            return terminology:subsumes(codingA, codingB, system = system, version = 'version);

        } else {
            return r4:createFHIRError(
            "Invalide payload",
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
    return {name: name, value: value, 'type: r4:STRING, typedValue: {name: name, modifier: modifier}};
}
