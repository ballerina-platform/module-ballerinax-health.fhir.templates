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

import health.fhir.templates.r4.smartconfiguration.handlers;
import health.fhir.templates.r4.smartconfiguration.constants;
import health.fhir.templates.r4.smartconfiguration.models;

configurable models:SmartConfiguration smart_configuration = ?;

# The generator class for the Smart Configuration
public class SmartConfigurationGenerator {
    handlers:LogHandler logHandler;
    handlers:IssueHandler issueHandler;

    public isolated function init() {
        self.issueHandler = new ("SmartConfigurationGenerator");
        self.logHandler = new ("SmartConfigurationGenerator");
        self.logHandler.Debug("Generating smart configuration initialized");
    }

    # Generator function for Smart Configuration
    # + return - smart configuration as a json or an error
    public isolated function generate() returns models:SmartConfiguration|error {
        self.logHandler.Debug("Generating smart configuration started");

        models:SmartConfiguration|error smartConfig = {
            ...smart_configuration
        };

        if smartConfig is error {
            self.issueHandler.addServiceError(createServiceError(constants:ERROR, constants:VALUE, smartConfig));
        }

        self.logHandler.Debug("Completed generating smart configuration");
        return smartConfig;
    }
}
