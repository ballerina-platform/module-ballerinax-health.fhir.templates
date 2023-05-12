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

# Debug logger.
# 
# + msg - debug message 
public isolated function LogDebug(string msg) {
    log:printDebug(msg);
}

# Error logger.
#
# + err - error to be logged
public isolated function LogError(error err) {
    log:printError(err.message(), stacktrace = err.stackTrace().toString());
}

# Info logger.
# 
# + msg - info message 
public isolated function LogInfo(string msg) {
    log:printInfo(msg);
}

# Warn logger.
# 
# + msg - warn message 
public isolated function LogWarn(string msg) {
    log:printWarn(msg);
}
