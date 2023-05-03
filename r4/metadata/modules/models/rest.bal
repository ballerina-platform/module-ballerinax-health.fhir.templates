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

# Rest record
# + mode - Rest mode  
# + documentation - Rest documentation  
# + security - Rest security  
# + 'resource - Rest resource  
# + interaction - Rest interaction  
# + searchParam - Rest searchParam  
# + operation - Rest operation  
# + compartment - Rest compartment
public type Rest record {|
    string mode;
    anydata documentation?;
    Security security?;
    Resource[] 'resource?;
    Interaction[] interaction?;
    SearchParam searchParam?;
    Operation operation?;
    string compartment?;
|};
