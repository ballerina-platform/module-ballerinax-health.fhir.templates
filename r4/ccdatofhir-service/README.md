This template implements a REST service to expose C-CDA to FHIR pre-built mappings. Once exposed it will accept CCDA documents and returns transformed FHIR Bundle. 

# C-CDA to FHIR Service

## Overview

This template exposes mappings implemented as per the CCDA to FHIR implementation guide (http://build.fhir.org/ig/HL7/ccda-on-fhir/CF-index.html). Following are the supported CCDA-to-FHIR conversions.

1) C-CDA Allergy Intolerance Observation to FHIR Allergy Intolerance.
2) C-CDA Problem observation to FHIR Condition.
3) C-CDA Results to FHIR Diagnostic Report.
4) C-CDA Immunization Activity to FHIR Immunization.
5) C-CDA Medication Activity to FHIR Medication.
6) C-CDA Patient Role Header to FHIR Patient.
7) C-CDA Author Header to FHIR Practitioner.
8) C-CDA Procedure Activity to FHIR Procedure.

### Compatibility

| Protocol            | Version                   |
|---------------------|---------------------------|
| FHIR                | R4                        |

## Using the Template

### Setup and run

1.  Create Ballerina project from this template.

    ```ballerina
    bal new -t ballerinax/health.fhir.templates.r4.ccdatofhir_service <PROJECT_NAME>
    ```

2. Run the project.

    ```ballerina
    bal run
    ```

4. Invoke the API.

    Sample request format:

    ```
    curl --location 'http://<host>:<port>/transform' \ 
    --header 'Content-Type: application/xml' \
    --data-raw '<ClinicalDocument/>'
    ```
    