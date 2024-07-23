import ballerinax/health.fhir.cds;

# Handle decision service connectivity.
#
# + hookId - Id of the hook being invoked.
# + cdsRequest - CdsRequest to sent to the backend.
# + return - return CdsResponse or CdsError
isolated function submitForDecision(string hookId, cds:CdsRequest cdsRequest) returns cds:CdsResponse|cds:CdsError {

    // If needed, you can implement convertCdsRequestToDecisionServiceRequest method 
    // to transform CdsRequest to DecisionServiceRequest format
    // For this you can use the Ballerina data mapper: https://ballerina.io/learn/vs-code-extension/implement-the-code/data-mapper/
    anydata requestPayload = check convertCdsRequestToDecisionServiceRequest(cdsRequest);

    // Here you should implement the logic to connect decisiton service
    // Below is sample code
    // string decisionServiceUrl = "https://www.google.com";
    // http:Client fhirClient = check new (decisionServiceUrl);
    // anydata response = check fhirClient->post("/", requestPayload);
    anydata response = {};

    // convert to decision cards
    // you can implement convertDecisionServiceResponseToCdsCards method 
    // to transform DecisionServiceResponse to CdsCards
    // For this you can use the Ballerina data mapper: https://ballerina.io/learn/vs-code-extension/implement-the-code/data-mapper/
    cds:Card[] cards = [];
    cds:Card|cds:CdsError mapCustomResponseToCdsCardsResult = convertDecisionServiceResponseToCdsCards(response);

    // If neededyou can implement convertDecisionServiceResponseToCdsSystemActions method 
    // to transform DecisionServiceResponse to Cds system actions
    // For this you can use the Ballerina data mapper: https://ballerina.io/learn/vs-code-extension/implement-the-code/data-mapper/
    cds:Action[] systemActions = [];
    cds:Action|cds:CdsError mapCustomResponseToCdsSystemActionsResult = convertDecisionServiceResponseToCdsSystemActions(response);

    cds:CdsResponse cdsResponse = {
        cards: cards,
        systemActions: systemActions
    };
    return cdsResponse;
}

# Handle feedback service connectivity.
#
# + hookId - Id of the hook being invoked.
# + feedback - Feedback record to be processed.
# + return - return CdsError, if any.
isolated function submitFeedback(string hookId, cds:Feedbacks feedback) returns cds:CdsError? {
    return cds:createCdsError("Rule respository backend not implemented/ connected yet", 501);
}

isolated function convertCdsRequestToDecisionServiceRequest(cds:CdsRequest cdsRequest) returns anydata|cds:CdsError => {};

isolated function convertDecisionServiceResponseToCdsCards(anydata payload) returns cds:Card|cds:CdsError => {summary: "", indicator: "", 'source: {label: ""}};

isolated function convertDecisionServiceResponseToCdsSystemActions(anydata payload) returns cds:Action|cds:CdsError => {'type: "delete", description: ""};

