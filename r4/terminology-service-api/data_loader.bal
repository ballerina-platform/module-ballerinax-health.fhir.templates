import ballerinax/health.fhir.r4.terminology;
import ballerina/file;
import ballerina/io;

function init() returns error? {
    file:MetaData[] rootCodeSystem = check file:readDir("resources/code-systems");
    foreach var item in rootCodeSystem {
        if item.dir {
            file:MetaData[] listResult = check file:readDir(item.absPath);
            json[] jsonArray = [];
            foreach var path in listResult {
                json|io:Error jsonContent = io:fileReadJson(path.absPath);
                if jsonContent is json {
                    jsonArray.push(jsonContent);
                }
            }
            _ = terminology:addCodeSystemsAsJson(jsonArray);
        } else {
            json|io:Error jsonContent = io:fileReadJson(item.absPath);
            if jsonContent is json {
                _ = terminology:addCodeSystemsAsJson([jsonContent]);
            }
        }
    }

    file:MetaData[] rootValueSet = check file:readDir("resources/value-sets");
    foreach var item in rootValueSet {
        if item.dir {
            file:MetaData[] listResult = check file:readDir(item.absPath);
            json[] jsonArray = [];
            foreach var path in listResult {
                json|io:Error jsonContent = io:fileReadJson(path.absPath);
                if jsonContent is json {
                    jsonArray.push(jsonContent);
                }
            }
            _ = terminology:addValueSetsAsJson(jsonArray);
        } else {
            json|io:Error jsonContent = io:fileReadJson(item.absPath);
            if jsonContent is json {
                _ = terminology:addValueSetsAsJson([jsonContent]);
            }
        }
    }
}
