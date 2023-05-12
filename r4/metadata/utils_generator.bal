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

import ballerina/http;
import ballerina/url;

# Call the discovery endpoint to get the OpenID configuration.
#
# + discoveryEndpoint - Discovery endpoint
# + return - If successful, returns OpenID configuration as a json. Else returns error.
public isolated function getOpenidConfigurations(string discoveryEndpoint) returns OpenIDConfiguration|error {
    LogDebug("Retrieving openid configuration started");
    string discoveryEndpointUrl = check url:decode(discoveryEndpoint, "UTF8");
    http:Client discoveryEpClient = check new (discoveryEndpointUrl.toString());
    OpenIDConfiguration openidConfiguration = check discoveryEpClient -> get("/");
    LogDebug("Retrieving openid configuration ended");
    return openidConfiguration;
}
