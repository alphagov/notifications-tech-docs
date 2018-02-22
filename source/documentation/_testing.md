# Testing

All testing takes place in the production environment. There is no test environment for GOV.UK Notify.

## Smoke testing

If you need to [smoke test](https://www.gov.uk/service-manual/technology/deploying-software-regularly#using-smoke-tests-after-you-deploy) your integration with GOV.UK Notify on a regular basis, you  must use the smoke test phone numbers and email addresses below.

|Phone number|
|:---|
|07700900111|
|07700900222|
|07700900333|

|Email address|
|:---|
|simulate-delivered@notifications.service.gov.uk|
|simulate-delivered-2@notifications.service.gov.uk|
|simulate-delivered-3@notifications.service.gov.uk|

The smoke test phone numbers and email addresses will validate the request and simulate a successful response, but won’t send a real message, produce a delivery receipt or persist the notification to the database.

You can use these smoke test numbers and addresses with any [type of API key](/#api-keys).

You can smoke test all GOV.UK Notify API client functions except:

- Get the status of one message
- Get the status of all messages

You cannot use the smoke test phone numbers or email address with these functions because they return a fake `notification_ID`. If you need to test these functions, use a test API key and any other phone number or email.

## Other testing

You must use a [test API key](/#test) to do non-smoke testing such as performance or integration testing. You can use any non-smoke testing phone numbers or email addresses. You don’t need a specific GOV.UK Notify testing account.
