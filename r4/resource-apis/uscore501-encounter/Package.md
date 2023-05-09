

# Encounter Template

## Template Overview

This template provides a boilerplate code for rapid implementation of FHIR APIs and creating, accessing and manipulating FHIR resources.


| Module/Element       | Version                                                                                                                                          |
|----------------------|--------------------------------------------------------------------------------------------------------------------------------------------------|
| FHIR version         | r4                                                                                                                                               |
| Implementation Guide | [http://hl7.org/fhir/us/core/index.html](http://hl7.org/fhir/us/core/index.html)                                                                 |
| Profile URL          | [http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter](http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter)           |
| Documentation        | [http://hl7.org/fhir/us/core/StructureDefinition-us-core-encounter.html](http://hl7.org/fhir/us/core/StructureDefinition-us-core-encounter.html) |

### Dependency List

| Module                                      | Version |
|---------------------------------------------|---------|
| ballerinax/health.fhir.r4                   | 1.0.0   |
| ballerinax/health.fhir.r4.uscore501         | 1.0.0   |
| ballerinax/health.base                      | 1.0.0   |

This template includes,

- Ballerina service for 'Encounter' FHIR resource with following FHIR interactions.
- Search
- Read
- Create
- Generated Utility functions per each FHIR profile to handle source system connections
- Pre-engaged FHIR pre-processors and post-processors for built-in FHIR Server capabilities

## Prerequisites

Pull the template from central

`bal new -t ballerinax/health.fhir.templates.r4.uscore501.encounter EncounterAPI`

## Implementing Source System Connections

- Implement each FHIR interaction in `<resource name>_connect.bal` file which included in the project.
- You can use relevant client connector, object to initialize the connection to fetch/push data from/to the source system.
- Method signatures should not be modified and request information will be populated in the `fhirContext` for ease of access.

## Run the template

Run the Ballerina project created by the service template by executing bal run from the root.

Once successfully executed, Listener will be started at port 8090. Then you need to invoke the service using the following curl command

` $ curl http://localhost:9090/fhir/r4/Encounter `

Now service will be invoked and returns the message as FHIR bundle

````
{

"resourceType":"Bundle",

"entry":[{},{}]

}
````
## Adding a Custom Profile/Combination of Profiles

- Introduce a new file containing a class which implements functions for FHIR interactions.
  - This class need to implement `EncounterSourceConnect` object type
  - It needs to have the same structure as the `international_encounter_connect.bal` file.
- Register the new class in the `service.bal` file.
  - Add and entry to `profileImpl` map as `profileURL:instantiated source connect class`. Eg: `"http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter": new InternationalEncounterSourceConnect()`
  - Add profile type to the aggregated resource type. Eg: `public type Encounter r4:Encounter|<Other_Encounter_Profile>;`.
- Add the new profile URL in `api_config.bal` file.
  - Add as a string inside the `profiles` array.
  - Eg: `profiles: ["http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter", "new_profile_url"]`


## Onboard as a Choreo project
This project can be onboarded directly to Choreo via Github.
For more info, Refer: https://wso2.com/choreo/docs/tutorials/connect-your-existing-ballerina-project-to-choreo/#connect-your-existing-ballerina-project-to-choreo

