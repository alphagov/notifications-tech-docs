`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "reference is a required property"`<br>`}]`|Add a `reference` argument to the method call|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "postage invalid. It must be either first or second."`<br>`}]`|Change the value of `postage` argument in the method call to either `"first"` or `"second"`|
|`403`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Cannot send letters with a team api key"`<br>`}]`|Use the correct type of [API key](#api-keys)|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Letter content is not a valid PDF"`<br>`}]`|PDF file format is required|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Cannot send letters when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode"`<br>`}]`|Your service cannot send this precompiled letter in [trial mode](https://www.notifications.service.gov.uk/using-notify/trial-mode)|

In addition to the above, you can also encounter:

* other errors related to [sending an letter](#send-a-letter).
* various schema validation errors, for example when you forget to pass in an argument, or pass in an argument of a wrong type.
* errors that are not related to sending a letter, but instead are related to things like authentication and rate limits. You can find a list of these errors [in the General errors section](#general-errors)