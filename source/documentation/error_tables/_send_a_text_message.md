`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "phone_number Too many digits"`<br>`}]`|Provide a valid recipient phone number|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "phone_number Not enough digits"`<br>`}]`|Provide a valid recipient phone number|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "phone_number Not a UK mobile number"`<br>`}]`|Provide a valid recipient phone number|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "phone_number Must not contain letters or symbols"`<br>`}]`|Provide a valid recipient phone number|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "phone_number Not a valid country prefix"`<br>`}]`|Provide a valid recipient phone number|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "sms_sender_id <sms_sender_id> does not exist in database for service id <service id>"`<br>`}]`|Go to your Service Settings and copy a valid `sms_sender_id`. Double check that the API key you are using and the `sms_sender_id` belong to the same service.|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can't send to this recipient when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode"`<br>`}]`|Your service cannot send this text message in [trial mode](https://www.notifications.service.gov.uk/using-notify/trial-mode). To fix, you need to request for your service to go live.|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Cannot send to international mobile numbers"`<br>`}]`|Sending to international mobile numbers is turned off for your service. You can change this in your Service Settings.|
|`500`|`[{`<br>`"error": "Exception",`<br>`"message": "Internal server error"`<br>`}]`|Notify was unable to process the request, resend your text message.|

In addition to the above, you can also encounter:

* various schema validation errors, for example when you forget to pass in an argument, or pass in an argument of a wrong type.
* errors that are not related to sending a text message, but instead are related to things like authentication and rate limits. You can find a list of these errors [in the Errors Messages section](#error-messages)