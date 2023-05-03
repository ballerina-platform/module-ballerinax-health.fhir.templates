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

# Resource record
# + 'type - Resource type  
# + supportedProfile - Resource supportedProfile  
# + interaction - Resource interaction  
# + versioning - Resource versioning  
# + conditionalCreate - Resource conditionalCreate  
# + conditionalRead - Resource conditionalRead  
# + conditionalUpdate - Resource conditionalUpdate  
# + conditionalDelete - Resource conditionalDelete  
# + referencePolicy - Resource referencePolicy  
# + searchInclude - Resource searchInclude  
# + searchRevInclude - Resource searchRevInclude  
# + searchParam - Resource searchParam  
# + operation - Resource operation  
# + extension - Resource extension
public type Resource record {
    string 'type;
    string[] supportedProfile?;
    Interaction[] interaction?;
    string versioning?;
    boolean conditionalCreate?;
    string conditionalRead?;
    boolean conditionalUpdate?;
    string conditionalDelete?;
    string[] referencePolicy?;
    string[] searchInclude?;
    string[] searchRevInclude?;
    SearchParam[] searchParam?;
    Operation[] operation?;
    Extension[] extension?;
};
