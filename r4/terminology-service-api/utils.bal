import ballerina/mime;
import ballerina/io;
import ballerinacentral/zip;
import ballerina/file;
import ballerinax/health.fhir.r4;
import ballerina/http;
import ballerina/log;

isolated function extractFilesFromZip(mime:Entity bodyPart) returns r4:FHIRError? {
    byte[]|mime:ParserError data = bodyPart.getByteArray();
    if data is mime:ParserError {
        return r4:createFHIRError(
            "Error occurred while parsing the request body",
            r4:ERROR,
            r4:INVALID,
            cause = data,
            httpStatusCode = http:STATUS_BAD_REQUEST
            );
    }

    io:Error? fileWriteBytes = io:fileWriteBytes("./temp.zip", data);
    if fileWriteBytes is io:Error {
        return r4:createFHIRError(
            "Error occurred while writing the zip file",
            r4:ERROR,
            r4:INVALID,
            diagnostic = "Please contact the administrator",
            cause = fileWriteBytes,
            httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR
            );
    }

    error? extract = zip:extract("./temp.zip", "./extracted");
    if extract is error {
        return r4:createFHIRError(
            "Error occurred while extracting the zip file",
            r4:ERROR,
            r4:INVALID,
            diagnostic = "Please contact the administrator",
            cause = extract,
            httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR
            );
    }

    file:Error? remove = file:remove("./temp.zip");
    if remove is file:Error {
        log:printError(r4:createFHIRError(
            "Error occurred while removing the zip file",
            r4:ERROR,
            r4:INVALID,
            diagnostic = "Please contact the administrator",
            cause = remove,
            httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR
            ).toBalString());
    }
}

isolated function extractJsonFile(mime:Entity bodyPart) returns json|r4:FHIRError {
    byte[]|mime:ParserError data = bodyPart.getByteArray();
    if data is mime:ParserError {
        return r4:createFHIRError(
            "Error occurred while parsing the request body",
            r4:ERROR,
            r4:INVALID,
            cause = data,
            httpStatusCode = http:STATUS_BAD_REQUEST
            );
    }

    io:Error? fileWriteBytes = io:fileWriteBytes("./temp.json", data);
    if fileWriteBytes is io:Error {
        return r4:createFHIRError(
            "Error occurred while writing the json file",
            r4:ERROR,
            r4:INVALID,
            diagnostic = "Please contact the administrator",
            cause = fileWriteBytes,
            httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR
            );
    }

    json|io:Error jsonContent = io:fileReadJson("./temp.json");
    if jsonContent is io:Error {
        return r4:createFHIRError(
            "Error occurred while reading the json file",
            r4:ERROR,
            r4:INVALID,
            diagnostic = "Please contact the administrator",
            cause = jsonContent,
            httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR
            );
    }

    file:Error? remove = file:remove("./temp.zip");
    if remove is file:Error {
        log:printError(r4:createFHIRError(
            "Error occurred while removing the json file",
            r4:ERROR,
            r4:INVALID,
            diagnostic = "Please contact the administrator",
            cause = remove,
            httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR
            ).toBalString());
    }

    return jsonContent;
}

// Recuersively read all the files in the given directory
isolated function readFiles(string path) returns json[]|error {
    file:MetaData[] readDir = check file:readDir(path);
    json[] files = [];
    foreach var item in readDir {
        if item.dir {
            files.push(...check readFiles(item.absPath));
        } else {
            json|io:Error jsonContent = io:fileReadJson(item.absPath);
            if jsonContent is json {
                files.push(jsonContent);
            }
        }
    }

    return files;
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
                r4:RequestSearchParameter[] tempList = [];
                foreach var value in params.get("version") {
                    tempList.push(createRequestSearchParameter("version", value, 'type = r4:STRING));
                }
                searchParams["version"] = tempList;
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

isolated function codeSystemConceptPropertyToParameter(r4:CodeSystemConceptProperty property) returns r4:ParametersParameter {
    r4:ParametersParameter param = {name: "property"};
    r4:ParametersParameter[] part = [];

    if property.valueString is string {
        part.push(
            {name: "code", valueCode: property.code},
            {name: "value", valueString: property.valueString}
        );
    }

    if property.valueCoding is r4:Coding {
        part.push(
            {name: "code", valueCode: property.code},
            {name: "value", valueCoding: property.valueCoding}
        );
    }
    param.part = part;

    return param;
}

isolated function codesystemConceptsToParameters(r4:CodeSystemConcept[]|r4:CodeSystemConcept concepts) returns r4:Parameters {
    r4:Parameters parameters = {};
    if concepts is r4:CodeSystemConcept {
        parameters = {
            'parameter: [
                {name: "name", valueString: concepts.code},
                {name: "display", valueString: concepts.display}
            ]
        };

        if concepts.definition is string {
            (<r4:ParametersParameter[]>parameters.'parameter).push({name: "definition", valueString: concepts.definition});
        }

        if concepts.property is r4:CodeSystemConceptProperty[] {
            foreach var item in <r4:CodeSystemConceptProperty[]>concepts.property {
                r4:ParametersParameter result = codeSystemConceptPropertyToParameter(item);
                (<r4:ParametersParameter[]>parameters.'parameter).push(result);
            }
        }

        if concepts.designation is r4:CodeSystemConceptDesignation[] {
            foreach var item in <r4:CodeSystemConceptDesignation[]>concepts.designation {
                r4:ParametersParameter result = designationToParameter(item);
                (<r4:ParametersParameter[]>parameters.'parameter).push(result);
            }
        }
    } else {
        r4:ParametersParameter[] p = [];
        foreach r4:CodeSystemConcept item in concepts {
            p.push({name: "name", valueString: item.code},
                    {name: "display", valueString: item.display});

            if item.definition is string {
                p.push({name: "definition", valueString: item.definition});
            }

            if item.property is r4:CodeSystemConceptProperty[] {
                foreach var prop in <r4:CodeSystemConceptProperty[]>item.property {
                    r4:ParametersParameter result = codeSystemConceptPropertyToParameter(prop);
                    p.push(result);
                }
            }

            if item.designation is r4:CodeSystemConceptDesignation[] {
                foreach var desg in <r4:CodeSystemConceptDesignation[]>item.designation {
                    r4:ParametersParameter result = designationToParameter(desg);
                    (<r4:ParametersParameter[]>parameters.'parameter).push(result);
                }
            }
        }
        parameters = {'parameter: p};
    }
    return parameters;
}

isolated function designationToParameter(r4:CodeSystemConceptDesignation designation) returns r4:ParametersParameter {
    r4:ParametersParameter param = {name: "designation"};
    r4:ParametersParameter[] part = [];

    if designation.language is string {
        part.push({name: "language", valueCode: designation.language});
    }

    if designation.value is string {
        part.push({name: "value", valueString: designation.value});
    }

    if designation.use is r4:Coding {
        part.push({name: "use", valueCoding: designation.use});
    }
    param.part = part;

    return param;
}
