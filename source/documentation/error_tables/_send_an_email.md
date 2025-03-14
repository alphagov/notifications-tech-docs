`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "email_address is not a valid email address"`<br>`}]`|Provide a valid recipient email address|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "one_click_unsubscribe_url is not a valid https url "`<br>`}]`|Provide a valid https url for your unsubscribe link|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "email_reply_to_id <reply to id> does not exist in database for service id <service id>"`<br>`}]`|Go to your Service Settings and copy a valid `email_reply_to_id`. Double check that the API key you are using and the `email_reply_to_id` belong to the same service.|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Emails cannot be longer than 2000000 bytes. Your message is <rendered template size in bytes> bytes."`<br>`}]`|Shorten your email message.|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can't send to this recipient when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode"`<br>`}]`|Your service cannot send this email in [trial mode](https://www.notifications.service.gov.uk/using-notify/trial-mode). To fix, you need to request for your service to go live.|
|`500`|`[{`<br>`"error": "Exception",`<br>`"message": "Internal server error"`<br>`}]`|Notify was unable to process the request, resend your email.|

In addition to the above, you can also encounter:

* various schema validation errors, for example when you forget to pass in an argument, or pass in an argument of a wrong type.
* errors about a file you try to send via email. You can find a list of these errors at the end of [Send a file by email section](#send-a-file-by-email)
* errors that are not related to sending an email, but instead are related to things like authentication and rate limits. You can find a list of these errors [in the General errors section](#general-errors)