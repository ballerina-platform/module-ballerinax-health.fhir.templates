This template can be used to create a project for exposing Cerner as managed API.

## Cenrner FHIR API Template

This template can be used to create a project for exposing Cerner as managed API. The template uses the [FHIR client connector](https://central.ballerina.io/ballerinax/health.clients.fhir) to connect to the Cerner endpoint. The support for authenticating to Cerner has also been added to the template. It is sufficient to only create a project from this template and configure it.


### Compatibility
|                     | Version                   |
|---------------------|---------------------------|
| FHIR                | R4                        |

## Using the Template

### Setup and run

1.  Create Ballerina project from this template.

    ```ballerina
    bal new -t ballerinax/health.fhir.templates.r4.cernerconnect <PROJECT_NAME>
    ```
2. Create a config file [as described below](#configuring-the-project).

3. Run the project.

    ```ballerina
    bal run
    ```

4. Invoke the API.

    Example to retrieve a patient by ID:

    ```
    curl GET https://<host>:<port>/fhir/r4/Patient/123456
    ```


### Setup and run on Choreo

1. Perform steps 1 & 2 as mentioned above.

2. Push the project to a new Github repository.

3. Follow instructions to [connect the project repository to Choreo](https://wso2.com/choreo/docs/tutorials/connect-your-existing-ballerina-project-to-choreo/)

4. Deploy API by following [instructions to deploy](https://wso2.com/choreo/docs/tutorials/create-your-first-rest-api/#step-2-deploy) and [test](https://wso2.com/choreo/docs/tutorials/create-your-first-rest-api/#step-3-test)

5. Invoke the API.

    Sample URL to retrieve a patient by ID:

    `https://<domain>/<component>/<version>/Patient/123456`


### Configuring the project

Create a file `Config.toml` in the project's root directory and add the following configurations.

| Configuration     | Description                                                                                             |
|-------------------|---------------------------------------------------------------------------------------------------------|
| `base`            | Cerner base URL                                                                                         |
| `tokenUrl`        | Cerner's token endpoint                                                                                 |
| `clientId`        | Client ID of the system account registered with Cerner                                                  |
| `clientSecret`    | Client secret of the system account registered with Cerner                                              |
| `scopes`          | Comma-seperated list of scopes                                                                          |
| `customDomain`    | URL that should replace the Cerner base URL in the responses, if URL-rewrite interceptor is engaged     |
