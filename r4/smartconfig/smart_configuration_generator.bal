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

configurable Configs configs = ?;

# Generator function for Smart Configuration
# + return - smart configuration as a json or an error
public isolated function generateSmartConfiguration() returns SmartConfiguration|error {
    LogDebug("Generating smart configuration started");

    OpenIDConfiguration openIdConfigurations = {};
    string? discoveryEndpoint = configs.discoveryEndpoint;
    if discoveryEndpoint is string && discoveryEndpoint != "" {
        openIdConfigurations = check getOpenidConfigurations(discoveryEndpoint).cloneReadOnly();
    } else {
        LogDebug(string `${VALUE_NOT_FOUND}: discoveryEndpoint`);
    }

    string? authorization_endpoint = configs.smartConfiguration?.authorizationEndpoint?:openIdConfigurations.authorization_endpoint?:();
    if authorization_endpoint is () || authorization_endpoint == "" {
        return error(string `${VALUE_NOT_FOUND}: Authorization endpoint`);
    }

    string? token_endpoint = configs.smartConfiguration?.tokenEndpoint?:openIdConfigurations.token_endpoint?:();
    if token_endpoint is () || token_endpoint == "" {
        return error(string `${VALUE_NOT_FOUND}: Token endpoint`);
    }

    string[]? capabilities = configs.smartConfiguration?.capabilities?:();
    if capabilities is () || capabilities.length() == 0 {
        return error(string `${VALUE_NOT_FOUND}: Capabilities`);
    }

    string[]? code_challenge_methods_supported = configs.smartConfiguration?.codeChallengeMethodsSupported?:openIdConfigurations.code_challenge_methods_supported?:();
    if code_challenge_methods_supported is () || code_challenge_methods_supported.length() == 0 {
        return error(string `${VALUE_NOT_FOUND}: Code challenge methods supported`);
    }

    string[]? grant_types_supported = configs.smartConfiguration?.grantTypesSupported?:openIdConfigurations.grant_types_supported?:();
    if grant_types_supported is () || grant_types_supported.length() == 0 {
        return error(string `${VALUE_NOT_FOUND}: Grant types supported`);
    }

    SmartConfiguration smartConfig = {
        authorization_endpoint, 
        token_endpoint,
        capabilities,
        code_challenge_methods_supported,
        grant_types_supported,
        issuer: configs.smartConfiguration?.issuer?:openIdConfigurations.issuer?:(),
        revocation_endpoint: configs.smartConfiguration?.revocationEndpoint?:openIdConfigurations.revocation_endpoint?:(),
        introspection_endpoint: configs.smartConfiguration?.introspectionEndpoint?:openIdConfigurations.introspection_endpoint?:(),
        management_endpoint: configs.smartConfiguration?.managementEndpoint?:openIdConfigurations.management_endpoint?:(),
        registration_endpoint: configs.smartConfiguration?.registrationEndpoint?:openIdConfigurations.registration_endpoint?:(),
        jwks_uri: configs.smartConfiguration?.jwksUri?:openIdConfigurations.jwks_uri?:(),
        response_types_supported: configs.smartConfiguration?.responseTypesSupported?:openIdConfigurations.response_types_supported?:(),
        token_endpoint_auth_methods_supported: configs.smartConfiguration?.tokenEndpointAuthMethodsSupported?:openIdConfigurations.token_endpoint_auth_methods_supported?:(),
        token_endpoint_auth_signing_alg_values_supported: configs.smartConfiguration?.tokenEndpointAuthSigningAlgValuesSupported?:(),
        scopes_supported: configs.smartConfiguration?.scopesSupported?:openIdConfigurations.scopes_supported?:()
    };

    LogDebug("Generating smart configuration completed ");
    return smartConfig;
}
