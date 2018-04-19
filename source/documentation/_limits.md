# Limits

## API Rate limits

There is a rate limit for requests to the API from your account. The limit is 3000 per rolling 60 second time period. This limit applies per API key type. If you exceed the limit, you will receive the `429` error `RateLimitError`.

## Service limits

There are limits for the number of messages sent per day. These limits depend on whether your service is live, and the API key type. Limits reset at midnight.

|Service status|API key type|Daily limit|
|:---|:---|:---|
|Live|Team / Live|250,000|
|Live|Test|Unlimited|
|Trial|Team / Live|50|
|Trial|Test|Unlimited|
