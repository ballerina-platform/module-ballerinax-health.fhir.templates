// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com).

// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/time;
import ballerina/io;
import ballerinax/health.fhir.r4;

# # metadata of server and rest components as configurables
configurable ConfigFHIRServer configFHIRServer = ?;
configurable ConfigRest configRest = {};

// TODO: uncomment below line when Choreo supports object arrays in configurable editor. 
// configurable config:Resource[] resources = ?;
string resourcePath = "";

# Generate capability statement from configurables.
# 
# + return - capabilitity statement object
isolated function generateCapabilityStatement() returns r4:CapabilityStatement|error {
    LogDebug("Generating capability statement started");

    r4:CapabilityStatementStatus capabilityStatementStatus = check configFHIRServer.status.ensureType(r4:CapabilityStatementStatus);
    r4:CapabilityStatementKind capabilityStatementKind = check configFHIRServer.kind.ensureType(r4:CapabilityStatementKind);

    r4:CapabilityStatementFormat[] capabilityStatementFormat = [];
    foreach string configFormat in configFHIRServer.format {
        r4:CapabilityStatementFormat format = check configFormat.ensureType(r4:CapabilityStatementFormat);
        capabilityStatementFormat.push(format);
    }

    string capabilityStatementDate;
    string? date = configFHIRServer.date;
    if date is string {
        capabilityStatementDate = date;
    } else {
        time:Civil dateTimeCivil =  time:utcToCivil(time:utcNow());
        capabilityStatementDate = string `${dateTimeCivil.year}-${dateTimeCivil.month}-${dateTimeCivil.day}`;
    }

    r4:CapabilityStatement capabilityStatement = {
        status: capabilityStatementStatus,
        date: capabilityStatementDate,
        kind: capabilityStatementKind,
        fhirVersion: configFHIRServer.fhirVersion,
        format: capabilityStatementFormat
    };

    r4:CapabilityStatementImplementation capabilityStatementImplementation = {
        description: configFHIRServer.implementationDescription,
        url: configFHIRServer.implementationUrl
    };
    capabilityStatement.implementation = capabilityStatementImplementation;

    r4:code[] patchFormat = [];
    string[]? configPatchFormat = configFHIRServer.patchFormat;
    if configPatchFormat is string[] {
        foreach string configPatchFormatItem in configPatchFormat {
            r4:code patchFormatItem = check configPatchFormatItem.ensureType(r4:code);
            patchFormat.push(patchFormatItem);
        }
        capabilityStatement.patchFormat = patchFormat;
    }

    r4:CapabilityStatementRest? capabilityStatementRest = check populateCapabilityStatementRest();
    if capabilityStatementRest is r4:CapabilityStatementRest {
        capabilityStatement.rest = [capabilityStatementRest];
    } else {
        LogDebug(string `${VALUE_NOT_FOUND}: capabilityStatementRest`);
    }

    LogDebug("Generating capability statement ended");
    return capabilityStatement;
}

# populate capability statement rest component from configurables.
# 
# + return - capability statement rest object
isolated function populateCapabilityStatementRest() returns r4:CapabilityStatementRest?|error {
    r4:CapabilityStatementRest rest = {
        mode: REST_MODE_SERVER
    };

    r4:CapabilityStatementRestSecurity? restSecurity = check populateCapabilityStatementRestSecurity();
    if restSecurity is r4:CapabilityStatementRestSecurity {
        rest.security = restSecurity;
    } else {
        LogDebug(string `${VALUE_NOT_FOUND}: restSecurity`);
    }

    r4:CapabilityStatementRestResourceInteraction[] restInteraction = [];
    string[]? configRestInteraction = configRest.interaction;
    if configRestInteraction is string[] {
        foreach string configInteractionCode in configRestInteraction {
            r4:CapabilityStatementRestResourceInteractionCode interactionCode = check configInteractionCode.ensureType(r4:CapabilityStatementRestResourceInteractionCode);
            r4:CapabilityStatementRestResourceInteraction interaction = {
                code: interactionCode
            };
            restInteraction.push(interaction);           
        }
        rest.interaction = restInteraction;
    } else {
        LogDebug(VALUE_NOT_FOUND);
    }

    r4:CapabilityStatementRestResource[]? restResources = check populateCapabilityStatementRestResources(configRest.resourceFilePath);
    if restResources is r4:CapabilityStatementRestResource[] {
        rest.'resource = restResources;
    } else {
        LogDebug(string `${VALUE_NOT_FOUND}: restResources`);
    }
    return rest;
}

