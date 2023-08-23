

# Patient Template

## Template Overview

This template provides a boilerplate code for rapid implementation of FHIR APIs and creating, accessing and manipulating FHIR resources.


| Module/Element       | Version |
|---| --- |
| FHIR version         | r4 |
| Implementation Guide | [http://hl7.org/fhir](http://hl7.org/fhir) |
| Profile URL          |[http://hl7.org/fhir/StructureDefinition/Patient](http://hl7.org/fhir/StructureDefinition/Patient)|

### Dependency List

| Module | Version |
| --- | --- |
| ballerinax/health.fhir.r4 | 4.1.0 |
| ballerinax/health.fhirr4 | 1.0.8 |
| ballerinax/health.fhirr4 | 1.0.8 |
|

This template includes,

- Ballerina service for 'FHIR Resource Name' FHIR resource with following FHIR interactions.
- READ
- SEARCH
- CREATE
- Generated Utility functions to handle context data
- Pre-engaged FHIR pre-processors and post-processors for built-in FHIR Server capabilities


## Prerequisites

Pull the template from central

    ` bal new -t ballerinax/health.fhir.templates.patient PatientAPI `

## Run the template
- Run the Ballerina project created by the service template by executing bal run from the root.
- Once successfully executed, Listener will be started at port 9090. Then you need to invoke the service using the following curl command
    ` $ curl http://localhost:9090/fhir/r4/Patient `
- Now service will be invoked and returns the message as FHIR bundle

    ```
    {

        "resourceType":"Bundle",

        "entry":[{},{}]

    }
    ```
## Adding a Custom Profile/Combination of Profiles

- Introduce a new file containing a class which implements functions for FHIR interactions.
- This class need to implement `PatientSourceConnect` object type
- It needs to have the same structure as the ` healthcare.fhir_patient_connect ` file.
- Register the new class in the `service.bal` file.
- Add and entry to `profileImpl` map as `profileURL:instantiated source connect class`. Eg: `"http://hl7.org/fhir/StructureDefinition/Patient": new Healthcare.fhirPatientSourceConnect()`
- Add profile type to the aggregated resource type. Eg: `public type Patient r4:Patient|<Other_Patient_Profile>;`.
    - Add the new profile URL in `api_config.bal` file.
    - Add as a string inside the `profiles` array.
    - Eg: `profiles: ["http://hl7.org/fhir/StructureDefinition/Patient", "new_profile_url"]`

## Onboard as a Choreo project
This project can be onboarded directly to Choreo via Github.
For more info, Refer: https://wso2.com/choreo/docs/tutorials/connect-your-existing-ballerina-project-to-choreo/#connect-your-existing-ballerina-project-to-choreo
