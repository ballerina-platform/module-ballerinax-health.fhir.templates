# FHIR SMART Configuration API Template

## Template Overview
This API template provides API implementation of 
[SMART Discovery API](https://www.hl7.org/fhir/smart-app-launch/#discovery-of-server-capabilities-and-configuration) 
of a FHIR server.

SMART defines a discovery document available at `.well-known/smart-configuration` relative to a FHIR Server Base URL, 
allowing clients to learn the authorization endpoint URLs and features a server supports. This information helps client 
direct authorization requests to the right endpoint, and helps clients construct an authorization request that the server 
can support.

|                      |                                                            |
|----------------------|------------------------------------------------------------|
| FHIR                 | R4                                                         |
| Implementation Guide | http://hl7.org/fhir/                                       |
| Specification        | https://www.hl7.org/fhir/smart-app-launch/conformance.html |