# populate capability statement rest security component from configurables.
# 
# + return - capability statement rest security object
isolated function populateCapabilityStatementRestSecurity() returns r4:CapabilityStatementRestSecurity?|error {
    r4:CapabilityStatementRestSecurity restSecurity = {};

    boolean? cors = configRest.security["cors"];
    if cors is boolean {
        restSecurity.cors = cors;
    } else {
        LogDebug(string `${VALUE_NOT_FOUND}: cors`);
    }

    r4:Coding seviceCoding = {
        system: SERVICE_SYSTEM,
        code: SERVICE_CODE,
        display: SERVICE_DISPLAY
    };

    r4:CodeableConcept securityService = {
        coding: [seviceCoding]
    };

    restSecurity.'service = [securityService];

    r4:ExtensionExtension securityExtension = {
        url: SECURITY_EXT_URL
    };
    r4:Extension[] nestedExtensions = [];

    OpenIDConfiguration openIdConfigurations = {};
    string? discoveryEndpoint = configRest.security?.discoveryEndpoint;
    if discoveryEndpoint is string && discoveryEndpoint != "" {
        openIdConfigurations = check getOpenidConfigurations(discoveryEndpoint).cloneReadOnly();
    } else {
        LogDebug(string `${VALUE_NOT_FOUND}: discoveryEndpoint`);
    }

    string? configTokenEndpoint = configRest.security?.tokenEndpoint;
    populateSecurityExtensions(nestedExtensions, SECURITY_TOKEN, openIdConfigurations.token_endpoint, configTokenEndpoint);

    string? configAuthorizeEndpoint = configRest.security?.authorizeEndpoint;
    populateSecurityExtensions(nestedExtensions, SECURITY_AUTHORIZE, openIdConfigurations.authorization_endpoint, configAuthorizeEndpoint);

    string? configIntrospectEndpoint = configRest.security?.introspectEndpoint;
    populateSecurityExtensions(nestedExtensions, SECURITY_INTROSPECT, openIdConfigurations.introspection_endpoint, configIntrospectEndpoint);

    string? configRevokeEndpoint = configRest.security?.revocationEndpoint;
    populateSecurityExtensions(nestedExtensions, SECURITY_REVOKE, openIdConfigurations.revocation_endpoint, configRevokeEndpoint);

    string? configRegistrationEndpoint = configRest.security?.registrationEndpoint;
    populateSecurityExtensions(nestedExtensions, SECURITY_REGISTER, openIdConfigurations.registration_endpoint, configRegistrationEndpoint);

    string? confingManagementEndpoint = configRest.security?.managementEndpoint;
    populateSecurityExtensions(nestedExtensions, SECURITY_MANAGE, openIdConfigurations.management_endpoint, confingManagementEndpoint);

    if nestedExtensions.length() > 0 {
        securityExtension.extension = nestedExtensions;
        restSecurity.extension = [securityExtension];
    }
    return restSecurity;
}

isolated function populateSecurityExtensions(r4:Extension[] extensions, string extensionUrl, string? endpointOpenid, string? configEndpoint) {
    string? endpoint = ();
    if endpointOpenid is string {
        endpoint = endpointOpenid;
    } else {
        LogDebug(string `${VALUE_NOT_FOUND}: ${extensionUrl} in Openid configuration`);
        if configEndpoint is string {
            endpoint = configEndpoint;
        } else {
            LogDebug(string `${VALUE_NOT_FOUND}: ${extensionUrl}`);
        }
    }

    if endpoint is string {
        r4:Extension securityExtension = {
            url: extensionUrl,
            valueUrl: endpoint.toString()
        };
        extensions.push(securityExtension);
    }
}

