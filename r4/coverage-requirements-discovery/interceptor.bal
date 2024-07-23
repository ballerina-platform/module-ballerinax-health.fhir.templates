import ballerina/http;
import ballerina/lang.regexp;

service class ResponseErrorInterceptor {
    *http:ResponseErrorInterceptor;

    remote function interceptResponseError(error err, http:Response response) returns http:Response {
        if (response.statusCode == 400) {
            string message = err.message();
            regexp:Span? search = regexp:find(re `field\s'[^']*'\scannot\sbe\sadded\sto\sthe\sclosed\srecord`, message);
            if search is regexp:Span {
                string[] split = regexp:split(re `'`, search.substring());
                if (split.length() > 1) {
                    response.setJsonPayload({
                        "message": string `Unkown field ${split[1]}`
                    }, "application/json");
                }
            }
        } else {
            response.setJsonPayload({
                "message": err.message()
            }, "application/json");
        }
        return response;
    }
}
