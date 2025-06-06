**ValidationError (status code 400)**|
`email_address Not a valid email address`|Provide a valid recipient email address.|
`one_click_unsubscribe_url is not a valid https url`|Provide a valid https url for your unsubscribe link.|
**BadRequestError (status code 400)**|
`email_reply_to_id <reply to id> does not exist in database for service id <service id>`|Go to your service Settings and copy a valid `email_reply_to_id`. Double check that the API key you are using and the `email_reply_to_id` belong to the same service.|
`Emails cannot be longer than 2000000 bytes. Your message is <rendered template size in bytes> bytes.`|Shorten your email message.|
`Cannot send to this recipient when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode`|Your service cannot send this email in [trial mode](https://www.notifications.service.gov.uk/using-notify/trial-mode). To fix, you need to request for your service to go live.|

In addition to the above, you may also encounter:

* various schema validation errors, for example when you forget to pass in an argument, or pass in an argument of a wrong type.
* errors about a file you try to send via email. You can find a list of these errors at the end of [Send a file by email](#send-a-file-by-email)
* errors that are not related to sending an email, but instead are related to things like authentication and rate limits. You can find a list of these errors [in General errors](#general-errors)