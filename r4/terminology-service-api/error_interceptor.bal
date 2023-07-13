import ballerina/http;
import ballerina/log;
import ballerinax/health.fhir.r4;
import ballerina/uuid;

public isolated service class FHIRResponseErrorInterceptor {
    *http:ResponseErrorInterceptor;

    remote isolated function interceptResponseError(error err) returns http:StatusCodeResponse {
        log:printDebug("Execute: FHIR Response Error Interceptor");

        string errorUUID;
        if err is r4:FHIRError {
            r4:FHIRErrorDetail & readonly detail = err.detail();
            if (!detail.internalError) {
                return self.createHttpErrorResponse(err);
            } else {
                //TODO log the error if it is an internal error
                errorUUID = err.detail().uuid;
                log:printError(string `${errorUUID} : ${err.message()}`, err, err.stackTrace());
            }
        } else {
            // TODO log the error since it is not an FHIR related error
            errorUUID = uuid:createType1AsString();
            log:printError(string `${errorUUID} : ${err.message()}`, err, err.stackTrace());
        }
        r4:OperationOutcome opOutcome = {
            issue: [
                {
                    severity: r4:ERROR,
                    code: r4:PROCESSING,
                    diagnostics: errorUUID
                }
            ]
        };
        http:InternalServerError internalError = {
            body: opOutcome
        };
        return internalError;
    }

    isolated function createHttpErrorResponse(r4:FHIRError fhirError) returns http:InternalServerError|http:BadRequest|http:NotFound {
        r4:FHIRErrorDetail & readonly detail = fhirError.detail();
        r4:OperationOutcome operationOutcome = r4:errorToOperationOutcome(fhirError);
        match detail.httpStatusCode {
            http:STATUS_BAD_REQUEST => {
                http:BadRequest badRequest = {
                    body: operationOutcome
                };
                return badRequest;
            }
            http:STATUS_NOT_FOUND => {
                http:NotFound notFound = {
                    body: operationOutcome
                };
                return notFound;
            }
            _ => {
                http:InternalServerError internalServerError = {
                    body: operationOutcome
                };
                return internalServerError;
            }
        }
    }
}
