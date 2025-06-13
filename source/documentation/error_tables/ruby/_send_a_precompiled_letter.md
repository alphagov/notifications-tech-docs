**BadRequestError (status code 400)**|
`ValidationError: reference is a required property`|Add a `reference` argument to the method call|
`ValidationError: postage invalid. It must be either first, second or economy.`|Change the value of `postage` argument in the method call to either `"first"`, `"second"` or `"economy"`|
`BadRequestError: Letter content is not a valid PDF`|PDF file format is required.|
`BadRequestError: Cannot send letters when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode`|Your service cannot send this precompiled letter in [trial mode](https://www.notifications.service.gov.uk/using-notify/trial-mode).|
**AuthError (status code 403)**|
`BadRequestError: Cannot send letters with a team api key`|Use the correct type of [API key](#api-keys).|

In addition to the above, you may also encounter:

* other errors related to [sending an letter](#send-a-letter).
* various schema validation errors, for example when you forget to pass in an argument, or pass in an argument of a wrong type.
* errors that are not related to sending a letter, but instead are related to things like authentication and rate limits. You can find a list of these errors [in General errors](#general-errors)