## Limits

### Rate limits

You’re limited to sending 3,000 messages per minute.

This limit is calculated on a rolling basis, per API key type. If you exceed the limit, you will get a `429` error `RateLimitError`.

### Daily limits

There’s a limit to the number of messages you can send each day:

|Service status|Type of API key|Daily limit|
|:---|:---|:---|
|Live|Team or live|250,000|
|Trial|Team|50|
|Live or trial|Test|Unlimited|

These limits reset at midnight.

### Phone network limits

If you repeatedly send text messages to the same number the phone networks will block them.

There’s an hourly limit of:

- 20 messages with the same content
- 100 messages with any content

Your messages may not be delivered if you exceed these limits.
