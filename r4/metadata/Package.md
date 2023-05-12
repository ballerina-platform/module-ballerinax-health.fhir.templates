# FHIR Capability Statement API Template

## Template Overview
This API template provides implementation of FHIR Metadata API. This implements 
[capabilities](https://www.hl7.org/fhir/http.html#capabilities) interaction, which is used to retrieve capability 
statement describing the server's current operational functionality by FHIR client applications. 

This FHIR server interaction returns Capability Statement ([CapabilityStatement](http://hl7.org/fhir/StructureDefinition/CapabilityStatement) 
FHIR resource) that specifies which resource types and interactions are supported by the FHIR server


|                       |                                                    |
|-----------------------|----------------------------------------------------|
| FHIR                  | R4                                                 |
| Implementation Guide  | http://hl7.org/fhir/                               |
| Profile | http://hl7.org/fhir/StructureDefinition/CapabilityStatement      |
| Documentation | https://www.hl7.org/fhir/capabilitystatement.html          |
