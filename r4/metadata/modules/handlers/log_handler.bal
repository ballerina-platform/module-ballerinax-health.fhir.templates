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

import ballerina/log;

# Log Handler Class
public class LogHandler {
    private string context;

    public isolated function init(string context) {
        self.context = context;
    }

    # Debug logger
    # + msg - debug message 
    public isolated function Debug(string msg) {
        log:printDebug(string `${self.context}: ${msg}`);
    }

    # Error logger
    # + msg - error message 
    public isolated function Error(string msg) {
        log:printError(string `${self.context}: ${msg}`);
    }

    # Info logger
    # + msg - info message 
    public isolated function Info(string msg) {
        log:printInfo(string `${self.context}: ${msg}`);
    }

    # Warn logger
    # + msg - warn message 
    public isolated function Warn(string msg) {
        log:printWarn(string `${self.context}: ${msg}`);
    }
}
