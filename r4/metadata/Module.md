# FHIR Capability Statement API Template

## Usage

This section focuses on how to use this template to implement, configure and deploy FHIR Metadata API of a FHIR server:

### Prerequisites
1. Install [Ballerina](https://ballerina.io/learn/install-ballerina/set-up-ballerina/) 2201.5.0 (Swan Lake Update 5) or later

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
| `fhirVersion`                | FHIR Version the system supports <br/><br/> eg:  `4.0.1`                                           | 
| `format`                     | formats supported (`json`) <br/><br/> eg: `[json]`                                                 | 
| `patchFormat`                | Patch formats supported <br/><br/> eg: `[application/json-patch+json]`                             | 
| `implementationUrl`          | Base URL for the installation <br/><br/> eg: `https://choreoapis/dev/fhir_server/0.1.5`            |
| `implementationDescription`  | Describes this specific instance <br/><br/> eg: `WSO2 Open Healthcare FHIR`                        |  
| `mode`                       | Whether this statement is describing the ability to initiate or receive restful operations <br/><br/> eg: `server`                        |
| `resourceFilePath`           | Path for the file to be mount containing FHIR resources details <br/><br/> eg: `resources/fhir_resources.json`                            |
| `interactions`               | The that operations are supported <br/><br/> eg: `[search-system, history-system]`                 | 
| `cors`                       | CORS Headers availability <br/><br/> eg: `true`                                                    | 
| `discoveryEndpoint`          | OpenId configurations discovery endpoint <br/><br/> eg: `https://api.asgardeo.io/t/bifrost/oauth2/token/.well-known/openid-configuration` |
| `managementEndpoint`         | OAUTH2 access management url <br/><br/> eg: `https://sts.choreo.dev/oauth2/manage`                                                        |
| `tokenEndpoint`              | OAUTH2 access token url, optional if `discoveryEndpoint` is set  <br/><br/> eg: `https://sts.choreo.dev/oauth2/token`                     | 
| `revokeEndpoint`             | OAUTH2 access revoke url, optional if `discoveryEndpoint` is set <br/><br/> eg: `https://sts.choreo.dev/oauth2/revoke`                    | 
| `authorizeEndpoint`          | OAUTH2 access authorize url, optional if `discoveryEndpoint` is set <br/><br/> eg: `https://sts.choreo.dev/oauth2/authorize`              | 


## Sample Configurables in Config.toml
```
## server related configurables
[configFHIRServer]
version = "1.2.0"
name = "WSO2 Open Healthcare FHIR"
title = "FHIR Server"
status = "active"
experimental = true
date = "2023-4-24"
kind = "instance"
fhirVersion = "4.0.1"
format = ["json"]
patchFormat = ["application/json-patch+json"]
implementationUrl = "https://d52c48b3-b62e-4a9c-966b-585f22b4711d-dev.e1-us-east-azure.choreoapis.dev/d7k7/fhir_server/0.1.5"
implementationDescription = "WSO2 Open Healthcare FHIR"

## server security related configurables
[configRest]
mode = "server"
resourceFilePath = "resources/fhir_resources.json"
interaction = ["search-type"]

[configRest.security]
cors = false
discoveryEndpoint = "https://api.asgardeo.io/t/bifrost/oauth2/token/.well-known/openid-configuration"
managementEndpoint = "https://sts.choreo.dev/oauth2/manage"
```
