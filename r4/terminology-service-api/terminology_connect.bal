import ballerinax/health.fhir.r4.terminology;
import ballerinax/health.fhir.r4;
import ballerina/regex;
import ballerina/http;
import ballerina/mime;
import ballerina/time;
import ballerina/file;
import ballerina/log;

isolated FinderImpl? finder = ();

function init() returns error? {
    lock {
        if IS_DB_CONNECTED {
            finder = new;
            terminology:setFinder(<Finder>finder);
        }
    }
}

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

public isolated function codeSystemLookUpGet(http:RequestContext ctx, http:Request request, string? id = ()) returns r4:Parameters|r4:FHIRError {

    string? system = request.getQueryParamValue("system");
    string? codeValue = request.getQueryParamValue("code");

    r4:CodeSystemConcept[]|r4:CodeSystemConcept result;
    if id is string {
        result = check terminology:codeSystemLookUp(<r4:code>codeValue, system = (check readCodeSystemById(id)).url);
    } else if system is string {
        result = check terminology:codeSystemLookUp(<r4:code>codeValue, system = system);
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
        result = check terminology:codeSystemLookUp(codingValue, system = system, version = codingValue.version);
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

                    "codeableConcept" => {
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

    if valueSet is r4:ValueSet && (codingValue is r4:Coding || codingValue is r4:CodeableConcept) {
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

public isolated function subsumesGet(http:RequestContext ctx, http:Request request) returns r4:Parameters|r4:FHIRError {

    string? 'version = request.getQueryParamValue("version");
    r4:uri? system = request.getQueryParamValue("system");
    r4:code? codeA = request.getQueryParamValue("codeA");
    r4:code? codeB = request.getQueryParamValue("codeB");

    if system is string && codeA is r4:code && codeB is r4:code {
        return terminology:subsumes(codeA, codeB, system = system, version = 'version);
    } else {
        return r4:createFHIRError(
            "Missing required input parameters",
            r4:ERROR,
            r4:INVALID_REQUIRED,
            diagnostic = "The request should conain 2 code concepts and CodeSystem system URL",
            httpStatusCode = http:STATUS_BAD_REQUEST);
    }
}

public isolated function subsumesPost(http:RequestContext ctx, http:Request request) returns r4:Parameters|r4:FHIRError {
    string? 'version = ();
    r4:uri? system = ();
    r4:Coding? codingA = ();
    r4:Coding? codingB = ();

    json|http:ClientError jsonPayload = request.getJsonPayload();
    if jsonPayload is json {
        r4:Parameters|error parameters = jsonPayload.cloneWithType(r4:Parameters);
        if parameters is r4:Parameters && parameters.'parameter is r4:ParametersParameter[] {

            foreach var item in <r4:ParametersParameter[]>parameters.'parameter {
                match item.name {
                    "codingA" => {
                        codingA = item.valueCoding ?: {};
                    }

                    "codingB" => {
                        codingB = item.valueCoding ?: {};
                    }

                    "version" => {
                        'version = item.valueString ?: ();
                    }

                    "system" => {
                        system = item.valueUri ?: ();
                    }
                }
            }
        }
    } else {
        return r4:createFHIRError(
            "Empty request payload or invalid json format",
            r4:ERROR,
            r4:INVALID_REQUIRED,
            diagnostic = "Payload should contains ValueSet record and Coding data",
            httpStatusCode = http:STATUS_BAD_REQUEST);
    }

    if system is string && codingA is r4:Coding && codingB is r4:Coding {
        return terminology:subsumes(codingA, codingB, system = system, version = 'version);
    } else {
        return r4:createFHIRError(
            "Missing required input parameters",
            r4:ERROR,
            r4:INVALID_REQUIRED,
            diagnostic = "The request should conain 2 coding concepts and CodeSystem system URL",
            httpStatusCode = http:STATUS_BAD_REQUEST);
    }
}

public isolated function create(http:Request request) returns error|r4:FHIRError? {

    string typeHeader = "FHIR";

    if request.hasHeader(TYPE_HEADER) {
        string|http:HeaderNotFoundError header = request.getHeader(TYPE_HEADER);

        if header is string && header.trim() != "" {
            typeHeader = header;
        } else {
            return r4:createFHIRError(
            string `Value for the ${TYPE_HEADER} is empty`,
            r4:ERROR,
            r4:INVALID_REQUIRED,
            diagnostic = string `Supported values are: FHIR, LOINC and SNOMED`,
            httpStatusCode = http:STATUS_BAD_REQUEST);
        }

        if !(typeHeader == "FHIR" || typeHeader == "LOINC" || typeHeader == "SNOMED") {
            return r4:createFHIRError(
            string `Unsupported terminology type: ${typeHeader}`,
            r4:ERROR,
            r4:INVALID_REQUIRED,
            diagnostic = string `Supported values are: FHIR, LOINC and SNOMED`,
            httpStatusCode = http:STATUS_BAD_REQUEST);
        }
    } else {
        return r4:createFHIRError(
            string `Missing ${TYPE_HEADER} header in the request`,
            r4:ERROR,
            r4:INVALID_REQUIRED,
            diagnostic = string `The request should contains ${TYPE_HEADER} header and supported values are: FHIR, LOINC and SNOMED`,
            httpStatusCode = http:STATUS_BAD_REQUEST);
    }

    mime:Entity[]|http:ClientError bodyParts = request.getBodyParts();
    if bodyParts is mime:Entity[] {
        foreach var part in bodyParts {
            if part.getContentType() == "application/zip" {
                _ = check extractFilesFromZip(part);

                string? system = ();
                string? version = ();
                string codesystemPath = string `./extracted/${typeHeader.toLowerAscii()}/codesystems`;
                if check file:test(codesystemPath, file:EXISTS) {
                    json[] codesystemJson = check readFiles(codesystemPath);
                    r4:CodeSystem|error cs = codesystemJson[0].cloneWithType(r4:CodeSystem);
                    if cs is error {
                        return r4:createFHIRError(
                        string `CodeSystem data is not valid`,
                        r4:ERROR,
                        r4:INVALID_REQUIRED,
                        cause = cs,
                        httpStatusCode = http:STATUS_BAD_REQUEST);
                    }
                    r4:FHIRError? result = terminology:addCodeSystem(cs);

                    if result is r4:FHIRError {
                        return result;
                    }

                    system = cs.url is r4:uri ? <string>cs.url : "";
                    'version = cs.version is string ? <string>cs.'version : "";
                } else {
                    log:printError(r4:createFHIRError(
                        string `Cannot find CodeSystem data in the zip file`,
                        r4:ERROR,
                        r4:INVALID_REQUIRED,
                        httpStatusCode = http:STATUS_BAD_REQUEST).toBalString());
                }

                string codePath = string `./extracted/${typeHeader.toLowerAscii()}/codes`;
                if system is string && check file:test(codePath, file:EXISTS) {
                    json[] codes = check readFiles(codePath);

                    r4:CodeSystemConcept[] concepts = [];
                    foreach var item in codes {
                        r4:CodeSystemConcept|error concept = item.cloneWithType(r4:CodeSystemConcept);
                        if concept is r4:CodeSystemConcept {
                            concepts.push(concept);
                        } else {
                            log:printError(r4:createFHIRError(
                            string `Code data is not valid`,
                            r4:ERROR,
                            r4:INVALID_REQUIRED,
                            cause = concept is error ? concept : (),
                            httpStatusCode = http:STATUS_BAD_REQUEST).toBalString());
                        }
                    }

                    lock {
                        if finder is FinderImpl {
                            r4:FHIRError[]? _ = (<Finder>finder).addConcepts(system, concepts.clone(), version);
                        }
                    }
                } else {
                    log:printError(r4:createFHIRError(
                        string `Cannot find CodeSystem data in the zip file`,
                        r4:ERROR,
                        r4:INVALID_REQUIRED,
                        httpStatusCode = http:STATUS_BAD_REQUEST).toBalString());
                }

                string valueSetPath = string `./extracted/${typeHeader.toLowerAscii()}/valuesets`;
                if check file:test(valueSetPath, file:EXISTS) {
                    json[] valueSets = check readFiles(valueSetPath);
                    _ = terminology:addValueSetsAsJson(valueSets);
                }
                log:printError(r4:createFHIRError(
                        string `Cannot find ValueSet data in the zip file`,
                        r4:ERROR,
                        r4:INVALID_REQUIRED,
                        httpStatusCode = http:STATUS_BAD_REQUEST).toBalString());

                file:Error? remove = file:remove("./extracted", file:RECURSIVE);
                if remove is file:Error {
                    log:printError(r4:createFHIRError(
                        string `Cannot remove extracted files`,
                        r4:ERROR,
                        r4:INVALID_REQUIRED,
                        cause = remove,
                        httpStatusCode = http:STATUS_BAD_REQUEST).toBalString());
                }
            } else if part.getContentType() == "application/json" {
                json[] content = check readFiles(string `./extracted/${typeHeader}/codes`);
                r4:CodeSystem|error cloned1 = content[0].cloneWithType(r4:CodeSystem);

                if cloned1 is r4:CodeSystem {
                    return terminology:addCodeSystem(cloned1);
                } else {
                    r4:ValueSet|error cloned2 = content.cloneWithType(r4:ValueSet);

                    if cloned2 is r4:ValueSet {
                        return terminology:addValueSet(cloned2);
                    } else {
                        return r4:createFHIRError(
                    string `Unsupported content`,
                    r4:ERROR,
                    r4:INVALID_REQUIRED,
                    diagnostic = string `Supported types are: CodeSystem, ValueSet"`,
                    httpStatusCode = http:STATUS_BAD_REQUEST);
                    }
                }
            } else {
                return r4:createFHIRError(
                    string `Unsupported content type: ${part.getContentType()}`,
                    r4:ERROR,
                    r4:INVALID_REQUIRED,
                    diagnostic = string `Supported types are: application/zip and "application/json"`,
                    httpStatusCode = http:STATUS_BAD_REQUEST);
            }
        }
    } else {
        return r4:createFHIRError(
            string `Empty request payload`,
            r4:ERROR,
            r4:INVALID_REQUIRED,
            diagnostic = string `Payload should contains a zip file or a json object`,
            httpStatusCode = http:STATUS_BAD_REQUEST);
    }
}
