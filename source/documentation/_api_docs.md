## Get a template

### Get a template by ID

#### Method

This returns the latest version of the template.

```
GET /v2/template/{template_id}
```

#### URL parameters

##### template_id (required)

The ID of the template. [Sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in) and go to the __Templates__ page to find it.

```
f33517ff-2a88-4f6e-b855-c550268ce08a
```

#### Response

If the request is successful, the response body is `json` and the status code is `200`.

```javascript
{
    "id": "f33517ff-2a88-4f6e-b855-c550268ce08a", // required string - template ID
    "name": "Pigeon registration - appointment email", // required string - template name
    "type": "sms / email / letter" , // required string
    "created_at": "2024-05-10 10:30:31.142535", // required string - date and time template created
    "updated_at": "2024-08-25 13:00:09.123234", // required string - date and time template last updated
    "version": 2, // required integer - template version
    "created_by": "charlie.smith@pigeons.gov.uk", // required string
    "subject": "Your upcoming pigeon registration appointment",  // required string for email and letter - subject of email / heading of letter
    "body": "Dear ((first_name))\r\n\r\nYour pigeon registration appointment is scheduled for ((appointment_date)).\r\n\r\nPlease bring:\r\n\n\n((required_documents))\r\n\r\nYours,\r\nPigeon Affairs Bureau",  // required string - body of notification
    "letter_contact_block": "Pigeons Affairs Bureau\n10 Whitechapel High Street\nLondon\nE1 8EF" // optional string - present for letter templates where contact block is set, otherwise null
}
```

#### Error codes

If the request is not successful, the API returns `json` containing the relevant error code. For example:

```javascript
{
  "status_code": 404,
  "errors": [
    {"error": "NoResultFound", "message": "No result found"}
  ]
}
```

