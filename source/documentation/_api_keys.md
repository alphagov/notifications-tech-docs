# API keys

There are three different types of API keys:

- test
- team and whitelist
- live

When you first sign up to Notify, you can create test and team and whitelist keys. You must have a live service to create a live key.

## Test

Use a test key to test the performance of your service and its integration with GOV.UK Notify.

Messages sent using a test key:

- generate realistic responses
- result in a delivered status
- are not actually delivered to a recipient
- do not appear on your dashboard
- do not count against your text message and email allowances

To test failure responses with a test key, use the following numbers and addresses:

|Phone number/Email address|Response|
|:---|:---|
|07700900003|`temporary failure`|
|07700900002|`permanent failure`|
|temp-fail@simulator.notify|`temporary failure`|
|perm-fail@simulator.notify|`permanent failure`|
|any other valid number or address|`delivered`|

You do not have to revoke test keys.

## Team and whitelist

A team and whitelist key lets you send real messages to your team members and addresses/numbers on your whitelist while your account is still in trial mode.

You will get an error if you use these keys to send messages to anyone who isn't on your team or your whitelist.

Messages sent with a team and whitelist key appear on your dashboard and count against your text message and email allowances.

You do not have to revoke team and whitelist keys.

## Live

You can only create live keys once your service is live. You can use live keys to send messages to anyone.

Messages sent with a live key appear on your dashboard and count against your text message and email allowances.

You should revoke and re-create these keys on a regular basis. To revoke a key:

1. Log into your GOV.UK Notify account.
1. Select __API integration__ and then __API keys__.
1. Select __Revoke__ for the API key you want to revoke.

You can have more than one active key at a time.

You should never send test messages to invalid numbers or addresses using a live key. If you do, the client will revoke your live API key.
