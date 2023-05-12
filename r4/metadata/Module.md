# FHIR Capability Statement API Template

## Usage

This section focuses on how to use this template to implement, configure and deploy FHIR Metadata API of a FHIR server:

### Prerequisites
1. Install [Ballerina](https://ballerina.io/learn/install-ballerina/set-up-ballerina/) 2201.1.2 (Swan Lake Update 1) or later

### Setup and run in VM or Developer Machine

1) Create an API project from this template
   ```
   bal new -t ballerinax/health.fhir.templates.r4.metadata <PROJECT_NAME>
   ```
2) Update deployed FHIR resource data in `/resources/resources.json`

3) Perform necessary updates in [configurations](#configurations).

4) Run by executing command: `bal run` in your terminal to run this package. 

5) Invoke `<BASE_URL>/fhir/r4/metadata/`
   1) Invoke from localhost : `http://localhost:9090/fhir/r4/metadata/`

### Setup and deploy on [Choreo](https://wso2.com/choreo/)
1) Create an API project from this template
   ```
   bal new -t ballerinax/health.fhir.templates.r4.metadata <PROJECT_NAME>
   ```
2) Update deployed FHIR resource data in `/resources/resources.json`

3) Perform necessary updates in [configurations](#configurations).

4) Create GitHub repository and push created source to relevant branch

5) Follow instructions to [connect project repository to Choreo](https://wso2.com/choreo/docs/tutorials/connect-your-existing-ballerina-project-to-choreo/)

6) Deploy API by following [instructions to deploy](https://wso2.com/choreo/docs/tutorials/create-your-first-rest-api/#step-2-deploy)
 and [test](https://wso2.com/choreo/docs/tutorials/create-your-first-rest-api/#step-2-deploy)

7) Invoke `<BASE_URL>/fhir/r4/metadata/`

    `https://<HOSTNAME>/<TENANT_CONTEXT>/fhir/r4/metadata/`

## Configurations

Following configurations can be configured in `Config.toml` or Choreo configurable editor

| Configuration                | Description                                                                                        |
|------------------------------|----------------------------------------------------------------------------------------------------|
| `version`                    | Business version of the capability statement <br/><br/>  eg: `0.1.7`                               |
| `name`                       | Name for this capability statement (computer friendly)  <br/><br/> eg: `WSO2 Open Healthcare FHIR` | 
| `title`                      | Name for this capability statement (human friendly) <br/><br/> eg: `FHIR Server`                   | 
| `status`                     | `draft` / `active` / `retired` / `unknown` <br/><br/> eg: `active`                                 | 
| `experimental`               | For testing purposes, not real usage <br/><br/> eg: `true`                                         | 
| `date`                       | Date last changed <br/><br/> eg: `26-01-2023`                                                      | 
| `kind`                       | `instance` / `capability` / `requirements` <br/><br/> eg: `instance`                               | 
| `fhir_version`               | FHIR Version the system supports <br/><br/> eg:  `4.0.1`                                           | 
| `format`                     | formats supported (`json`) <br/><br/> eg: `[json]`                                                 | 
| `patch_format`               | Patch formats supported <br/><br/> eg: `[application/json-patch+json]`                             | 
| `implementation_url`         | Base URL for the installation <br/><br/> eg: `https://choreoapis/dev/fhir_server/0.1.5`            |
| `implementation_description` | Describes this specific instance <br/><br/> eg: `WSO2 Open Healthcare FHIR`                        |  
| `interactions`               | The that operations are supported <br/><br/> eg: `[search-system, history-system]`                 | 
| `security_cors`              | CORS Headers availability <br/><br/> eg: `true`                                                    | 
| `token_url`                  | OAUTH2 access token url <br/><br/> eg: `https://sts.choreo.dev/oauth2/token`                       | 
| `revoke_url`                 | OAUTH2 access revoke url <br/><br/> eg: `https://sts.choreo.dev/oauth2/revoke`                     | 
| `authorize_url`              | OAUTH2 access authorize url <br/><br/> eg: `https://sts.choreo.dev/oauth2/authorize`               | 


## Sample Configurables in Config.toml
```
## server related configurables
[server_info]
version = "0.1.5"
name = "WSO2 Open Healthcare FHIR"
title = "FHIR Server"
status = "active"
experimental = true
date = "2023-01-08"
kind = "instance"
fhir_version = "4.0.1"
format = ["json", "xml"]
patch_format = ["application/json-patch+json"]
implementation_url = "https://d52c48b3-b62e-4a9c-966b-585f22b4711d-dev.e1-us-east-azure.choreoapis.dev/d7k7/fhir_server/0.1.5"
implementation_description = "WSO2 Open Healthcare FHIR"
interactions = ["search-system"]

## server security related configurables
[security]
security_cors = true
token_url = "https://sts.choreo.dev/oauth2/token"
revoke_url = "https://sts.choreo.dev/oauth2/revoke"
authorize_url = "https://sts.choreo.dev/oauth2/authorize"
```
