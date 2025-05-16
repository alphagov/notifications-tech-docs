## Get received text messages

This API call returns one page of up to 250 received text messages. You can get either the most recent messages, or get older messages by specifying a particular notification ID in the older_than query parameter.

You can only get the status of messages that are 7 days old or newer.

### Enable received text messages

To receive text messages:

1. Go to the **Text message settings** section of the **Settings** page.
1. Select **Change** on the **Receive text messages** row.

### Get a page of received text messages

#### Method

```
GET /v2/received-text-messages
```

You can specify which text messages to receive by inputting the ID of a received text message into the [`older_than`](#get-a-page-of-received-text-messages-query-parameters-older-than-optional) argument.


#### Query parameters

##### older_than (optional)

Input the ID of a received text message into this argument. If you use this argument, the method returns the next 250 received text messages older than the given ID.

```
?older_than=740e5834-3a29-46b4-9a6f-16142fde533a // optional string - notification ID
```

#### Response

If the request is successful, the response body is `json` and the status code is `200`.

```javascript
{
  "received_text_messages":
  [
    {
      "id": "'b51f638b-4295-46e0-a06e-cd41eee7c33b", // required string - ID of received text message
      "user_number": "447700900123", // required string - number of the end user who sent the message
      "notify_number": "07700900456", // required string - your receiving number
      "created_at": "2024-12-12 18:39:16.123346", // required string - date and time template created
      "service_id": "26785a09-ab16-4eb0-8407-a37497a57506", // required string - service ID
      "content": "STRING" // required string - text content
    },
    {
      ...another received text message
    }
  ],
  "links": {
    "current": "https://api.notifications.service.gov.uk/v2/received-text-messages",
    "next": "https://api.notifications.service.gov.uk/v2/received-text-messages?other_than=last_id_in_list"
  }
}
```

#### Error codes

If the request is not successful, the API returns `json` containing the relevant error code. For example:

|error.status_code|error.message|How to fix|
|:---|:---|:---|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Error: Your system clock must be accurate to within 30 seconds"`<br>`}]`|Check your system clock|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Invalid token: API key not found"`<br>`}]`|Use the correct API key. Refer to [API keys](#api-keys) for more information|
