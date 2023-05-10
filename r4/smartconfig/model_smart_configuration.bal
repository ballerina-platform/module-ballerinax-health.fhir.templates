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

# Smart configuration record
#
# + issuer - Smart configuration issuer  
# + jwks_uri - Smart configuration jwks_uri  
# + authorization_endpoint - Smart configuration authorization_endpoint  
# + grant_types_supported - Smart configuration grant_type_supported  
# + token_endpoint - Smart configuration token_endpoint  
# + token_endpoint_auth_methods_supported - Smart configuration token_endpoint_auth_methods_supported  
# + token_endpoint_auth_signing_alg_values_supported - Smart configuration token endpoint auth signing alg values supported
# + registration_endpoint - Smart configuration registration_endpoint  
# + scopes_supported - Smart configuration scopes_supported  
# + response_types_supported - Smart configuration response_type_supported  
# + management_endpoint - Smart configuration management_endpoint  
# + introspection_endpoint - Smart configuration introspection_endpoint  
# + revocation_endpoint - Smart configuration revocation_endpoint  
# + capabilities - Smart configuration capabilities  
# + code_challenge_methods_supported - Smart configuration code_challenge_methods_supported
public type SmartConfiguration record {|
    string issuer?;
    string jwks_uri?;
    string authorization_endpoint;
    string[] grant_types_supported;
    string token_endpoint;
    string[] token_endpoint_auth_methods_supported?;
    string[] token_endpoint_auth_signing_alg_values_supported?;
    string registration_endpoint?;
    string[] scopes_supported?;
    string[] response_types_supported?;
    string management_endpoint?;
    string introspection_endpoint?;
    string revocation_endpoint?;
    string[] capabilities;
    string[] code_challenge_methods_supported;
|};
