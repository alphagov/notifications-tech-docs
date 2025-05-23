## Get a template

### Get a template by ID

#### Method

This returns the latest version of the template.

```javascript
notifyClient
  .getTemplateById(templateId)
  .then((response) => console.log(response))
  .catch((err) => console.error(err))
```

The method returns a [promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Using_promises). The promise will either:

- resolve with a `response` if successful
- fail with an `err` if unsuccessful

#### Arguments

##### templateId (required)

The ID of the template. [Sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in) and go to the __Templates__ page to find it. For example:

```javascript
let templateId = "f33517ff-2a88-4f6e-b855-c550268ce08a";
```

#### Response

If the request is successful, the promise resolves with a `response` `object`. For example, the `response.data` property will look like this:

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

If the request is not successful, the promise fails with an `err`.

|err.response.data.status_code|err.response.data.errors|How to fix|
|:---|:---|:---|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Error: Your system clock must be accurate to within 30 seconds"`<br>`}]`|Check your system clock|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Invalid token: API key not found"`<br>`}]`|Use the correct API key. Refer to [API keys](#api-keys) for more information|
|`404`|`[{`<br>`"error": "NoResultFound",`<br>`"message": "No Result Found"`<br>`}]`|Check your [template ID](#get-a-template-by-id-arguments-templateid-required)|


### Get a template by ID and version

#### Method

```javascript
notifyClient
  .getTemplateByIdAndVersion(templateId, version)
  .then((response) => console.log(response))
  .catch((err) => console.error(err))
```

The method returns a [promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Using_promises). The promise will either:

- resolve with a `response` if successful
- fail with an `err` if unsuccessful

#### Arguments

##### templateId (required)

The ID of the template. [Sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in) and go to the __Templates__ page to find it. For example:

```javascript
let templateId = "f33517ff-2a88-4f6e-b855-c550268ce08a";
```

##### version (required)

The version number of the template.

#### Response

If the request is successful, the promise resolves with a `response` `object`. For example, the `response.data` property will look like this:

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

If the request is not successful, the promise fails with an `err`.

|err.response.data.status_code|err.response.data.errors|How to fix|
|:---|:---|:---|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "id is not a valid UUID"`<br>`}]`|Check the notification ID|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Error: Your system clock must be accurate to within 30 seconds"`<br>`}]`|Check your system clock|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Invalid token: API key not found"`<br>`}]`|Use the correct API key. Refer to [API keys](#api-keys) for more information|
|`404`|`[{`<br>`"error": "NoResultFound",`<br>`"message": "No Result Found"`<br>`}]`|Check your [template ID](#get-a-template-by-id-and-version-arguments-templateid-required) and [version](#version-required)|


### Get all templates

#### Method

This returns the latest version of all templates.

```javascript
notifyClient
  .getAllTemplates(templateType)
  .then((response) => console.log(response))
  .catch((err) => console.error(err))
```

The method returns a [promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Using_promises). The promise will either:

- resolve with a `response` if successful
- fail with an `err` if unsuccessful

#### Arguments

##### templateType (optional)

If you leave out this argument, the method returns all templates. Otherwise you can filter by:

- `email`
- `sms`
- `letter`

#### Response

If the request is successful, the promise resolves with a `response` `object`. For example, the `response.data` property will look like this:

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
        //...another template
        }
    ]
}
```

If no templates exist for a template type or there no templates for a service, the object is empty.

### Generate a preview template

#### Method

This generates a preview version of a template.

```javascript
notifyClient
  .previewTemplateById(templateId, personalisation)
  .then((response) => console.log(response))
  .catch((err) => console.error(err))
```

The method returns a [promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Using_promises). The promise will either:

- resolve with a `response` if successful
- fail with an `err` if unsuccessful

The parameters in the personalisation argument must match the placeholder fields in the actual template. The API notification client ignores any extra fields in the method.

#### Arguments

##### templateId (required)

The ID of the template. [Sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in) and go to the __Templates__ page to find it. For example:

```javascript
let templateId = "f33517ff-2a88-4f6e-b855-c550268ce08a";
```

##### personalisation (optional)

If a template has placeholder fields for personalised information such as name or application date, you must provide their values in an `object`. For example:

```javascript
{
  personalisation: {
    "first_name": "Amala",
    "reference_number": "300241"
  }
}
```

You can leave out this argument if a template does not have any placeholder fields for personalised information.

#### Response

If the request is successful, the promise resolves with a `response` `object`. For example, the `response.data` property will look like this:

```javascript
{
  "id": "notify_id",
  "type": "sms|email|letter",
  "version": "version",
  "body": "Hello bar", // with substitution values
  "subject": "null|email_subject",
  "html": "<p>Example</p>" // Returns the rendered body (email templates only)
}
```

#### Error codes

If the request is not successful, the promise fails with an `err`.

|err.response.data.status_code|err.response.data.errors|How to fix|
|:---|:---|:---|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Missing personalisation: [PERSONALISATION FIELD]"`<br>`}]`|Check that the personalisation arguments in the method match the placeholder fields in the template|
|`400`|`[{`<br>`"error": "NoResultFound",`<br>`"message": "No result found"`<br>`}]`|Check the [template ID](#generate-a-preview-template-arguments-templateid-required)|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Error: Your system clock must be accurate to within 30 seconds"`<br>`}]`|Check your system clock|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Invalid token: API key not found"`<br>`}]`|Use the correct API key. Refer to [API keys](#api-keys) for more information|


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
