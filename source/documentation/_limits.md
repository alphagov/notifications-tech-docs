# Limits

## API Rate limits

There is a rate limit for requests to the API from your account. The limit is 3000 per rolling 60 second time period. This limit applies per API key type. If you exceed the limit, you will receive the `429` error `RateLimitError`.

## Service limits

There are limits for the number of messages sent per day. These limits differ depending on the service status and type, and the API key type.

|Service status|API Key Type|Service type|Daily limit|
|:---|:---|:---|:---|
|Live|Team / Live|Central Government|250,000|
|Live|Team / Live|Local / NHS|25,000|
|Live|Test|All|Unlimited|
|Trial|Team / Live|All|50|
|Trial|Test|All|Unlimited|

Limits reset at midnight.
