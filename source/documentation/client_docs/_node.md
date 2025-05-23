## Get received text messages

This API call returns one page of up to 250 received text messages. You can get either the most recent messages, or get older messages by specifying a particular notification ID in the [`olderThan`](#get-a-page-of-received-text-messages-arguments-olderthan-optional) argument.

You can only get messages that are 7 days old or newer.

You can also set up [callbacks](#callbacks) for received text messages.

### Enable received text messages

To receive text messages:

1. Go to the **Text message settings** section of the **Settings** page.
1. Select **Change** on the **Receive text messages** row.

### Get a page of received text messages

#### Method

```javascript
notifyClient
  .getReceivedTexts(olderThan)
  .then((response) => console.log(response))
  .catch((err) => console.error(err))
```

The method returns a [promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Using_promises). The promise will either:

- resolve with a `response` if successful
- fail with an `err` if unsuccessful

To get the most recent messages, you must pass in an empty argument or `null`.

To get older messages, pass the ID of an older notification into the `olderThan` argument. This returns the next oldest messages from the specified notification ID.

#### Arguments

##### olderThan (optional)

Input the ID of a received text message into this argument. If you use this argument, the client returns the next 250 received text messages older than the given ID. For example:

```javascript
let olderThan = "740e5834-3a29-46b4-9a6f-16142fde533a";
```

If you pass in an empty argument or `null`, the client returns the most recent 250 text messages.

#### Response

If the request to the client is successful, the promise resolves with an `object` containing all received texts.

```javascript
{
    "received_text_messages":
    [
        {
            "id": "b51f638b-4295-46e0-a06e-cd41eee7c33b", // required string - ID of received text message
            "user_number": "447700900123", // required string - number of the end user who sent the message
            "notify_number": "07700900456", // required string - your receiving number
            "created_at": "2024-12-12 18:39:16.123346", // required string - date and time template created
            "service_id": "26785a09-ab16-4eb0-8407-a37497a57506", // required string - service ID
            "content": "STRING" // required string - text content
        },
        {
            //...another received text message
        }
    ],
    "links": {
        "current": "/received-text-messages",
        "next": "/received-text-messages?other_than=last_id_in_list"
    }
}
```

If the notification specified in the `olderThan` argument is older than 7 days, the promise resolves an empty response.

#### Error codes

If the request is not successful, the promise fails with an `err`.

|err.response.data.status_code|err.response.data.errors|How to fix|
|:---|:---|:---|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Error: Your system clock must be accurate to within 30 seconds"`<br>`}]`|Check your system clock|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Invalid token: API key not found"`<br>`}]`|Use the correct API key. Refer to [API keys](#api-keys) for more information|
