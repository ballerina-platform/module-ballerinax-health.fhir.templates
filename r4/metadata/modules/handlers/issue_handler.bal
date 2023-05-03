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

import health.fhir.templates.r4.metadata.constants;
import health.fhir.templates.r4.metadata.models;

# Issue handler
public class IssueHandler {
    private LogHandler logHandler;
    private models:Issue[] issues;

    public isolated function init(string context) {
        self.logHandler = new (context);
        self.issues = [];
    }

    # Issue getter
    # + return - issues array
    public isolated function getIssues() returns models:Issue[] {
        return self.issues;
    }

    # Record service errors
    # + serviceError - service error
    public isolated function addServiceError(models:ServiceError serviceError) {

        models:Issue newIssue = {
            severity: serviceError.severity,
            code: serviceError.code,
            details: {
                text: constants:INTERNAL_SERVER_ERROR
            },
            diagnostics: serviceError.message
        };

        self.issues.push(newIssue);

        match newIssue.severity {
            constants:WARNING => {
                self.logHandler.Warn(serviceError.err.message());
            }
            constants:INFORMATION => {
                self.logHandler.Info(serviceError.err.message());
            }
            _ => {
                self.logHandler.Error(serviceError.err.stackTrace().toString());
            }
        }
    }
}
