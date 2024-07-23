import ballerina/constraint;
import ballerina/http;
import ballerinax/health.fhir.cds;

service http:InterceptableService / on new http:Listener(8081) {

    public function createInterceptors() returns ResponseErrorInterceptor {
        return new ResponseErrorInterceptor();
    }

    # Discovery endpoint.
    #
    # + return - return CDS hook definition
    isolated resource function get cds\-services() returns http:Response {
        http:Response response = new ();
        if (cds:cds_services.count() > 0) {
            cds:Services services = {services: cds:cds_services};
            response.setJsonPayload(services);
        } else {
            response.setJsonPayload([]);
        }
        return response;

    }

    # Service endpoint.
    #
    # + hook_id - Registered id of the hook being invoked
    # + cdsRequest - cds request payload
    # + return - Clinical decisions as array of CDS cards
    isolated resource function post cds\-services/[string hook_id](@http:Payload cds:CdsRequest cdsRequest) returns http:Response {

        // Check whether user requested Hook with the hook_id is in the registered CDS services list
        if (cds:cds_services.filter(s => s.id == hook_id).length() > 0) {
            cds:CdsService cdsService = <cds:CdsService>cds:cds_services.filter(s => s.id == hook_id)[0];

            cds:CdsRequest|constraint:Error validate = constraint:validate(cdsRequest, cds:CdsRequest);
            if validate is constraint:Error {
                string message = validate.message();
                int statusCode = 400;
                cds:CdsError cdsError = cds:createCdsError(message, statusCode);
                return cds:cdsErrorToHttpResponse(cdsError);
            }

            if (cdsRequest.hook != cdsService.hook) {
                string message = string `CDS service ${hook_id} is a not type of ${cdsRequest.hook}. It should be ${cdsService.hook} type hook`;
                int statusCode = 400;
                cds:CdsError cdsError = cds:createCdsError(message, statusCode);
                return cds:cdsErrorToHttpResponse(cdsError);
            }

            //Do context validation
            cds:CdsError? contextValidated = cds:validateContext(cdsRequest, cdsService);
            if contextValidated is cds:CdsError {
                return cds:cdsErrorToHttpResponse(contextValidated);
            }

            //Do Prefetch FHIR data validation
            cds:CdsRequest|cds:CdsError validationResult = cds:validateAndProcessPrefetch(cdsRequest, cdsService);
            if validationResult is cds:CdsError {
                return cds:cdsErrorToHttpResponse(validationResult);
            }

            //Connect with decision support system implementation
            cds:CdsResponse|cds:CdsError cdsResponse = submitForDecision(hook_id, cdsRequest);
            if cdsResponse is cds:CdsError {
                return cds:cdsErrorToHttpResponse(cdsResponse);
            } else {
                cds:CdsResponse|constraint:Error validateResult = constraint:validate(cdsResponse, cds:CdsResponse);
                if validateResult is constraint:Error {
                    string message = validateResult.message();
                    int statusCode = 400;
                    cds:CdsError cdsError = cds:createCdsError(message, statusCode);
                    return cds:cdsErrorToHttpResponse(cdsError);
                }

                http:Response response = new ();
                response.setJsonPayload(cdsResponse.toJson());
                return response;
            }
        } else {
            string message = string `Can not find a cds service with the name: ${hook_id}`;
            int statusCode = 404;
            cds:CdsError cdsError = cds:createCdsError(message, statusCode);
            return cds:cdsErrorToHttpResponse(cdsError);
        }
    }

    # Feedack endpoint.
    #
    # + hook_id - Registered Id of the hook being invoked
    # + feedback - cds feedback payload
    # + return - return success message
    isolated resource function post cds\-services/[string hook_id]/feedback(@http:Payload cds:Feedbacks feedback) returns http:Response {
        cds:CdsError? result = submitFeedback(hook_id, feedback);

        http:Response response = new ();
        if (result is error) {
            return cds:cdsErrorToHttpResponse(result);
        }
        return response;
    }
}
