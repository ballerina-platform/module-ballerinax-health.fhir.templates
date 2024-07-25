import thiyanarumugam/health.fhir.cds;

# Handle decision service connectivity.
# 1. Map the received CdsRequest to the custom payload format, if needed (Optional).
# 2. Implement the connectivity with your external decision support system.
# 3. Send the CdsRequest to external system.
# 4. Get the reponse.
# 5. Map the received response to the CdsCards and Cds actions.
# 6. Return the CdsResponse.
#
# + hookId - Id of the hook being invoked.
# + cdsRequest - CdsRequest to sent to the backend.
# + return - return CdsResponse or CdsError
isolated function submitForDecision(string hookId, cds:CdsRequest cdsRequest) returns cds:CdsResponse|cds:CdsError {

    // // If needed, you can implement mapCdsRequestToDecisionServiceRequest method to 
    // // transform CdsRequest to DecisionServiceRequest format
    // // For this you can use the Ballerina data mapper: https://ballerina.io/learn/vs-code-extension/implement-the-code/data-mapper/
    // anydata requestPayload = check mapCdsRequestToDecisionServiceRequest(cdsRequest);

    // // Here you should implement the logic to connect decisiton service
    // // Below is sample code
    // string decisionServiceUrl = "https://www.google.com";
    // http:Client|http:ClientError httpClient = new (decisionServiceUrl);
    // if (httpClient is http:ClientError) {
    //     return cds:createCdsError(httpClient.message(), 500);
    // }

    // anydata|http:ClientError response = httpClient->post("/", requestPayload.toJson());
    // if (response is http:ClientError) {
    //     return cds:createCdsError(response.message(), 500);
    // }

    // // map the received response to decision cards
    // // you can implement the mapDecisionServiceResponseToCdsCards method to
    // // transform DecisionServiceResponse to CdsCards
    // // For this you can use the Ballerina data mapper: https://ballerina.io/learn/vs-code-extension/implement-the-code/data-mapper/
    // cds:Card[] cards = [];
    // cds:Card|cds:CdsError card = mapDecisionServiceResponseToCdsCards(response);
    // if (card is cds:Card) {
    //     cards.push(card);
    // }

    // // If neededyou can implement mapDecisionServiceResponseToCdsSystemActions method to
    // // transform DecisionServiceResponse to Cds system actions
    // // For this you can use the Ballerina data mapper: https://ballerina.io/learn/vs-code-extension/implement-the-code/data-mapper/
    // cds:Action[] systemActions = [];
    // cds:Action|cds:CdsError systemAction = mapDecisionServiceResponseToCdsSystemActions(response);
    // if (systemAction is cds:Action) {
    //     systemActions.push(systemAction);
    // }

    // cds:CdsResponse cdsResponse = {
    //     cards: cards,
    //     systemActions: systemActions
    // };

    cds:CdsResponse cdsResponse = {
        cards: [],
        systemActions: []
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

isolated function mapCdsRequestToDecisionServiceRequest(cds:CdsRequest cdsRequest) returns anydata|cds:CdsError => {};

isolated function mapDecisionServiceResponseToCdsCards(anydata payload) returns cds:Card|cds:CdsError => {summary: "", indicator: "", 'source: {label: ""}};

isolated function mapDecisionServiceResponseToCdsSystemActions(anydata payload) returns cds:Action|cds:CdsError => {'type: "delete", description: ""};

