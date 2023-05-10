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

# OpenID configuration.
#
# + issuer - issuer  
# + authorization_endpoint - authorization endpoint
# + device_authorization_endpoint - device authorization endpoint  
# + token_endpoint - token endpoint
# + userinfo_endpoint - userinfo endpoint
# + revocation_endpoint - revocation endpoint  
# + introspection_endpoint - introspection endpoint  
# + registration_endpoint - registration endpoint
# + management_endpoint - management endpoint
# + jwks_uri - jwks uri
# + grant_types_supported - grant types supported
# + response_types_supported - response types supported
# + subject_types_supported - subject types supported
# + id_token_signing_alg_values_supported - id token signing alg values supported
# + scopes_supported - scopes supported
# + token_endpoint_auth_methods_supported - token endpoint auth methods supported
# + claims_supported - claims supported
# + code_challenge_methods_supported - code challenge methods supported
public type OpenIDConfiguration record {
    string issuer?;
    string authorization_endpoint?;
    string device_authorization_endpoint?;
    string token_endpoint?;
    string userinfo_endpoint?;
    string revocation_endpoint?;
    string introspection_endpoint?;
    string registration_endpoint?;
    string management_endpoint?;
    string jwks_uri?;
    string[] grant_types_supported?;
    string[] response_types_supported?;
    string[] subject_types_supported?;
    string[] id_token_signing_alg_values_supported?;
    string[] scopes_supported?;
    string[] token_endpoint_auth_methods_supported?;
    string[] claims_supported?;
    string[] code_challenge_methods_supported?;
};
