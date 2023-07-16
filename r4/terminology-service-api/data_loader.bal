import ballerinax/health.fhir.r4.terminology;
import ballerina/file;
import ballerina/io;

function init() returns error? {
    file:MetaData[] rootCodeSystem = check file:readDir("resources/code-systems/r4-external-fhir-codesystems");
    foreach var item in rootCodeSystem {
        if item.dir {
            file:MetaData[] listResult = check file:readDir(item.absPath);
            foreach var path in listResult {
                json|io:Error j = io:fileReadJson(path.absPath);
                if j is json {
                    _ = terminology:addCodeSystemsAsJson([j]);
                }
            }
        } else {
            json|io:Error j = io:fileReadJson(item.absPath);
            if j is json {
                _ = terminology:addCodeSystemsAsJson([j]);
            }
        }
    }
}
