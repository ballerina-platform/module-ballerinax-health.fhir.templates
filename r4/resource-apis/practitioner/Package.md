

# Practitioner Template

## Template Overview

This template provides a boilerplate code for rapid implementation of FHIR APIs and creating, accessing and manipulating FHIR resources.


| Module/Element       | Version |
|---| --- |
| FHIR version         | r4 |
| Implementation Guide | [http://hl7.org/fhir](http://hl7.org/fhir) |
| Profile URL          |[http://hl7.org/fhir/StructureDefinition/Practitioner](http://hl7.org/fhir/StructureDefinition/Practitioner)|

### Dependency List

- ballerinax/health.fhir.r4
- ballerinax/health.fhirr4
- ballerinax/health.fhir.r4.international401

This template includes,

- Ballerina service for Practitioner FHIR resource with following FHIR interactions.
- READ
- VREAD
- SEARCH
- CREATE
- UPDATE
- PATCH
- DELETE
- HISTORY-INSTANCE
- HISTORY-TYPE
- Generated Utility functions to handle context data

## Prerequisites

Pull the template from central

    ` bal new -t ballerinax/health.fhir.templates.international401.practitioner PractitionerAPI `

## Run the template
- Run the Ballerina project created by the service template by executing bal run from the root.
- Once successfully executed, Listener will be started at port 9090. Then you need to invoke the service using the following curl command
    ` $ curl http://localhost:9090/fhir/r4/Practitioner `
- Now service will be invoked and returns an Operation Outcome, until the code template is implemented completely.

## Adding a Custom Profile/Combination of Profiles

- Add profile type to the aggregated resource type. Eg: `public type Practitioner r4:Practitioner|<Other_Practitioner_Profile>;`.
    - Add the new profile URL in `api_config.bal` file.
    - Add as a string inside the `profiles` array.
    - Eg: `profiles: ["http://hl7.org/fhir/StructureDefinition/Practitioner", "new_profile_url"]`