# populate capability statement rest resources component from configurables.
#
# + resourceFilePath - resource file path
# + return - capability statement rest resources list
isolated function populateCapabilityStatementRestResources(string? resourceFilePath = ()) returns r4:CapabilityStatementRestResource[]?|error {
    LogDebug("Populating resources");

    r4:CapabilityStatementRestResource[] resources = [];

    // TODO - Fix line 256, when Choreo supports object arrays in configurable editor. 
    // Refer Issue: https://github.com/wso2-enterprise/open-healthcare/issues/847
    ConfigResource[] configResources = [];
    string? filePath = resourceFilePath;
    if filePath is string {
        json resourcesJSON = check io:fileReadJson(filePath);
        configResources = check resourcesJSON.cloneWithType();
        LogDebug(string `Resource file path: ${filePath}`);
    } else {
        LogDebug(string `${VALUE_NOT_FOUND}: resourceFilePath`);
        return;
    }

    if configResources.length() > 0 {
        foreach ConfigResource configResource in configResources {

            r4:CapabilityStatementRestResource 'resource = {
                'type: configResource.'type
            };

            string[]? supportedProfile = configResource.supportedProfile;
            if supportedProfile is string[] {
                'resource.supportedProfile = supportedProfile;
            } else {
                LogDebug(string `${VALUE_NOT_FOUND}: supportedProfile`);
            }

            r4:CapabilityStatementRestResourceInteraction[] resourceInteraction = [];
            string[]? configInteraction = configResource.interaction;
            if configInteraction is string[] {
                foreach string configInteractionCode in configInteraction {
                    r4:CapabilityStatementRestResourceInteractionCode interactionCode = check configInteractionCode.ensureType(r4:CapabilityStatementRestResourceInteractionCode);
                    r4:CapabilityStatementRestResourceInteraction interaction = {
                        code: interactionCode
                    };
                    resourceInteraction.push(interaction);
                }
                'resource.interaction = resourceInteraction;
            } else {
                LogDebug(string `${VALUE_NOT_FOUND}: resourceInteraction`);
            }

            string? configVersioning = configResource.versioning;
            if configVersioning is string {
                r4:CapabilityStatementRestResourceVersioning versioning = check configVersioning.ensureType(r4:CapabilityStatementRestResourceVersioning);
                'resource.versioning = versioning;
            } else {
                LogDebug(string `${VALUE_NOT_FOUND}: versioning`);
            }

            boolean? conditionalCreate = configResource.conditionalCreate;
            if conditionalCreate is boolean {
                'resource.conditionalCreate = conditionalCreate;
            } else {
                LogDebug(string `${VALUE_NOT_FOUND}: conditionalCreate`);
            }

            string? configConditionalRead = configResource.conditionalRead;
            if configConditionalRead is string {
                r4:CapabilityStatementRestResourceConditionalRead conditionalRead = check configConditionalRead.ensureType(r4:CapabilityStatementRestResourceConditionalRead);
                'resource.conditionalRead = conditionalRead;
            } else {
                LogDebug(string `${VALUE_NOT_FOUND}: conditionalRead`);
            }

            boolean? conditionalUpdate = configResource.conditionalUpdate;
            if conditionalUpdate is boolean {
                'resource.conditionalUpdate = conditionalUpdate;
            } else {
                LogDebug(string `${VALUE_NOT_FOUND}: conditionalUpdate`);
            }

            
            string? configConditionalDelete = configResource.conditionalDelete;
            if configConditionalDelete is string {
                r4:CapabilityStatementRestResourceConditionalDelete conditionalDelete = check configConditionalDelete.ensureType(r4:CapabilityStatementRestResourceConditionalDelete);
                'resource.conditionalDelete = conditionalDelete;
            } else {
                LogDebug(string `${VALUE_NOT_FOUND}: conditionalDelete`);
            }

            r4:CapabilityStatementRestResourceReferencePolicy[] referencePolicy = [];
            string[]? configReferencePolicy = configResource.referencePolicy;
            if configReferencePolicy is string[] {
                foreach string configReferencePolicyItem in configReferencePolicy {
                    r4:CapabilityStatementRestResourceReferencePolicy referencePolicyItem = check configReferencePolicyItem.ensureType(r4:CapabilityStatementRestResourceReferencePolicy);
                    referencePolicy.push(referencePolicyItem);
                }
                'resource.referencePolicy = referencePolicy;
            } else {
                LogDebug(string `${VALUE_NOT_FOUND}: referencePolicy`);
            }

            string[] searchRevInclude = [];
            string[]? configSearchRevIncludes = configResource.searchRevInclude;
            if configSearchRevIncludes is string[] {
                foreach string configSearchRevIncludeItem in configSearchRevIncludes {
                    searchRevInclude.push(configSearchRevIncludeItem);
                }
                'resource.searchRevInclude = searchRevInclude;
            } else {
                LogDebug(string `${VALUE_NOT_FOUND}: searchRevInclude`);
            }

            r4:CapabilityStatementRestResourceSearchParam[] resourceSearchParams = [];
            do {
                string[]? configStringParams = configResource.searchParamString;
                r4:CapabilityStatementRestResourceSearchParam[] stringSearchParams = check populateSearchParams(configStringParams, r4:CODE_TYPE_STRING);
                resourceSearchParams.push(...stringSearchParams);

                string[]? configNumberParams = configResource.searchParamNumber;
                r4:CapabilityStatementRestResourceSearchParam[] numberSearchParams = check populateSearchParams(configNumberParams, r4:CODE_TYPE_NUMBER);
                resourceSearchParams.push(...numberSearchParams);

                string[]? configDateParams = configResource.searchParamDate;
                r4:CapabilityStatementRestResourceSearchParam[] dateSearchParams = check populateSearchParams(configDateParams, r4:CODE_TYPE_DATE);
                resourceSearchParams.push(...dateSearchParams);

                string[]? configTokenParams = configResource.searchParamToken;
                r4:CapabilityStatementRestResourceSearchParam[] tokenSearchParams = check populateSearchParams(configTokenParams, r4:CODE_TYPE_TOKEN);
                resourceSearchParams.push(...tokenSearchParams);

                string[]? configReferenceParams = configResource.searchParamReference;
                r4:CapabilityStatementRestResourceSearchParam[] referenceSearchParams = check populateSearchParams(configReferenceParams, r4:CODE_TYPE_REFERENCE);
                resourceSearchParams.push(...referenceSearchParams);

                string[]? configCompositeParams = configResource.searchParamComposite;
                r4:CapabilityStatementRestResourceSearchParam[] compositeSearchParams = check populateSearchParams(configCompositeParams, r4:CODE_TYPE_COMPOSITE);
                resourceSearchParams.push(...compositeSearchParams);

                string[]? configQuantityParams = configResource.searchParamQuantity;
                r4:CapabilityStatementRestResourceSearchParam[] quantitySearchParams = check populateSearchParams(configQuantityParams, r4:CODE_TYPE_QUANTITY);
                resourceSearchParams.push(...quantitySearchParams);

                string[]? configUriParams = configResource.searchParamURI;
                r4:CapabilityStatementRestResourceSearchParam[] uriSearchParams = check populateSearchParams(configUriParams, r4:CODE_TYPE_URI);
                resourceSearchParams.push(...uriSearchParams);

                string[]? configSpecialParams = configResource.searchParamSpecial;
                r4:CapabilityStatementRestResourceSearchParam[] specialSearchParams = check populateSearchParams(configSpecialParams, r4:CODE_TYPE_SPECIAL);
                resourceSearchParams.push(...specialSearchParams);

                'resource.searchParam = resourceSearchParams;
            } on fail var err {
                return err;
            }
            resources.push('resource);
        }
    } else {
        LogDebug(string `${VALUE_NOT_FOUND}: restResources`);
        return;
    }
    return resources;
}

