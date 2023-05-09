Ballerina FHIR Templates
==========================

The Ballerina FHIR templates can be used for creating FHIR APIs and EHR/EMR connection APIs. 

For more information, go to the module(s).
- [health.fhir.templates.r4.athenaconnect](r4/athena/Package.md)
- [health.fhir.templates.r4.cernerconnect](r4/cerner/Package.md)
- [health.fhir.templates.r4.metadata](r4/metadata/Package.md)
- [health.fhir.templates.r4.repositorysync](r4/repository-sync/Package.md)
- [health.fhir.templates.r4.diagnosticreport](r4/resource-apis/diagnosticReport/Package.md)
- [health.fhir.templates.r4.encounter](r4/resource-apis/encounter/Package.md)
- [health.fhir.templates.r4.observation](r4/resource-apis/observation/Package.md)
- [health.fhir.templates.r4.organization](r4/resource-apis/organization/Package.md)
- [health.fhir.templates.r4.patient](r4/resource-apis/patient/Package.md)
- [health.fhir.templates.r4.practitioner](r4/resource-apis/practitioner/Package.md)
- [health.fhir.templates.r4.servicerequest](r4/resource-apis/serviceRequest/Package.md)
- [health.fhir.templates.r4.uscore501.encounter](r4/resource-apis/uscore501-encounter/Package.md)
- [health.fhir.templates.r4.uscore501.patient](r4/resource-apis/uscore501-patient/Package.md)

## Building from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 11. You can install either [OpenJDK](https://adoptopenjdk.net/) or [Oracle](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html).

    > **Note:** Set the JAVA_HOME environment variable to the path name of the directory into which you installed JDK.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/). 

### Building the source

Execute the commands below to build from the source.

- To build a template (eg - to build the athena template):
    ```shell
    bal pack ./r4/athena
    ```

## Contributing to Ballerina

As an open source project, Ballerina welcomes contributions from the community. 

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* Discuss the code changes of the Ballerina project in [ballerina-dev@googlegroups.com](mailto:ballerina-dev@googlegroups.com).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
