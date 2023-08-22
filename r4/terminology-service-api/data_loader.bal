// import ballerinax/health.fhir.r4.terminology;
// // import ballerina/file;
// import ballerina/io;
// import ballerinax/health.fhir.r4;

// function init2() returns error? {

//     // file:MetaData[] standardCodeSystem = check file:readDir("resources/codesystem_data.json");
//     // foreach var item in standardCodeSystem {
//     //     if item.dir {
//     //         file:MetaData[] listResult = check file:readDir(item.absPath);
//     //         json[] jsonArray = [];
//     //         foreach var path in listResult {
//     //             json|io:Error jsonContent = io:fileReadJson(path.absPath);
//     //             if jsonContent is json {
//     //                 jsonArray.push(jsonContent);
//     //             }
//     //         }
//     //         _ = terminology:addCodeSystemsAsJson(jsonArray);
//     //     } else {
//     //         json|io:Error jsonContent = io:fileReadJson(item.absPath);
//     //         if jsonContent is json {
//     //             _ = terminology:addCodeSystemsAsJson([jsonContent]);
//     //         }
//     //     }
//     // }

//     FinderImpl finder = new();
//     r4:terminologyProcessor.setFinder(finder);
//     json|io:Error jsonContent = io:fileReadJson("resources/codesystem_data.json");
//     if jsonContent is json {
//         _ = terminology:addCodeSystemsAsJson([jsonContent]);
//     }



//     // file:MetaData[] loincConcepts = check file:readDir("resources/code-systems/loinc/codes");
//     // r4:CodeSystemConcept[] conceptsArray = [];
//     // foreach var item in loincConcepts {
//     //     if item.dir {
//     //         file:MetaData[] listResult = check file:readDir(item.absPath);
//     //         foreach var path in listResult {
//     //             json|io:Error jsonContent = io:fileReadJson(path.absPath);
//     //             if jsonContent is json {
//     //                 r4:CodeSystemConcept|error concept = jsonContent.cloneWithType(r4:CodeSystemConcept);
//     //                 if concept is r4:CodeSystemConcept {
//     //                     // io:println("Loaded: "+concept.code);
//     //                     conceptsArray.push(concept);
//     //                 }

//     //             }
//     //         }
//     //         // _ = terminology:addCodeSystemsAsJson(jsonArray);
//     //     } else {
//     //         json|io:Error jsonContent = io:fileReadJson(item.absPath);
//     //         if jsonContent is json {
//     //             r4:CodeSystemConcept|error concept = jsonContent.cloneWithType(r4:CodeSystemConcept);
//     //             if concept is r4:CodeSystemConcept {
//     //                 // io:println("Loaded: "+concept.code);
//     //                 conceptsArray.push(concept);
//     //             }
//     //         }
//     //     }
//     // }
//     // check insertConcepts("http://loinc.org", conceptsArray);

//     // file:MetaData[] loincValueSets = check file:readDir("resources/code-systems/loinc/valuesets");
//     // r4:ValueSet[] valueSetsArray = [];
//     // foreach var item in loincValueSets {
//     //     if item.dir {
//     //         file:MetaData[] listResult = check file:readDir(item.absPath);
//     //         foreach var path in listResult {
//     //             json|io:Error jsonContent = io:fileReadJson(path.absPath);
//     //             if jsonContent is json {
//     //                 r4:ValueSet|error valueSet = jsonContent.cloneWithType(r4:ValueSet);
//     //                 if valueSet is r4:ValueSet {
//     //                     // io:println("Loaded: "+concept.code);
//     //                     valueSetsArray.push(valueSet);
//     //                 }

//     //             }
//     //         }
//     //         // _ = terminology:addCodeSystemsAsJson(jsonArray);
//     //     } else {
//     //         json|io:Error jsonContent = io:fileReadJson(item.absPath);
//     //         if jsonContent is json {
//     //             r4:ValueSet|error valueSet = jsonContent.cloneWithType(r4:ValueSet);
//     //             if valueSet is r4:ValueSet {
//     //                 // io:println("Loaded: "+concept.code);
//     //                 valueSetsArray.push(valueSet);
//     //             }
//     //         }
//     //     }
//     // }
//     // check insertValueSets(valueSetsArray);

//     // json|io:Error csjson = io:fileReadJson("resources/code-systems/loinc/codesystem/loinc-2.74.json");
//     // if csjson is json {
//     //     r4:CodeSystem codeSystem = check csjson.cloneWithType(r4:CodeSystem);

//     //     codeSystem.concept = conceptsArray;
//     //     check terminology:addCodeSystem(codeSystem);
//     // }

//     //     file:MetaData[] rootValueSet = check file:readDir("resources/value-sets");
//     //     foreach var item in rootValueSet {
//     //         if item.dir {
//     //             file:MetaData[] listResult = check file:readDir(item.absPath);
//     //             json[] jsonArray = [];
//     //             foreach var path in listResult {
//     //                 json|io:Error jsonContent = io:fileReadJson(path.absPath);
//     //                 if jsonContent is json {
//     //                     jsonArray.push(jsonContent);
//     //                 }
//     //             }
//     //             _ = terminology:addValueSetsAsJson(jsonArray);
//     //         } else {
//     //             json|io:Error jsonContent = io:fileReadJson(item.absPath);
//     //             if jsonContent is json {
//     //                 _ = terminology:addValueSetsAsJson([jsonContent]);
//     //             }
//     //         }
//     //     }
// }