# Populate search params
#
# + configSearchParams - search params from config
# + 'type - search param type
# + return - search params
isolated function populateSearchParams(string[]? configSearchParams, r4:CapabilityStatementRestResourceSearchParamType 'type) returns r4:CapabilityStatementRestResourceSearchParam[]|error {
    r4:CapabilityStatementRestResourceSearchParam[] searchParams = [];
    r4:CapabilityStatementRestResourceSearchParam[]? typeSearchParams = check populateSearchParamType(configSearchParams, 'type);
    if typeSearchParams is r4:CapabilityStatementRestResourceSearchParam[] {
        searchParams.push(...typeSearchParams);
    } else {
        LogDebug(string `${VALUE_NOT_FOUND}: searchParams: ${'type}`);
    }
    return searchParams;
}

# Populate search param type.
#
# + configTypeSearchParams - config type search params
# + configSearchParamType - config search param type
# + return - search params
isolated function populateSearchParamType(string[]? configTypeSearchParams, string configSearchParamType) returns r4:CapabilityStatementRestResourceSearchParam[]?|error {
    r4:CapabilityStatementRestResourceSearchParam[] searchParams = [];
    if configTypeSearchParams is string[] {
        foreach string configTypeSearchParam in configTypeSearchParams {
            r4:CapabilityStatementRestResourceSearchParamType searchParamType = check configSearchParamType.ensureType(r4:CapabilityStatementRestResourceSearchParamType);
            r4:CapabilityStatementRestResourceSearchParam searchParam = {
                name: configTypeSearchParam,
                'type: searchParamType
            };
            searchParams.push(searchParam);
        }
    } else {
        return;
    }
    return searchParams;
}
