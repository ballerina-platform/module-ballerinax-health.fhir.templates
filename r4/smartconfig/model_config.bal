
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
# + discoveryEndpoint - Smart configuration discoveryEndpoint
# + smartConfiguration - Smart configuration
public type Configs record {|
    string discoveryEndpoint?;
    ConfigSmartConfiguration smartConfiguration?;
|};

# Smart configuration record
#
# + issuer - Smart configuration issuer  
# + jwksUri - Smart configuration jwks_uri  
# + authorizationEndpoint - Smart configuration authorization_endpoint  
# + grantTypesSupported - Smart configuration grant_type_supported  
# + tokenEndpoint - Smart configuration token_endpoint  
# + tokenEndpointAuthMethodsSupported - Smart configuration token_endpoint_auth_methods_supported  
# + tokenEndpointAuthSigningAlgValuesSupported - Smart configuration token endpoint auth signing alg values supported
# + registrationEndpoint - Smart configuration registration_endpoint  
# + scopesSupported - Smart configuration scopes_supported  
# + responseTypesSupported - Smart configuration response_type_supported  
# + managementEndpoint - Smart configuration management_endpoint  
# + introspectionEndpoint - Smart configuration introspection_endpoint  
# + revocationEndpoint - Smart configuration revocation_endpoint  
# + capabilities - Smart configuration capabilities  
# + codeChallengeMethodsSupported - Smart configuration code_challenge_methods_supported
public type ConfigSmartConfiguration record {|
    string issuer?;
    string jwksUri?;
    string authorizationEndpoint?;
    string[] grantTypesSupported?;
    string tokenEndpoint?;
    string[] tokenEndpointAuthMethodsSupported?;
    string[] tokenEndpointAuthSigningAlgValuesSupported?;
    string registrationEndpoint?;
    string[] scopesSupported?;
    string[] responseTypesSupported?;
    string managementEndpoint?;
    string introspectionEndpoint?;
    string revocationEndpoint?;
    string[] capabilities;
    string[] codeChallengeMethodsSupported?;
|};
