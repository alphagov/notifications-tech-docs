## Limits

### Rate limits

You’re limited to sending 3,000 messages per minute. You should avoid sending messages in large spikes. 

This limit is calculated on a rolling basis, per API key type. If you exceed the limit, you will get a `429` error `RateLimitError`.

### Daily limits

There’s a limit to the number of messages you can send each day:

|Service status|Type of API key|Daily limit|
|:---|:---|:---|
|Live|Team or live|<ul class="govuk-list govuk-!-font-size-16"><li>250,000 emails</li><li>250,000 text messages, including a default 100 international text messages</li><li>20,000 letters</li></ul>|
|Trial|Team|50 emails or text messages|
|Live or trial|Test|Unlimited|

[GP surgeries](https://www.notifications.service.gov.uk/features/who-can-use-notify#gp) cannot send any text messages in trial mode. 

These limits reset at midnight UTC.

### Phone network limits

If you repeatedly send text messages to the same number the phone networks will block them.

There’s an hourly limit of:

- 20 messages with the same content
- 100 messages with any content

Your messages may not be delivered if you exceed these limits.
