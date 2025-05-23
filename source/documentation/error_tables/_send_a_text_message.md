**ValidationError (status code 400)**|
`phone_number Too many digits`|Provide a valid recipient phone number.|
`phone_number Not enough digits`|Provide a valid recipient phone number.|
`phone_number Not a UK mobile number`|Provide a valid British recipient phone number.|
`phone_number Must not contain letters or symbols`|Provide a valid recipient phone number.|
`phone_number Not a valid country prefix`|Provide a valid recipient phone number.|
**BadRequestError (status code 400)**|
`sms_sender_id <sms_sender_id> does not exist in database for service id <service id>`|Go to your service Settings and copy a valid `sms_sender_id`. Check that the API key you are using and the `sms_sender_id` belong to the same service.|
`Cannot send to this recipient when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode`|Your service cannot send this text message in [trial mode](https://www.notifications.service.gov.uk/using-notify/trial-mode). To fix, you need to request for your service to go live.|
`Cannot send to international mobile numbers`|Sending to international mobile numbers is turned off for your service. You can change this in your service Settings.|

In addition to the above, you may also encounter:

* various schema validation errors, for example when you forget to pass in an argument, or pass in an argument of a wrong type.
* errors that are not related to sending a text message, but instead are related to things like authentication and rate limits. You can find a list of these errors [in General errors](#general-errors).