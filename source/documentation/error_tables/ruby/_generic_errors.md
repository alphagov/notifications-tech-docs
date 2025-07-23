Do not use the content of the messages in your code. These can sometimes change, which may affect your API integration.

Use the status code or the error type instead, as these will not change.

### General errors

You may encounter following errors when making requests to a number of Notify's API endpoints.

Error message | How to fix
---|---
**BadRequestError (status code 400)**|
`BadRequestError: Cannot send to this recipient using a team-only API key.`|Use a live API key, or add recipient to `Guest list` (located in API Integration section)|
`BadRequestError: Cannot send to this recipient when service is in trial mode – see https://www.notifications.service.gov.uk/trial-mode`|You need to request for your service to go live before you can send messages to people outside your team.|
**AuthError (status code 403)**|
`BadRequestError: Error: Your system clock must be accurate to within 30 seconds`|Check your system clock|
`BadRequestError: Invalid token: API key not found`|Use the correct API key. Refer to [API keys](#api-keys) for more information|
**RateLimitError (status code 429)**|
`RateLimitError: Exceeded rate limit for key type <team/test/live> of 3000/<custom limit> requests per 60 seconds`|Refer to [API rate limits](#rate-limits) for more information|
`TooManyRequestsError: Exceeded send limits (<sms/email/letter/international_sms>: <LIMIT SIZE>) for today`|Refer to [service limits](#daily-limits) for the limit size|
**ServerError (status code 500)**|
`Exception: Internal server error`|Notify was unable to process the request, resend your notification.|

### Schema validation errors

The following are a few examples of schema validation errors you may encounter when making a request to a Notify endpoint.

Error message | How to fix
---|---
**BadRequestError (status code 400)**|
`ValidationError: template_id is a required property`|Provide the missing argument.|
`ValidationError: sms_sender_id is not a valid UUID`|Check the argument to make sure that it is valid for the given data type.|
`ValidationError: personalisation <data type of argument you sent> is not of type object`|Provide argument in the correct type.|
`ValidationError: reference <reference string you provided> is too long`|Provide a shorter string.|
`ValidationError: template_type <invalid type> is not one of [sms, email, letter]`|Make sure that the argument matches one of the items in the list.|
`ValidationError: Additional properties are not allowed (<list of unexpected properties> was unexpected)`|Only provide allowed arguments for the endpoint.|


### Endpoint-specific errors

In addition to the above, you may also encounter endpoint-specific errors, which are listed under each relevant API endpoint section.

Find references for endpoint-specific errors in:

- [send a message](#send-a-message)
- [get message data](#get-message-data)
- [get a template](#get-a-template)
- [get received text messages](#get-received-text-messages)