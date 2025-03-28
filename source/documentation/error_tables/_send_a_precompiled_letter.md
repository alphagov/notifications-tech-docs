**ValidationError (status code 400)**|
`reference is a required property`|Add a `reference` argument to the method call|
`postage invalid. It must be either first or second.`|Change the value of `postage` argument in the method call to either `"first"` or `"second"`|
**BadRequestError (status code 400)**|
`Letter content is not a valid PDF`|PDF file format is required.|
`Cannot send letters when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode`|Your service cannot send this precompiled letter in [trial mode](https://www.notifications.service.gov.uk/using-notify/trial-mode).|
**BadRequestError (status code 403)**|
`Cannot send letters with a team api key`|Use the correct type of [API key](#api-keys).|

In addition to the above, you may also encounter:

* other errors related to [sending an letter](#send-a-letter).
* various schema validation errors, for example when you forget to pass in an argument, or pass in an argument of a wrong type.
* errors that are not related to sending a letter, but instead are related to things like authentication and rate limits. You can find a list of these errors [in the General errors section](#general-errors)