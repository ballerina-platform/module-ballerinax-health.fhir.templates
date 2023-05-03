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

# Network configs
#
# + port - server port
public type Network record {|
    int port;
|};

# Configs for server
#
# + url - url  
# + 'version - FHIR server version  
# + name - server name  
# + title - server title  
# + status - server status  
# + experimental - experimental server or not  
# + date - last updated date  
# + kind - capability statement kind  
# + implementation_url - implementation url  
# + implementation_description - implementation description  
# + fhir_version - fhir version  
# + format - capability statement formats  
# + patch_format - patch format  
# + interactions - server interactions
public type ServerInfo record {|
    string url?;
    string 'version?;
    string name?;
    string title?;
    string status;
    boolean experimental?;
    string date;
    string kind;
    string implementation_url?;
    string implementation_description;
    string fhir_version;
    string[] format;
    string[] patch_format?;
    string[] interactions?;
|};

# Configs for server security
#
# + cors - server cors  
# + token_url - security token url  
# + revoke_url - security revoke url  
# + authorize_url - security authorize url  
# + introspect_url - oauth introspect url  
# + manage_url - Authorization management workflow entrypoint for the FHIR server  
# + register_url - dynamic client registration ep url
public type Security record {
    boolean cors?;
    string token_url?;
    string revoke_url?;
    string authorize_url?;
    string introspect_url?;
    string manage_url?;
    string register_url?;
};

# Configs for resource
#
# + 'type - resource type
# + versioning - resource versionig  
# + conditionalCreate - resource conditional create  
# + conditionalRead - resource conditional read
# + conditionalUpdate - resource conditional update  
# + conditionalDelete - resource conditional delete  
# + referencePolicies - reference policies  
# + searchInclude - resource search includes  
# + searchRevIncludes - search rev includes 
# + supportedProfiles - supported profiles
# + interactions - resource interactions  
# + searchParamNumber - number search params  
# + searchParamDate - date search params  
# + searchParamString - string search params  
# + searchParamToken - token search params  
# + searchParamReference - reference search params  
# + searchParamComposite - composite search params  
# + searchParamQuantity - quantity search params  
# + searchParamURI - uri search params  
# + searchParamSpecial - special search params
public type Resource record {
    string 'type;
    string versioning?;
    boolean conditionalCreate?;
    string conditionalRead?;
    boolean conditionalUpdate?;
    string conditionalDelete?;
    string[] referencePolicies?;
    string[] searchInclude?;
    string[] searchRevIncludes?;
    string[] supportedProfiles?;
    string[] interactions?;
    string[] searchParamNumber?;
    string[] searchParamDate?;
    string[] searchParamString?;
    string[] searchParamToken?;
    string[] searchParamReference?;
    string[] searchParamComposite?;
    string[] searchParamQuantity?;
    string[] searchParamURI?;
    string[] searchParamSpecial?;
};
