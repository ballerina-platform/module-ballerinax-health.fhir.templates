import ballerinax/health.fhir.r4;
import ballerinax/mysql;
import ballerina/sql;
import ballerina/http;

// Model represent the database record of CodeSystem table.
public type CodeSystemModel record {|
    string & readonly id;
    string cs_id;
    string url;
    string name;
    string title?;
    string 'version;
    string date?;
    string jurisdiction?;
    string publisher?;
    string status;
    string description?;
    json data;
|};

// Model represent the database record of ValueSet table.
public type ValueSetModel record {|
    string & readonly id;
    string vs_id;
    string url;
    string 'version;
    string name;
    string title?;
    string status;
    string date?;
    string publisher?;
    string jurisdiction?;
    string description?;
    json data;
|};

// Model represent the database record of Concept table.
public type ConceptModel record {|
    string code;
    json data;
    string codesystem_id;
|};

public type Finder readonly & object {

    # To persist the CodeSystem data in the database.
    #
    # + codeSystems - CodeSystem array to be persisted.
    # + return - Error array if any.
    public isolated function addCodeSystems(r4:CodeSystem[] codeSystems) returns r4:FHIRError[]?;

    # The function definition for Concept finder implementations.
    #
    # + system - CodeSystem URL to be searched.
    # + id - Id of the CodeSystem to be searched.
    # + version - Version of the CodeSystem to be searched.
    # + return - CodeSystem if found or else FHIRError.
    public isolated function findCodeSystem(r4:uri? system = (), string? id = (), string? version = ()) returns r4:CodeSystem|r4:FHIRError;

    # The function definition for Concept finder implementations.
    #
    # + params - Search parameters.  
    # + offset - Offset value for the search.  
    # + count - Count value for the search.
    # + return - CodeSystem array if found or else FHIRError.
    public isolated function searchCodeSystem(map<r4:RequestSearchParameter[]> params, int? offset = (), int? count = ()) returns r4:CodeSystem[]|r4:FHIRError;
    # The function definition for add Concepts implementations.
    #
    # + system - System URL of the CodeSystem to be added.  
    # + concepts - Concept array to be added.
    # + 'version - version of the CodeSystem to be added.
    # + return - Error array if any.
    public isolated function addConcepts(r4:uri system, r4:CodeSystemConcept[] concepts, string? 'version = ()) returns r4:FHIRError[]?;

    # The function definition for Concept finder implementations.
    #
    # + system - System URL of the CodeSystem to be searched.
    # + code - Code of the Concept to be searched.
    # + 'version - version of the CodeSystem to be searched.
    # + return - CodeSystemConcept if found or else FHIRError.
    public isolated function findConcept(r4:uri system, r4:code code, string? 'version = ()) returns r4:CodeSystemConcept|r4:FHIRError;

    # The function definition for add ValueSets implementations.
    #
    # + valueSets - ValueSet array to be added.
    # + return - Error array if any.
    public isolated function addValueSets(r4:ValueSet[] valueSets) returns r4:FHIRError[]?;

    # The function definition for ValueSet finder implementations.
    #
    # + system - System URL of the ValueSet to be searched.
    # + id - Id of the ValueSet to be searched.  
    # + 'version - version of the ValueSet to be searched.
    # + return - ValueSet if found or else FHIRError.
    public isolated function findValueSet(r4:uri? system = (), string? id = (), string? 'version = ()) returns r4:ValueSet|r4:FHIRError;

    # Search ValueSets.
    #
    # + params - Search parameters.  
    # + offset - Offset value for the search. 
    # + count - Count value for the search.
    # + return - ValueSet array if found or else FHIRError.
    public isolated function searchValueSet(map<r4:RequestSearchParameter[]> params, int? offset = (), int? count = ()) returns r4:ValueSet[]|r4:FHIRError;
};

final mysql:Client dbClient = check new (
    host = "127.0.0.1", user = "", password = "", port = 3306, database = string `${DB_NAME}`
);

public readonly class FinderImpl {
    *Finder;

    public function init() {

        TABLE_NAME = TABLE_NAME_CODESYSTEM;
        int|sql:Error count = dbClient->queryRow(IS_CODESYSTEM_TABLE_EXIST);
        if count is sql:Error {
            panic count;
        } else if count == 0 {
            sql:ExecutionResult|sql:Error execute = dbClient->execute(QUERY_CREATE_CODESYSTEM_TABLE);
            if execute is sql:Error {
                panic execute;
            }
        }

        TABLE_NAME = TABLE_NAME_CONCEPT;
        count = dbClient->queryRow(IS_VALUESET_TABLE_EXIST);
        if count is sql:Error {
            panic count;
        } else if count == 0 {
            sql:ExecutionResult|sql:Error execute2 = dbClient->execute(QUERY_CREATE_VALUESET_TABLE);
            if execute2 is sql:Error {
                panic execute2;
            }
        }

        TABLE_NAME = TABLE_NAME_VALUESET;
        count = dbClient->queryRow(IS_CONCEPT_TABLE_EXIST);
        if count is sql:Error {
            panic count;
        } else if count == 0 {
            sql:ExecutionResult|sql:Error execute3 = dbClient->execute(QUERY_CREATE_CONCEPT_TABLE);
            if execute3 is sql:Error {
                panic execute3;
            }
        }
    }

    public isolated function addCodeSystems(r4:CodeSystem[] codeSystems) returns r4:FHIRError[]? {
        r4:FHIRError[] errors = [];
        foreach var codeSystem in codeSystems.clone() {
            if codeSystem is r4:CodeSystem {
                sql:ExecutionResult|sql:Error result = dbClient->execute(
                    `INSERT INTO code_system (cs_id, url, version, name, title, status, date, publisher, description, data)
                    VALUES (${codeSystem.id} ,${codeSystem.url}, ${codeSystem.'version}, ${codeSystem.name}, 
                    ${codeSystem.title}, ${codeSystem.status}, ${codeSystem.date ?: ()}, ${codeSystem.publisher ?: ()}, 
                    ${codeSystem.description ?: ()}, ${codeSystem.toJsonString()})`
                    );

                if result is sql:Error {
                    errors.push(r4:createInternalFHIRError(
                        string `Something went wrong!`,
                        r4:ERROR,
                        r4:PROCESSING,
                        cause = result
                    ));
                }
            }
        }

        if errors.length() > 0 {
            return errors.clone();
        }
        return;
    }

    public isolated function addValueSets(r4:ValueSet[] valueSets) returns r4:FHIRError[]? {
        r4:FHIRError[] errors = [];
        foreach var valueSet in valueSets.clone() {
            if valueSet is r4:ValueSet {
                sql:ExecutionResult|sql:Error result = dbClient->execute(
                    `INSERT INTO value_set (vs_id, url, version, name, title, status, publisher, data)
                    VALUES (${valueSet.id}, ${valueSet.url}, ${valueSet.'version}, ${valueSet.name}, ${valueSet.title}, 
                    ${valueSet.status}, ${valueSet.publisher}, ${valueSet.toJsonString()})`
                    );

                if result is sql:Error {
                    errors.push(r4:createInternalFHIRError(
                        string `Something went wrong!`,
                        r4:ERROR,
                        r4:PROCESSING,
                        cause = result
                    ));
                }
            }
        }

        if errors.length() > 0 {
            return errors.clone();
        }
        return;
    }

    public isolated function findConcept(r4:uri system, r4:code code, string? 'version = ()) returns r4:CodeSystemConcept|r4:FHIRError {
        CodeSystemModel codeSystemModel = check self.retrieveCodeSystemModel(system = system, 'version = 'version);

        sql:ParameterizedQuery sqlQuery = `SELECT * from concept WHERE (code = ${code}) AND (codesystem_id = ${codeSystemModel.id})`;

        ConceptModel|sql:Error result = dbClient->queryRow(sqlQuery);
        if result is ConceptModel {
            r4:CodeSystemConcept|error concept = result.data.cloneWithType(r4:CodeSystemConcept);

            if concept is error {
                return r4:createInternalFHIRError(
                        string `Cannot parse the stored Concept data. The data maybe incorrect or currupted.`,
                        r4:ERROR,
                        r4:PROCESSING,
                        cause = concept
                    );
            } else {
                return concept.clone();
            }
        } else {
            if result.message() == "Query did not retrieve any rows." {
                return r4:createFHIRError(
                        string `Cannot find the code: ${code} in the system: ${system}`,
                        r4:ERROR,
                        r4:PROCESSING_NOT_FOUND,
                        httpStatusCode = http:STATUS_NOT_FOUND
                    );
            } else {
                return r4:createInternalFHIRError(
                        string `Something went wrong!`,
                        r4:ERROR,
                        r4:PROCESSING,
                        cause = result
                    );
            }
        }
    }

    public isolated function addConcepts(r4:uri system, r4:CodeSystemConcept[] concepts, string? version) returns r4:FHIRError[]? {
        r4:FHIRError[] errors = [];

        CodeSystemModel|r4:FHIRError codeSystemModel = self.retrieveCodeSystemModel(system = system, version = 'version);

        if codeSystemModel is r4:FHIRError {
            errors.push(codeSystemModel);
        } else {
            foreach var concept in concepts.clone() {
                sql:ExecutionResult|sql:Error result = dbClient->execute(
                    `INSERT INTO concept (code, data, codesystem_id)
                    VALUES (${concept.code}, ${concept.toJsonString()}, ${codeSystemModel.id})`
                    );

                if result is sql:Error {
                    errors.push(r4:createInternalFHIRError(
                        string `Something went wrong!`,
                        r4:ERROR,
                        r4:PROCESSING,
                        cause = result
                    ));
                }
            }
        }

        if errors.length() > 0 {
            return errors.clone();
        }
        return;
    }

    public isolated function findCodeSystem(r4:uri? system = (), string? id = (), string? version = ()) returns r4:CodeSystem|r4:FHIRError {
        CodeSystemModel codeSystemModel = check self.retrieveCodeSystemModel(system = system, id = id, version = 'version);
        r4:CodeSystem|error codeSystem = codeSystemModel.data.cloneWithType(r4:CodeSystem);

        if codeSystem is error {
            return r4:createInternalFHIRError(
                        string `Cannot parse the stored CodeSystem data. The data maybe incorrect or currupted.`,
                        r4:ERROR,
                        r4:PROCESSING,
                        cause = codeSystem
                    );
        }

        return codeSystem;
    }

    public isolated function searchCodeSystem(map<r4:RequestSearchParameter[]> params, int? offset, int? count) returns r4:CodeSystem[]|r4:FHIRError {

        sql:ParameterizedQuery sqlQuery = ``;
        if params.keys().length() > 0 {
            string? id = ();
            string? name = ();
            string? title = ();
            string? url = ();
            string? 'version = ();
            string? status = ();
            string? description = ();
            string? publisher = ();

            foreach var item in params.keys() {
                match (item) {
                    "_id" => {
                        id = (<r4:RequestSearchParameter[]>params[item])[0].value;
                    }

                    "name" => {
                        name = (<r4:RequestSearchParameter[]>params[item])[0].value;
                    }

                    "title" => {
                        title = (<r4:RequestSearchParameter[]>params[item])[0].value;
                    }

                    "url" => {
                        url = (<r4:RequestSearchParameter[]>params[item])[0].value;
                    }

                    "version" => {
                        foreach var p in (<r4:RequestSearchParameter[]>params[item]) {
                            'version = string `${'version ?: ""},${p.value}`;
                        }
                    }

                    "status" => {
                        foreach var p in (<r4:RequestSearchParameter[]>params[item]) {
                            status = string `${status ?: ""},${p.value}`;
                        }
                    }

                    "description" => {
                        // MySQL like operation will be executed with this value.
                        description = string `%${(<r4:RequestSearchParameter[]>params[item])[0].value.trim().toLowerAscii()}%`;
                    }

                    "publisher" => {
                        // MySQL like operation will be executed with this value.
                        publisher = string `%${(<r4:RequestSearchParameter[]>params[item])[0].value.trim().toLowerAscii()}%`;
                    }
                }
            }

            sqlQuery = `SELECT * from code_system 
                    WHERE (${id} IS NULL OR cs_id = ${id}) AND (${url} IS NULL OR url = ${url}) 
                    AND (${name} IS NULL OR name = ${name}) AND (${title} IS NULL OR title = ${title}) 
                    AND (${publisher} IS NULL OR publisher LIKE ${publisher}) 
                    AND (${'version} IS NULL OR version IN (${'version})) 
                    AND (${status} IS NULL OR  status IN (${status}))
                    AND (${description} IS NULL OR description LIKE ${description})
                    ORDER BY cs_id LIMIT ${offset}, ${count}`;
        } else {
            sqlQuery = `SELECT * from code_system ORDER BY cs_id LIMIT ${offset}, ${count}`;
        }

        CodeSystemModel[] models = check self.retrieveCodeSystemModels(sqlQuery);

        r4:CodeSystem[] codeSystems = [];
        foreach var item in models {
            r4:CodeSystem|error cs = item.data.cloneWithType(r4:CodeSystem);
            if cs is r4:CodeSystem {
                codeSystems.push(cs);
            }
        }

        return codeSystems;
    }

    isolated function retrieveCodeSystemModel(r4:uri? system = (), string? id = (), string? version = ()) returns CodeSystemModel|r4:FHIRError {
        sql:ParameterizedQuery sqlQuery = `SELECT * from code_system 
                                                WHERE (cs_id = ${id}) OR (url = ${system})`;

        stream<CodeSystemModel, sql:Error?> results = dbClient->query(sqlQuery);

        CodeSystemModel[] models = [];
        sql:Error? unionResult = from CodeSystemModel model in results
            do {
                models.push(model);
            };

        sql:Error? close = results.close();
        if close is sql:Error {
        }

        if unionResult is sql:NoRowsError {
            return r4:createFHIRError(
                    string `Unknown CodeSystem: '${id ?: <string>system}'`,
                    r4:ERROR,
                    r4:PROCESSING_NOT_FOUND,
                    httpStatusCode = http:STATUS_NOT_FOUND
                    );
        } else if unionResult is sql:Error {
            return r4:createInternalFHIRError(
                        string `Something went wrong!`,
                        r4:ERROR,
                        r4:PROCESSING,
                        cause = unionResult
                    );
        }

        if models.length() < 0 {
            return r4:createFHIRError(
                    string `Unknown CodeSystem: '${id ?: <string>system}'`,
                    r4:ERROR,
                    r4:PROCESSING_NOT_FOUND,
                    httpStatusCode = http:STATUS_NOT_FOUND
                    );
        }

        CodeSystemModel? response = ();
        if 'version is string {
            foreach var item in models {
                if item.'version == 'version {
                    response = item;
                }
            }
        } else {
            string latestVersion = "0.0.0";

            foreach var item in models {
                if item.'version > latestVersion {
                    latestVersion = item.'version;
                    response = item;
                }
            }
        }

        if response is CodeSystemModel {
            return response.clone();
        } else {
            return r4:createFHIRError(
                        string `Unknown version: '${'version.toString()}'`,
                        r4:ERROR,
                        r4:PROCESSING_NOT_FOUND,
                        diagnostic = string
                        `There is a CodeSystem in the registry : '${id ?: <string>system}' but can not find version: '${'version.toString()}' of it`,
                        httpStatusCode = http:STATUS_NOT_FOUND
                        );
        }
    }

    isolated function retrieveCodeSystemModels(sql:ParameterizedQuery sqlQuery) returns CodeSystemModel[]|r4:FHIRError {

        stream<CodeSystemModel, sql:Error?> results = dbClient->query(sqlQuery);

        CodeSystemModel[] models = [];
        sql:Error? unionResult = from CodeSystemModel model in results
            do {
                models.push(model);
            };

        sql:Error? close = results.close();
        if close is sql:Error {
        }

        if unionResult is sql:NoRowsError {
            return r4:createFHIRError(
                    string `Cannot find any CodeSystems`,
                    r4:ERROR,
                    r4:PROCESSING_NOT_FOUND,
                    httpStatusCode = http:STATUS_NOT_FOUND
                    );
        } else if unionResult is sql:Error {
            return r4:createInternalFHIRError(
                        string `Something went wrong!`,
                        r4:ERROR,
                        r4:PROCESSING,
                        cause = unionResult
                    );
        }

        return models.clone();

    }

    public isolated function findValueSet(r4:uri? system = (), string? id = (), string? 'version = ()) returns r4:ValueSet|r4:FHIRError {
        ValueSetModel valueSetModel = check self.retrieveValueSetModel(url = system, id = id, version = 'version);
        r4:ValueSet|error valueSet = valueSetModel.data.cloneWithType(r4:ValueSet);

        if valueSet is error {
            return r4:createInternalFHIRError(
                        string `Cannot parse the stored ValueSet data. The data maybe incorrect or currupted.`,
                        r4:ERROR,
                        r4:PROCESSING,
                        cause = valueSet
                    );
        }

        return valueSet;
    }

    public isolated function searchValueSet(map<r4:RequestSearchParameter[]> params, int? offset = (), int? count = ()) returns r4:ValueSet[]|r4:FHIRError {

        sql:ParameterizedQuery sqlQuery = ``;
        if params.keys().length() > 0 {
            string? id = ();
            string? name = ();
            string? title = ();
            string? url = ();
            string? 'version = ();
            string? status = ();
            string? description = ();
            string? publisher = ();

            foreach var item in params.keys() {
                match (item) {
                    "_id" => {
                        id = (<r4:RequestSearchParameter[]>params[item])[0].value.trim();
                    }

                    "name" => {
                        name = (<r4:RequestSearchParameter[]>params[item])[0].value.trim();
                    }

                    "title" => {
                        title = (<r4:RequestSearchParameter[]>params[item])[0].value.trim();
                    }

                    "url" => {
                        url = (<r4:RequestSearchParameter[]>params[item])[0].value.trim();
                    }

                    "version" => {
                        foreach var p in (<r4:RequestSearchParameter[]>params[item]) {
                            'version = string `${'version ?: ""},${p.value.trim()}`;
                        }
                        'version = (<string>'version).substring(1);
                    }

                    "status" => {
                        foreach var p in (<r4:RequestSearchParameter[]>params[item]) {
                            status = string `${status ?: ""},${p.value.trim()}`;
                        }
                        status = (<string>status).substring(1);
                    }

                    "description" => {
                        // MySQL like operation will be executed with this value.
                        description = string `%${(<r4:RequestSearchParameter[]>params[item])[0].value.trim().toLowerAscii()}%`;
                    }

                    "publisher" => {
                        // MySQL like operation will be executed with this value.
                        publisher = string `%${(<r4:RequestSearchParameter[]>params[item])[0].value.trim().toLowerAscii()}%`;
                    }
                }
            }

            sqlQuery = `SELECT * from value_set 
                    WHERE (${id} IS NULL OR vs_id = ${id}) AND (${url} IS NULL OR url = ${url}) AND (${name} IS NULL OR name = ${name}) 
                    AND (${title} IS NULL OR title = ${title}) AND (${publisher} IS NULL OR publisher LIKE ${publisher}) 
                    AND (${'version} is NUll OR FIND_IN_SET(version, ${'version}))
                    AND (${status} is NUll OR FIND_IN_SET(status, ${status}))
                    AND (${description} IS NULL OR description LIKE ${description})
                    ORDER BY vs_id LIMIT ${offset}, ${count}`;
        } else {
            sqlQuery = `SELECT * from value_set ORDER BY vs_id LIMIT ${offset}, ${count}`;
        }

        ValueSetModel[] models = check self.retrieveValueSetModels(sqlQuery);

        r4:ValueSet[] valueSets = [];
        foreach var item in models {
            r4:ValueSet|error vs = item.data.cloneWithType(r4:ValueSet);
            if vs is r4:ValueSet {
                valueSets.push(vs);
            }
        }

        return valueSets;
    }

    public isolated function retrieveValueSetModel(r4:uri? url = (), string? id = (), string? 'version = ()) returns r4:FHIRError|ValueSetModel {
        sql:ParameterizedQuery sqlQuery = `SELECT * from value_set WHERE (${id} IS NULL OR vs_id = ${id}) 
                                                AND (${url} IS NULL OR url = ${url})`;

        stream<ValueSetModel, sql:Error?> results = dbClient->query(sqlQuery);

        ValueSetModel[] models = [];
        sql:Error? unionResult = from ValueSetModel model in results
            do {
                models.push(model);
            };

        sql:Error? close = results.close();
        if close is sql:Error {
        }

        if unionResult is sql:NoRowsError {
            return r4:createFHIRError(
                    string `Unknown ValueSet: '${id ?: <string>url}'`,
                    r4:ERROR,
                    r4:PROCESSING_NOT_FOUND,
                    httpStatusCode = http:STATUS_NOT_FOUND
                    );
        } else if unionResult is sql:Error {
            return r4:createInternalFHIRError(
                        string `Something went wrong!`,
                        r4:ERROR,
                        r4:PROCESSING,
                        cause = unionResult
                    );
        }

        if models.length() < 0 {
            return r4:createFHIRError(
                    string `Unknown ValueSet: '${id ?: <string>url}'`,
                    r4:ERROR,
                    r4:PROCESSING_NOT_FOUND,
                    httpStatusCode = http:STATUS_NOT_FOUND
                    );
        }

        ValueSetModel? response = ();
        if 'version is string {
            foreach var item in models {
                if item.'version == 'version {
                    response = item;
                }
            }
        } else {
            string latestVersion = "0.0.0";

            foreach var item in models {
                if item.'version > latestVersion {
                    latestVersion = item.'version;
                    response = item;
                }
            }
        }

        if response is ValueSetModel {
            return response.clone();
        } else {
            return r4:createFHIRError(
                        string `Unknown version: '${'version.toString()}'`,
                        r4:ERROR,
                        r4:PROCESSING_NOT_FOUND,
                        diagnostic = string
                        `There is a ValueSet in the registry : '${id ?: <string>url}' but can not find version: '${'version.toString()}' of it`,
                        httpStatusCode = http:STATUS_NOT_FOUND
                        );
        }
    }

    isolated function retrieveValueSetModels(sql:ParameterizedQuery sqlQuery) returns ValueSetModel[]|r4:FHIRError {
        stream<ValueSetModel, sql:Error?> results = dbClient->query(sqlQuery);

        ValueSetModel[] models = [];
        sql:Error? unionResult = from ValueSetModel model in results
            do {
                models.push(model);
            };

        sql:Error? close = results.close();
        if close is sql:Error {
        }

        if unionResult is sql:NoRowsError {
            return r4:createFHIRError(
                    string `Cannot find any ValueSets`,
                    r4:ERROR,
                    r4:PROCESSING_NOT_FOUND,
                    httpStatusCode = http:STATUS_NOT_FOUND
                    );
        } else if unionResult is sql:Error {
            return r4:createInternalFHIRError(
                        string `Something went wrong!`,
                        r4:ERROR,
                        r4:PROCESSING,
                        cause = unionResult
                    );
        }

        return models.clone();
    }

    public isolated function retrieve(string id) returns ValueSetModel|r4:FHIRError {
        ValueSetModel|sql:Error results = dbClient->queryRow(
            `SELECT * from value_set WHERE (vs_id = ${id})`
        );

        if results is ValueSetModel {
            return results.clone();
        } else {
            return r4:createFHIRError(
                        string `Cannot find any ValueSets`,
                        r4:ERROR,
                        r4:PROCESSING_NOT_FOUND,
                        httpStatusCode = http:STATUS_NOT_FOUND
                        );
        }
    }
}
