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

import health.fhir.templates.r4.metadata.config;
import health.fhir.templates.r4.metadata.constants;
import health.fhir.templates.r4.metadata.handlers;
import health.fhir.templates.r4.metadata.models;
import ballerina/io;

# # metadata of server and rest components as configurables
configurable config:ServerInfo server_info = ?;
configurable config:Security security = {};

// TODO: uncomment below line when Choreo supports object arrays in configurable editor. 
// configurable config:Resource[] resources = ?;

# generator class for capability statement
public class CapabilityStatementGenerator {
    handlers:LogHandler logHandler;
    handlers:IssueHandler issueHandler;
    string resourcePath;

    public isolated function init(string resourcePath) {
        self.issueHandler = new ("CapabilityStatementGenerator");
        self.logHandler = new ("CapabilityStatementGenerator");
        self.logHandler.Debug("Generating capability statement initialized");
        self.resourcePath = resourcePath;
    }

    # method to build capability statement from metadata configurables
    # + return - capabilitity statement json object
    isolated function generate() returns models:CapabilityStatement|error {
        self.logHandler.Debug("Generating capability statement started");

        models:Implementation implementation = {
            description: server_info.implementation_description
        };

        string? implementationURL = server_info.implementation_url;

        if implementationURL is string {
            implementation.url = implementationURL;
        }

        models:CapabilityStatement capabilityStatement = {
            resourceType: constants:CAPABILITY_STATEMENT,
            status: server_info.status,
            date: server_info.date,
            kind: server_info.kind,
            implementation: implementation,
            fhirVersion: server_info.fhir_version,
            format: server_info.format,
            rest: []
        };

        string[]? patchFormats = server_info.patch_format;

        if patchFormats is string[] {
            capabilityStatement.patchFormat = patchFormats;
        }

        models:Coding seviceCoding = {
            system: constants:SERVICE_SYSTEM,
            code: constants:SERVICE_CODE,
            display: constants:SERVICE_DISPLAY
        };

        models:CodeableConcept securityService = {
            coding: [seviceCoding]
        };

        models:Extension tokenExtension = {
            url: constants:SECURITY_TOKEN,
            [constants:SECURITY_EXT_VALUEURL] : security.token_url
        };

        models:Extension revokeExtension = {
            url: constants:SECURITY_REVOKE,
            [constants:SECURITY_EXT_VALUEURL] : security.revoke_url
        };

        models:Extension authorizeExtension = {
            url: constants:SECURITY_AUTHORIZE,
            [constants:SECURITY_EXT_VALUEURL] : security.authorize_url
        };

        models:Extension introspectExtension = {
            url: constants:SECURITY_INTROSPECT,
            [constants:SECURITY_EXT_VALUEURL] : security.introspect_url
        };

        models:Extension registerExtension = {
            url: constants:SECURITY_REGISTER,
            [constants:SECURITY_EXT_VALUEURL] : security.register_url
        };

        models:Extension manageExtension = {
            url: constants:SECURITY_MANAGE,
            [constants:SECURITY_EXT_VALUEURL] : security.manage_url
        };

        models:Extension securityExtension = {
            url: constants:SECURITY_EXT_URL,
            extension: []
        };

        anydata[]? subExtensions = securityExtension.extension;
        if subExtensions is anydata[] {
            if tokenExtension[constants:SECURITY_EXT_VALUEURL] != () && tokenExtension[constants:SECURITY_EXT_VALUEURL] != "" {
                subExtensions.push(tokenExtension);
            }
            if revokeExtension[constants:SECURITY_EXT_VALUEURL] != () && revokeExtension[constants:SECURITY_EXT_VALUEURL] != "" {
                subExtensions.push(revokeExtension);
            }
            if authorizeExtension[constants:SECURITY_EXT_VALUEURL] != () && authorizeExtension[constants:SECURITY_EXT_VALUEURL] != "" {
                subExtensions.push(authorizeExtension);
            }
            if introspectExtension[constants:SECURITY_EXT_VALUEURL] != () && introspectExtension[constants:SECURITY_EXT_VALUEURL] != "" {
                subExtensions.push(introspectExtension);
            }
            if registerExtension[constants:SECURITY_EXT_VALUEURL] != () && registerExtension[constants:SECURITY_EXT_VALUEURL] != "" {
                subExtensions.push(registerExtension);
            }
            if manageExtension[constants:SECURITY_EXT_VALUEURL] != () && manageExtension[constants:SECURITY_EXT_VALUEURL] != "" {
                subExtensions.push(manageExtension);
            }
        }

        models:Security restSecurity = {
            cors: ()
        };

        boolean? cors = security["cors"];
        if cors is boolean {
            restSecurity.cors = cors;
        } else {
            self.logHandler.Debug(constants:NO_CORS);
        }

        restSecurity.'service = securityService;

        models:Extension[]? securityExtensions = [];
        if securityExtension.extension != [] {
            restSecurity.extension = [];
            securityExtensions = restSecurity.extension;
            if securityExtensions is models:Extension[] {
                securityExtensions.push(securityExtension);
            }
        }

        models:Rest rest = {
            mode: constants:REST_MODE_SERVER,
            security: restSecurity,
            'resource: []
        };

        self.logHandler.Debug("Populating resources");
        // TODO - Remove lines (128-136) when Choreo supports object arrays in configurable editor. 
        // Refer Issue: https://github.com/wso2-enterprise/open-healthcare/issues/847
        config:Resource[] resources = [];
        do {
            json resourcesJSON = check io:fileReadJson(self.resourcePath);
            resources = check resourcesJSON.cloneWithType();
        } on fail var err {
            self.logHandler.Debug("Populating resources failed");
            self.issueHandler.addServiceError(createServiceError(constants:ERROR, constants:NOT_FOUND, err));
        }
        //

        if resources.length() > 0 {
            foreach config:Resource resourceConfig in resources {

                models:Resource 'resource = {
                    'type: resourceConfig.'type
                };

                string[]? supportedProfile = resourceConfig.supportedProfiles;
                if supportedProfile is string[] {
                    'resource.supportedProfile = supportedProfile;
                } else {
                    self.logHandler.Debug(constants:NO_SUPPORTED_PROFILE);
                }

                'resource.interaction = [];
                models:Interaction[]? resourceInteractions = 'resource.interaction;
                string[]? interactions = resourceConfig.interactions;
                if interactions is string[] {
                    if resourceInteractions is models:Interaction[] {
                        foreach string interactionCode in interactions {
                            models:Interaction interaction = {
                                code: interactionCode
                            };
                            resourceInteractions.push(interaction);
                        }
                    } else {
                        self.logHandler.Debug(constants:NO_RESOURCE_INTERACTION);
                    }
                } else {
                    self.logHandler.Debug(constants:NO_RESOURCE_INTERACTION);
                }

                string? versioning = resourceConfig.versioning;
                if versioning is string {
                    'resource.versioning = versioning;
                } else {
                    self.logHandler.Debug(constants:NO_RESOURCE_VERSIONING);
                }

                boolean? conditionalCreate = resourceConfig.conditionalCreate;
                if conditionalCreate is boolean {
                    'resource.conditionalCreate = conditionalCreate;
                } else {
                    self.logHandler.Debug(constants:NO_RESOURCE_CONDITIONAL_CREATE);
                }

                string? conditionalRead = resourceConfig.conditionalRead;
                if conditionalRead is string {
                    'resource.conditionalRead = conditionalRead;
                } else {
                    self.logHandler.Debug(constants:NO_RESOURCE_CONDITIONAL_READ);
                }

                boolean? conditionalUpdate = resourceConfig.conditionalUpdate;
                if conditionalUpdate is boolean {
                    'resource.conditionalUpdate = conditionalUpdate;
                } else {
                    self.logHandler.Debug(constants:NO_RESOURCE_CONDITIONAL_UPDATE);
                }

                string? conditionalDelete = resourceConfig.conditionalDelete;
                if conditionalDelete is string {
                    'resource.conditionalDelete = conditionalDelete;
                } else {
                    self.logHandler.Debug(constants:NO_RESOURCE_CONDITIONAL_DELETE);
                }

                string[]? referencePolicies = 'resource.referencePolicy;
                string[]? referencePoliciesConfig = resourceConfig.referencePolicies;
                if referencePoliciesConfig is string[] {
                    if referencePolicies is string[] {
                        foreach string referencePolicy in referencePolicies {
                            referencePolicies.push(referencePolicy);
                        }
                    } else {
                        self.logHandler.Debug(constants:NO_RESOURCE_REFERENCE_POLICIES);
                    }
                } else {
                    self.logHandler.Debug(constants:NO_RESOURCE_REFERENCE_POLICIES);
                }

                string[]? searchRevIncludes = 'resource.searchRevInclude;
                string[]? searchRevIncludesConfig = resourceConfig.searchRevIncludes;
                if searchRevIncludesConfig is string[] {
                    if searchRevIncludes is string[] {
                        foreach string searchRevInclude in searchRevIncludesConfig {
                            searchRevIncludes.push(searchRevInclude);
                        }
                    } else {
                        self.logHandler.Debug(constants:NO_RESOURCE_SEARCHREV_INCLUDE);
                    }
                } else {
                    self.logHandler.Debug(constants:NO_RESOURCE_SEARCHREV_INCLUDE);
                }

                'resource.searchParam = [];
                models:SearchParam[]? resourceSearchParams = 'resource.searchParam;
                string[]? searchParamsConfig = resourceConfig.searchParamString;
                self.setSearchParam(resourceSearchParams, searchParamsConfig, constants:STRING);

                searchParamsConfig = resourceConfig.searchParamNumber;
                self.setSearchParam(resourceSearchParams, searchParamsConfig, constants:NUMBER);

                searchParamsConfig = resourceConfig.searchParamToken;
                self.setSearchParam(resourceSearchParams, searchParamsConfig, constants:TOKEN);

                searchParamsConfig = resourceConfig.searchParamDate;
                self.setSearchParam(resourceSearchParams, searchParamsConfig, constants:DATE);

                rest.interaction = [];
                models:Interaction[]? restInteractions = rest.interaction;
                string[]? restInteractionsConfig = server_info.interactions;
                if restInteractionsConfig is string[] {
                    if restInteractions is models:Interaction[] {
                        foreach string interactionCode in restInteractionsConfig {
                            models:Interaction interaction = {
                                code: interactionCode
                            };
                            restInteractions.push(interaction);
                        }
                    } else {
                        self.logHandler.Debug(constants:NO_REST_INTERACTIONS);
                    }
                } else {
                    self.logHandler.Debug(constants:NO_REST_INTERACTIONS);
                }

                models:Resource[]? restResources = rest.'resource;
                if restResources is models:Resource[] {
                    restResources.push('resource);
                }

                models:Rest[]? rests = capabilityStatement.rest;
                if rests is models:Rest[] {
                    rests.push(rest);
                }
            }
        } else {
            self.logHandler.Debug(constants:NO_FHIR_RESOURCES);
        }

        if self.issueHandler.getIssues().length() > 0 {
            models:Issue[] fatalIssues = from models:Issue issue in self.issueHandler.getIssues()
                where issue.severity == constants:ERROR || issue.severity == constants:EXCEPTION
                select issue;

            if fatalIssues.length() > 0 {
                self.logHandler.Debug("Generating capability statement failed");
                return error(constants:CAPABILITY_STATEMENT_FAILED);
            }
        }

        self.logHandler.Debug("Generating capability statement ended");
        return capabilityStatement;
    }

    # Set search param method
    #
    # + resourceSearchParamsRef - resource search params reference 
    # + params - search params  
    # + 'type - search params type
    isolated function setSearchParam(models:SearchParam[]? resourceSearchParamsRef, string[]? params, string 'type) {
        string[]? searchParamsConfig = params;
        if searchParamsConfig is string[] {
            if resourceSearchParamsRef is models:SearchParam[] {
                foreach string searchParamString in searchParamsConfig {
                    models:SearchParam searchParam = {
                        name: searchParamString,
                        'type: 'type.toString()
                    };
                    resourceSearchParamsRef.push(searchParam);
                }
            } else {
                self.logHandler.Debug(constants:NO_SEARCH_PARAMS + ": " + 'type);
            }
        } else {
            self.logHandler.Debug(constants:NO_SEARCH_PARAMS + ": " + 'type);
        }
    }
}
