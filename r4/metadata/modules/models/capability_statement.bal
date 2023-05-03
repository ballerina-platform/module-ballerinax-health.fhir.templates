// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com).

// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

# Capability Statement record
# + resourceType - Capability Statement resourceType  
# + url - Capability Statement url
# + 'version - Field Description  
# + name - Capability Statement name  
# + title - Capability Statement title  
# + status - Capability Statement status  
# + experimental - Capability Statement experimental status  
# + date - Capability Statement updated date  
# + kind - Capability Statement kind  
# + implementation - Capability Statement implementation  
# + fhirVersion - Capability Statement fhirVersion  
# + format - Capability Statement format  
# + patchFormat - Capability Statement patchformat  
# + implementationGuide - Capability Statement implementationGuide  
# + rest - Capability Statement rest  
# + messaging - Capability Statement messaging  
# + document - Capability Statement document  
# + extension - Capability Statement extension
public type CapabilityStatement record {|
    string resourceType;
    string url?;
    string 'version?;
    string name?;
    string title?;
    string status;
    boolean experimental?;
    string date;
    string kind;
    Implementation implementation?;
    string fhirVersion;
    string[] format;
    string[] patchFormat?;
    string implementationGuide?;
    Rest[] rest?;
    Messaging[] messaging?;
    Document[] document?;
    Extension[] extension?;
|};
