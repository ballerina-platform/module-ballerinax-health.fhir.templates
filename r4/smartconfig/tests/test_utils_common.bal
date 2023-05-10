// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.

// This software is the property of WSO2 LLC. and its suppliers, if any.
// Dissemination of any information or reproduction of any material contained
// herein is strictly forbidden, unless permitted by WSO2 in accordance with
// the WSO2 Software License available at: https://wso2.com/licenses/eula/3.2
// For specific language governing the permissions and limitations under
// this license, please see the license as well as any agreement you’ve
// entered into with WSO2 governing the purchase of this software and any
// associated services.

import ballerina/test;

@test:Config { groups: ["Handler"] }
function testLogHandlerDebug() {
    LogDebug("This is a test debug");
    LogInfo("This is a test info");
    LogWarn("This is a test warn");
    LogError(error("This is a test error"));
    test:assertTrue(true, "Debug log success");
}
