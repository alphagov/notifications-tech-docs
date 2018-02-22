# Callbacks

Callbacks are when Notify sends `POST` requests to your service. You can get callbacks when:

- a text message or email you’ve sent is delivered or fails
- your service receives a text message

## Set up callbacks

You must provide:

- a URL where Notify will post the callback to
- a bearer token which Notify will put in the authorisation header of the requests

To do this, log into your GOV.UK Notify account, go to _API integration_ and click _Callbacks_.

## For received text messages

If your service receives text messages in Notify, Notify can forward them to your callback URL as soon as they arrive.

Contact the GOV.UK Notify team on the [support page](https://www.notifications.service.gov.uk/support) or through the [slack channel](https://govuk.slack.com/messages/C0AC2LX7E) to enable "Receive text messages" for your service.

The callback message is formatted in JSON. The key, description and format of the callback message arguments are specified below:


## For delivery receipts

When you send an email or text message through Notify, Notify will send a receipt to your callback URL with the status of the message. This is an automated method to get the status of messages.  

This functionality works with test API keys but does not work with smoke testing phone numbers or email addresses.
