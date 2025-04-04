**ValidationError (status code 400)**|
`status ‘elephant’ is not one of [cancelled, created, sending, sent, delivered, pending, failed, technical-failure, temporary-failure, permanent-failure, pending-virus-check, validation-failed, virus-scan-failed, returned-letter, accepted, received]`|Change the [status argument](#status-optional).|
`‘Apple’ is not one of [sms, email, letter]`|Change the [template_type argument](#template-type-optional).|

In addition to the above, you may also encounter:

* various schema validation errors, for example when you forget to pass in an argument, or pass in an argument of a wrong type.
* errors that are not related to getting the status of messages, but instead are related to things like authentication and rate limits. You can find a list of these errors [in General errors](#general-errors)