|error.status_code|error.message|How to fix|
|:---|:---|:---|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Error: Your system clock must be accurate to within 30 seconds"`<br>`}]`|Check your system clock|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Invalid token: API key not found"`<br>`}]`|Use the correct API key. Refer to [API keys](#api-keys) for more information|
|`404`|`[{`<br>`"error": "NoResultFound",`<br>`"message": "No result found"`<br>`}]`|Check your [template ID](#get-a-template-by-id-arguments-template-id-required)|


### Get a template by ID and version

#### Method

```
GET /v2/template/{template_id}/version/{version}
```

#### URL parameters

##### template_id (required)

The ID of the template. [Sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in) and go to the __Templates__ page to find it.

```
f33517ff-2a88-4f6e-b855-c550268ce08a
```

##### version (required)

The version number of the template.

```
1
```

#### Response

If the request is successful, the response body is `json` and the status code is `200`.

```javascript
{
    "id": "f33517ff-2a88-4f6e-b855-c550268ce08a", // required string - template ID
    "name": "Pigeon registration - appointment email", // required string - template name
    "type": "sms / email / letter" , // required string
    "created_at": "2024-05-10 10:30:31.142535", // required string - date and time template created
    "updated_at": "2024-08-25 13:00:09.123234", // required string - date and time template last updated
    "version": 1, // required integer - template version
    "created_by": "charlie.smith@pigeons.gov.uk", // required string
    "subject": "Your upcoming pigeon registration appointment",  // required string for email and letter - subject of email / heading of letter
    "body": "Dear ((first_name))\r\n\r\nYour pigeon registration appointment is scheduled for ((appointment_date)).\r\n\r\nPlease bring:\r\n\n\n((required_documents))\r\n\r\nYours,\r\nPigeon Affairs Bureau",  // required string - body of notification
    "letter_contact_block": "Pigeons Affairs Bureau\n10 Whitechapel High Street\nLondon\nE1 8EF" // optional string - present for letter templates where contact block is set, otherwise null
}
```

#### Error codes

If the request is not successful, the API returns `json` containing the relevant error code. For example:

```javascript
{
  "status_code": 404,
  "errors": [
    {"error": "NoResultFound", "message": "No result found"}
  ]
}
```

|error.status_code|error.message|How to fix|
|:---|:---|:---|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Error: Your system clock must be accurate to within 30 seconds"`<br>`}]`|Check your system clock|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Invalid token: API key not found"`<br>`}]`|Use the correct API key. Refer to [API keys](#api-keys) for more information|
|`404`|`[{`<br>`"error": "NoResultFound",`<br>`"message": "No result found"`<br>`}]`|Check your [template ID](#get-a-template-by-id-and-version-arguments-template-id-required) and [version](#version-required)|


### Get all templates

#### Method

This returns the latest version of all templates.

```
GET /v2/templates
```

#### Query parameters

##### template_type (optional)

If you leave out this argument, the method returns all templates. Otherwise you can filter by:

- `email`
- `sms`
- `letter`

#### Response

If the request is successful, the response body is `json` and the status code is `200`.

```javascript
{
    "templates": [
        {
            "id": "f33517ff-2a88-4f6e-b855-c550268ce08a", // required string - template ID
            "name": "Pigeon registration - appointment email", // required string - template name
            "type": "sms / email / letter" , // required string
            "created_at": "2024-05-10 10:30:31.142535", // required string - date and time template created
            "updated_at": "2024-08-25 13:00:09.123234", // required string - date and time template last updated
            "version": 2, // required integer - template version
            "created_by": "charlie.smith@pigeons.gov.uk", // required string
            "subject": "Your upcoming pigeon registration appointment",  // required string for email and letter - subject of email / heading of letter
            "body": "Dear ((first_name))\r\n\r\nYour pigeon registration appointment is scheduled for ((appointment_date)).\r\n\r\nPlease bring:\r\n\n\n((required_documents))\r\n\r\nYours,\r\nPigeon Affairs Bureau",  // required string - body of notification
            "letter_contact_block": "Pigeons Affairs Bureau\n10 Whitechapel High Street\nLondon\nE1 8EF" // optional string - present for letter templates where contact block is set, otherwise null
        },
        {
            ...another template
        }
    ]
}
```

If no templates exist for a template type or there no templates for a service, the API returns a `json` object with a `templates` key for an empty array:

```javascript
{
    "templates": []
}
```

### Generate a preview template

#### Method

This generates a preview version of a template.

```
POST /v2/template/{template_id}/preview
```
#### URL parameters

##### template_id (required)

The ID of the template. [Sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in) and go to the __Templates__ page to find it.

```
f33517ff-2a88-4f6e-b855-c550268ce08a
```

#### Request body

```
{
  "personalisation": {
    "first_name": "Amala",
    "appointment_date": "1 January 2018 at 1:00pm",
  }
}
```

#### Arguments


##### personalisation (required)

If a template has placeholder fields for personalised information such as name or reference number, you need to provide their values in a dictionary with key value pairs. For example:

```javascript
{
  "personalisation": {
    "first_name": "Amala",
    "appointment_date": "1 January 2018 at 1:00PM",
    "required_documents": ["passport", "utility bill", "other id"],
  }
}
```

The keys in the personalisation argument must match the placeholder fields in the actual template. The API will ignore any extra keys in the personalisation argument.

#### Response

If the request is successful, the response body is `json` and the status code is `200`.

```javascript
{
    "id": "740e5834-3a29-46b4-9a6f-16142fde533a", // required string - notification ID
    "type": "sms / email / letter" , // required string
    "version": 3,
    // required string - body of notification
    "body": "Dear Amala\r\n\r\nYour pigeon registration appointment is scheduled for 1 January 2018 at 1:00PM.\r\n\r\n Here is a link to your invitation document:\r\n\n\n* passport\n* utility bill\n* other id\r\n\r\nPlease bring the invite with you to the appointment.\r\n\r\nYours,\r\nPigeon Affairs Bureau",
    // required string for emails, empty for sms and letters - html version of the email body
    "html": '<p style="Margin: 0 0 20px 0; font-size: 19px; line-height: 25px; color: #0B0C0C;">Dear Amala</p> ... [snippet truncated for readability]',
    // required string for email and letter - subject of email / heading of letter
    "subject": 'Your upcoming pigeon registration appointment',
    'postage': null, // required string for letters, empty for sms and emails - letter postage
}
```

#### Error codes

If the request is not successful, the API returns `json` containing the relevant error code. For example:

|error.status_code|error.message|Notes|
|:---|:---|:---|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Missing personalisation: [PERSONALISATION FIELD]"`<br>`}]`|Check that the personalisation arguments in the method match the placeholder fields in the template|
|`400`|`[{`<br>`"error": "NoResultFound",`<br>`"message": "No result found"`<br>`}]`|Check the [template ID](#generate-a-preview-template-arguments-template-id-required)|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Error: Your system clock must be accurate to within 30 seconds"`<br>`}]`|Check your system clock|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Invalid token: API key not found"`<br>`}]`|Use the correct API key. Refer to [API keys](#api-keys) for more information|


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
