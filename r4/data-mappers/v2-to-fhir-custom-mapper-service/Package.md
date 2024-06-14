# V2 to FHIR Custom Mapper Service

## Service Overview
This service template provides a way to customize the mappings implemented from the [HL7V2 to FHIR R4 Service](https://github.com/wso2/open-healthcare-prebuilt-services/tree/main/transformation/v2-to-fhirr4-service). This service is  included with REST resources to add custom mappings related to HL7 v2 segments to FHIR resources. Developers can add custom mappings by implementing the resource functions defined for each segment in the service.

## Prerequisites

Pull the template from central

```bash
$ bal new -t ballerinax/health.fhir.templates.r4.v2tofhircustomsvc V2ToFHIRCustomMapperService
```

## Run the template

- Run the Ballerina project created by the service template.
    ```ballerina
    bal run
    ```
- Once successfully executed, Listener will be started at port 9091. Then your service can be invoked from [HL7V2 to FHIR R4 Service](https://github.com/wso2/open-healthcare-prebuilt-services/tree/main/transformation/v2-to-fhirr4-service) from the configurations mentioned under the `Customization` section.