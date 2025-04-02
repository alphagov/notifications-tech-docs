Do not use the content of the messages in your code. These can sometimes change, which may affect your API integration.

Use the status code or the error type instead, as these will not change.

### General errors

You may encounter following errors when making requests to a number of Notify's API endpoints.

Error message | How to fix
---|---
**BadRequestError (status code 400)**|
`Can’t send to this recipient using a team-only API key.`|Use a live API key, or add recipient to `Guest list` (located in API Integration section)|
`Cannot send to this recipient when service is in trial mode – see https://www.notifications.service.gov.uk/trial-mode`|You need to request for your service to go live before you can send messages to people outside your team.|
**BadRequestError (status code 403)**|
`Error: Your system clock must be accurate to within 30 seconds`|Check your system clock|
`Invalid token: API key not found`|Use the correct API key. Refer to [API keys](#api-keys) for more information|
**RateLimitError (status code 429)**|
`Exceeded rate limit for key type <team/test/live> of 3000/<custom limit> requests per 60 seconds`|Refer to [API rate limits](#rate-limits) for more information|
**TooManyRequestsError (status code 429)**|
`Exceeded send limits <your daily limit> for today`|Refer to [service limits](#daily-limits) for the limit number|
**Exception (status code 500)**|
`Internal server error`|Notify was unable to process the request, resend your notification.|

In addition to the above, you may also encounter:

* various schema validation errors, for example when you forget to pass in an argument, or pass in an argument of a wrong type.

* endpoint-specific errors, which are listed under each relevant API endpoint section.

Find references for endpoint-specific errors in:

- [send a message](#send-a-message)
- [get message status](#get-message-status)
- [get a template](#get-a-template)
- [get received text messages](#get-received-text-messages)