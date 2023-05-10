# FHIR Repository API Template

## Template Overview

This template provides a boilerplate code for rapid implementation of FHIR Repository APIs and syncing the FHIR Repository from Client Source Systems.  
Once deployed to Choreo as a Scheduled Trigger Component, this template will periodically fetch recently updated resources from Client Source Systems and update the FHIR repository.  

> **Note**  
> This template does not include the functionality to asynchronously delete resources from the FHIR Repository that no longer exist on Client Source Systems.  
> We recommend that the developer handle this separately in real-time.  

| Module/Element       | Version |
|---| --- |
| FHIR version         | r4 |
| Implementation Guide | [http://hl7.org/fhir/](http://hl7.org/fhir/) |
| Documentation        | [https://www.hl7.org/fhir/Patient\.html](https://www.hl7.org/fhir/Patient\.html) |

### Dependency List

| Module                              | Version |
| ----------------------------------- |---------|
| ballerinax/health.fhir.r4           | 1.0.1   |
| ballerinax/health.base              | 1.0.0   |
| ballerinax/health.clients.fhir      | 1.0.0   |

This template includes,  

- Ballerina code to sync a FHIR Repository from Client Source Systems and Ready to be deployed as a Choreo Scheduled Task Component.  
- Generated Utility functions to fetch/push last invocation time of the scheduler from a Client Persistence Layer  
- Generated Utility functions to handle source system connections for fetching Source Resources and syncing the FHIR Repository 

## Prerequisites

Pull the template from central

`bal new -t ballerinax/health.fhir.r4.sync.repository FHIRRepoSync`

## Implementing Source System Connections

- Implement fetching resources from Client Source Systems that have been updated in the given time bounds `[lastInvocation, now]` inside `sync_update.bal` file which is included in the project. After fetching map each resource to a relevant ballerina FHIR resource type. Push all mapped resources into a single `r4:FHIRResourceEntity[]` and return it. A sample is given in the template.  
- You can use a relevant client connector, object to initialize the connection to fetch/push data from/to the source system.  

## Configuring FHIR Connector

- The ballerina FHIR Connector Configuration can be found inside fhir_repo_connector.bal  
- The base url of the FHIR server can be provided as a configurable string `baseUrl`.  
- For advanced configurations edit the default configuration found inside fhir_repo_connector.bal  

## Implementing Fetch/Push of Scheduler Invocation time

- Implement fetching last invocation time of the scheduler inside `client_util.bal` file which is included in the project. By default it will throw an error.
  ```bal
  function fetchLastInvocationTime() returns time:Utc|error {}
  ```
- Implement pushing the given current invocation time (time:Utc now) of the scheduler inside `client_util.bal` file which is included in the project. By default it will throw an error.
  ```bal
  function pushCurrentInvocationTime(time:Utc now) returns error? {}
  ```   

## Implementing Processing Bundle Entry

- Implement processing the fhir bundle entry for the fhir transaction inside `client_util.bal` file which is included in the project. By default it will return `map<r4:BundleEntry[]>` with `r4:BundleEntry[]` provided as function parameters without processing.
- Suppose you want to split the bundle `r4:BundleEntry[]` and send it as multiple fhir bundle transactions. The implementation is provided in the template in comments.
  ```bal
  function processAndReturnBundleEntries(r4:BundleEntry[] bundleEntry) returns map<r4:BundleEntry[]>|error {}
  ```

## Run the template

Run the Ballerina project created by this template by executing `bal run` from the root.  

Once successfully executed, the process will run and sync the FHIR repository once and exit. For the continuous functionality as a Scheduled Trigger this template must be deployed to Choreo.  

## Onboard as a Choreo project
This project can be onboarded directly to Choreo via Github.
For more info, Refer to: 
1. https://wso2.com/choreo/docs/tutorials/connect-your-existing-ballerina-project-to-choreo/#connect-your-existing-ballerina-project-to-choreo  

2. https://wso2.com/choreo/docs/develop/components/scheduled-tasks/

