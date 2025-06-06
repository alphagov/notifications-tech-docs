**BadRequestError (status code 400)**|
`ValidationError: Template type is not one of [sms, email, letter]`|Check your [template type](#type-optional).|

In addition to the above, you may also encounter:

* various schema validation errors, for example when you forget to pass in an argument, or pass in an argument of a wrong type.
* errors that are not related to getting a template, but instead are related to things like authentication and rate limits. You can find a list of these errors [in General errors](#general-errors)