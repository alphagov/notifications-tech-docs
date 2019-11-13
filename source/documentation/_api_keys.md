# API keys

There are three different types of API keys:

- test
- team and whitelist
- live

When you set up a new service it will start in [trial mode](https://www.notifications.service.gov.uk/features/trial-mode). A service in trial mode can create test and team and whitelist keys. You must have a live service to create a live key.

To create an API key:

1. [Sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in).
1. In the top left corner of the page, check you’re viewing the correct service. If not, select __Switch service__ in the top right corner of the page and select the relevant service.
1. Go to the __API integration__ page.
1. Select __API keys__.
1. Select __Create an API key__.


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
|07700900003|`temporary-failure`|
|07700900002|`permanent-failure`|
|temp-fail@simulator.notify|`temporary-failure`|
|perm-fail@simulator.notify|`permanent-failure`|
|any other valid number or address|`delivered`|

You do not have to revoke test keys.

## Team and whitelist

A team and whitelist key lets you send real messages to your team members and addresses/numbers on your whitelist while your service is still in trial mode.

You will get an error if you use these keys to send messages to anyone who is not on your team or your whitelist.

Messages sent with a team and whitelist key appear on your dashboard and count against your text message and email allowances.

You do not have to revoke team and whitelist keys.

## Live

You can only create live keys once your service is live. You can use live keys to send messages to anyone.

Messages sent with a live key appear on your dashboard and count against your text message and email allowances.

You should revoke and re-create these keys on a regular basis. To revoke a key:

1. [Sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in).
1. In the top left corner of the page, check you’re viewing the correct service. If not, select __Switch service__ in the top right corner of the page and select the relevant service.
1. Go to the __API integration__ page.
1. Select __API keys__.
1. Select __Revoke__ for the API key you want to revoke.

You can have more than one active key at a time.

You should never send test messages to invalid numbers or addresses using a live key.
