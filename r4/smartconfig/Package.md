# FHIR SMART Configuration API Template

## Template Overview
This API template provides API implementation of 
[SMART Discovery API](https://www.hl7.org/fhir/smart-app-launch/#discovery-of-server-capabilities-and-configuration) 
of a FHIR server.

SMART defines a discovery document available at `.well-known/smart-configuration` relative to a FHIR Server Base URL, 
allowing clients to learn the authorization endpoint URLs and features a server supports. This information helps client 
direct authorization requests to the right endpoint, and helps clients construct an authorization request that the server 
can support.

|                      |                                                            |
|----------------------|------------------------------------------------------------|
| FHIR                 | R4                                                         |
| Implementation Guide | http://hl7.org/fhir/                                       |
| Specification        | https://www.hl7.org/fhir/smart-app-launch/conformance.html |

## Usage

This section focuses on how to use this template to implement, configure and deploy 
[SMART Discovery API](https://www.hl7.org/fhir/smart-app-launch/#discovery-of-server-capabilities-and-configuration) 
of a FHIR server:

### Prerequisites
1. Install [Ballerina](https://ballerina.io/learn/install-ballerina/set-up-ballerina/) 2201.1.2 (Swan Lake Update 1) or later

### Setup and run in VM or Developer Machine

1) Create an API project from this template
   ```
   bal new -t ballerinax/health.fhir.templates.r4.smartconfiguration <PROJECT_NAME>
   ```
2) Perform necessary updates in [configurations](#configurations).

3) Run by executing command: `bal run` in your terminal to run this package.

4) Invoke `<BASE_URL>/fhir/r4/.well-known/smart-configuration`
    1) Invoke from localhost : `http://localhost:9090/fhir/r4/.well-known/smart-configuration`

### Setup and deploy on [Choreo](https://wso2.com/choreo/)
1) Create an API project from this template
   ```
   bal new -t ballerinax/health.fhir.templates.r4.smartconfiguration <PROJECT_NAME>
   ```
