## Callbacks

Callbacks are when GOV.UK Notify sends `POST` requests to your service. You can get callbacks when:

- a text message or email you’ve sent is delivered or fails
- your service receives a text message

### Set up callbacks

You must provide:

- a URL where Notify will post the callback to
- a bearer token which Notify will put in the authorisation header of the requests

To do this:

1. [Sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in).
1. Go to the __API integration__ page.
1. Select __Callbacks__.

### Retry callbacks

If Notify sends a `POST` request to your service, but the request fails then we will retry.

We will retry every 5 minutes, up to a maximum of 5 times.

### Delivery receipts

When you send an email or text message, Notify will send a receipt to your callback URL with the status of the message. This is an automated method to get the status of messages.

This functionality works with test API keys, but does not work with smoke testing phone numbers or email addresses.

The callback message is formatted in JSON. All of the values are strings, apart from the template version, which is a number. The key, description and format of the callback message arguments will be:

|Key | Description | Format|
|:---|:---|:---|
|#`id` | Notify’s id for the status receipts | UUID|
|#`reference` | The reference sent by the service | `12345678` or null|
|#`to` | The email address or phone number of the recipient | `hello@gov.uk` or `07700912345`|
|#`status` | The status of the notification | `delivered`, `permanent-failure`, `temporary-failure` or `technical-failure`|
|#`created_at` | The time the service sent the request | `2017-05-14T12:15:30.000000Z`|
|#`completed_at` | The last time the status was updated | `2017-05-14T12:15:30.000000Z` or null|
|#`sent_at` | The time the notification was sent | `2017-05-14T12:15:30.000000Z` or null|
|#`notification_type` | The notification type | `email` or `sms`|
|#`template_id` | The id of the template that was used | UUID|
|#`template_version` | The version number of the template that was used | `1`|

### Received text messages

If your service receives text messages in Notify, Notify can forward them to your callback URL as soon as they arrive.

Find out [how to let people send text messages to your service](https://www.notifications.service.gov.uk/using-notify/receive-text-messages).

The callback message is formatted in JSON. All of the values are strings. The key, description and format of the callback message arguments will be:

|Key | Description | Format|
|:---|:---|:---|
|#`id` | Notify’s id for the received message | UUID|
|#`source_number` | The phone number the message was sent from | 447700912345|
|#`destination_number` | The number the message was sent to (your number) | 07700987654|
|#`message` | The received message | Hello Notify!|
|#`date_received` | The UTC datetime that the message was received by Notify | 2017-05-14T12:15:30.000000Z|