2) Perform necessary updates in [configurations](#configurations).
3) Create GitHub repository and push created source to relevant branch
4) Follow instructions to [connect project repository to Choreo](https://wso2.com/choreo/docs/tutorials/connect-your-existing-ballerina-project-to-choreo/)
5) Deploy API by following [instructions to deploy](https://wso2.com/choreo/docs/tutorials/create-your-first-rest-api/#step-2-deploy)
   and [test](https://wso2.com/choreo/docs/tutorials/create-your-first-rest-api/#step-2-deploy)
6) Invoke `<BASE_URL>/fhir/r4/.well-known/smart-configuration`
   
    Example: `https://<HOSTNAME>/<TENANT_CONTEXT>/fhir/r4/.well-known/smart-configuration`

## Configurations

Following configurations can be configured in `Config.toml` or Choreo configurable editor

| Name                                    | Description                                                                                                                                                                                                                    |
|-----------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `issuer`                                | CONDITIONAL, String conveying this system’s OpenID Connect Issuer URL. Required if the server’s capabilities include sso-openid-connect; otherwise, omitted. <br/><br/> eg: `https://sts.choreo.dev/oauth2/token`         
| `jwks_uri`                              | CONDITIONAL, String conveying this system’s JSON Web Key Set URL. Required if the server’s capabilities include sso-openid-connect; otherwise, optional. <br/><br/> eg: `https://sts.choreo.dev/oauth2/jwks`                                                                      |
| `authorization_endpoint`                | REQUIRED, URL to the OAuth2 authorization endpoint. <br/><br/> eg: `https://sts.choreo.dev/oauth2/authorize`                                                                                                                                                                           |
| `grant_types_supported`                 | REQUIRED, Array of grant types supported at the token endpoint. The options are “authorization_code” (when SMART App Launch is supported) and “client_credentials” (when SMART Backend Services is supported). <br/><br/> eg: `[authorization_code, client_credentials]`                |
| `token_endpoint`                        | REQUIRED, URL to the OAuth2 token endpoint. <br/><br/> eg: `https://sts.choreo.dev/oauth2/token`                                                                                                                                                                                  |
| `token_endpoint_auth_methods_supported` | OPTIONAL, array of client authentication methods supported by the token endpoint. The options are “client_secret_post”, “client_secret_basic”, and “private_key_jwt”. <br/><br/> eg: `[client_secret_basic, private_key_jwt]`                                                          |
| `registration_endpoint`                 | OPTIONAL, If available, URL to the OAuth2 dynamic registration endpoint for this FHIR server. <br/><br/> eg: `https://sts.choreo.dev/oauth2/register`                                                                                                                                 |
| `scopes_supported`                      | RECOMMENDED, Array of scopes a client may request. See scopes and launch context. The server SHALL support all scopes listed here; additional scopes MAY be supported (so clients should not consider this an exhaustive list). <br/><br/> eg: `[openid, profile, launch, launch/patient, patient/*.rs, user/*.rs, offline_access]`|
| `response_types_supported`              | RECOMMENDED, Array of OAuth2 response_type values that are supported. Implementers can refer to response_types defined in OAuth 2.0 (RFC 6749) and in OIDC Core. <br/><br/> eg: `[code]`                                                               |
| `management_endpoint`                   | RECOMMENDED, URL where an end-user can view which applications currently have access to data and can make adjustments to these access rights. <br/><br/> eg: `https://sts.choreo.dev/oauth2/manage`                                                                                   |
| `introspection_endpoint `               | RECOMMENDED, URL to a server’s introspection endpoint that can be used to validate a token. <br/><br/> eg: `https://sts.choreo.dev/oauth2/introspect`                                                                                                                                    |
| `revocation_endpoint `                  | RECOMMENDED, URL to a server’s revoke endpoint that can be used to revoke a token. <br/><br/> eg: `https://sts.choreo.dev/oauth2/revoke`                                                                                                                                             |
| `capabilities`                          | REQUIRED, Array of strings representing SMART capabilities (e.g., sso-openid-connect or launch-standalone) that the server supports. <br/><br/> eg: `[launch-ehr, permission-patient, permission-v2, client-public, client-confidential-symmetric, context-ehr-patient, sso-openid-connect]`                                                                                           |
| `code_challenge_methods_supported`      | REQUIRED, Array of PKCE code challenge methods supported. The S256 method SHALL be included in this list, and the plain method SHALL NOT be included in this list. <br/><br/> eg: `[S256]`                                                             |

## Sample Configurables in Config.toml

```
## smart-configuration
[smart_configuration]
authorization_endpoint = "https://sts.choreo.dev/oauth2/authorize"
token_endpoint = "https://sts.choreo.dev/oauth2/token"
introspection_endpoint = "https://sts.choreo.dev/oauth2/introspect"
code_challenge_methods_supported = ["S256"]
grant_types_supported = ["authorization_code"]
revocation_endpoint = "https://sts.choreo.dev/oauth2/revoke"
token_endpoint_auth_methods_supported = ["private_key_jwt", "client_secret_basic"]
token_endpoint_auth_signing_alg_values_supported = ["RS384","ES384"]
scopes_supported = [
    "openid",
    "fhirUser",
    "launch",
    "launch/patient",
    "patient/*.cruds",
    "user/*.cruds",
    "offline_access",
]
response_types_supported = [
    "code",
    "id_token",
    "token",
    "device",
    "id_token token"
]
capabilities = [
    "launch-ehr",
    "launch-standalone",
    "client-public",
    "client-confidential-symmetric",
    "client-confidential-asymmetric",
    "context-passthrough-banner",
    "context-passthrough-style",
    "context-ehr-patient",
    "context-ehr-encounter",
    "context-standalone-patient",
    "context-standalone-encounter",
    "permission-offline",
    "permission-patient",
    "permission-user",
    "permission-v2",
    "authorize-post"
]
```