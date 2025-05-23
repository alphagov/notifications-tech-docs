## Get message status


### Get the status of one message

You can only get the status of messages sent within the retention period. The default retention period is 7 days.

#### Method

```javascript
notifyClient
  .getNotificationById(notificationId)
  .then((response) => console.log(response))
  .catch((err) => console.error(err))
```

The method returns a [promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Using_promises). The promise will either:

- resolve with a `response` if successful
- fail with an `err` if unsuccessful

#### Arguments

##### notificationId (required)

The ID of the notification. To find the notification ID, you can either:

* check the response to the [original notification method call](#response)
* [sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in) and go to the __API integration__ page

#### Response

If the request is successful, the promise resolves with a `response` `object`. For example, the `response.data` property will look like this:

```javascript
{
    "id": "740e5834-3a29-46b4-9a6f-16142fde533a",  // required string - notification ID
    "reference": "your reference",  // optional string - reference you provided when sending the message
    "email_address": "amala@example.com",  // required string for emails
    "phone_number": "+447700900123",  // required string for text messages
    "line_1": "Amala Bird",  // required string for letter
    "line_2": "123 High Street",  // required string for letter
    "line_3": "Richmond upon Thames",  // required string for letter
    "line_4": "Middlesex",  // optional string for letter
    "line_5": "SW14 6BF",  // optional string for letter
    "line_6": null,  // optional string for letter
    "line_7": null, // optional string for letter
    "postage": "first / second / europe / rest-of-world", // required string for letter
    "type": "sms / letter / email",  // required string
    "status": "sending / delivered / permanent-failure / temporary-failure / technical-failure",  // required string
    "template": {
        "version": 1, // required integer
        "id": "f33517ff-2a88-4f6e-b855-c550268ce08a",  // required string - template ID
        "uri": "/v2/template/{id}/{version}"  // required string
    },
    "body": "Hi Amala, your appointment is on 1 January 2018 at 1:00pm",  // required string - body of notification
    "subject": "Your upcoming pigeon registration appointment",  // required string for email - subject of email
    "created_at": "2024-05-17 15:58:38.342838",  // required string - date and time notification created
    "created_by_name": "Charlie Smith",  // optional string - name of the person who sent the notification if sent manually
    "sent_at": "2024-05-17 15:58:30.143000",  // optional string - date and time notification sent to provider
    "completed_at": "2024-05-17 15:59:10.321000",  // optional string - date and time notification delivered or failed
    "one_click_unsubscribe": "https://example.com/unsubscribe.html?opaque=123456789", // optional string, email only - URL that you provided so your recipients can unsubscribe
    "is_cost_data_ready": True,  // required boolean, this field is true if cost data is ready, and false if it isn't
    "cost_in_pounds": 0.0027,  // optional number - cost of the notification in pounds. The cost does not take free allowance into account
    "cost_details": {
    // for text messages:
        "billable_sms_fragments": 1,  // optional integer - number of billable sms fragments in your text message
        "international_rate_multiplier": 1,  // optional integer - for international sms rate is multiplied by this value
        "sms_rate": 0.0027,  // optional number - cost of 1 sms fragment
    // for letters:
        "billable_sheets_of_paper": 2,  // optional integer - number of sheets of paper in the letter you sent, that you will be charged for
        "postage": "first / second / europe / rest-of-world"  // optional string
    }
}
```

#### Error codes

If the request is not successful, the promise fails with an `err`.

|err.response.data.status_code|err.response.data.errors|How to fix|
|:---|:---|:---|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "id is not a valid UUID"`<br>`}]`|Check the notification ID|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Error: Your system clock must be accurate to within 30 seconds"`<br>`}]`|Check your system clock|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Invalid token: API key not found"`<br>`}]`|Use the correct API key. Refer to [API keys](#api-keys) for more information|
|`404`|`[{`<br>`"error": "NoResultFound",`<br>`"message": "No result found"`<br>`}]`|Check the notification ID|


### Get the status of multiple messages

This API call returns one page of up to 250 messages and statuses. You can get either the most recent messages, or get older messages by specifying a particular notification ID in the [`olderThan`](#olderthan-optional) argument.

You can only get messages that are within your data retention period. The default data retention period is 7 days. It can be changed in your Service Settings.

#### Method

```javascript
notifyClient
  .getNotifications(templateType, status, reference, olderThan)
  .then((response) => console.log(response))
  .catch((err) => console.error(err))
```

The method returns a [promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Using_promises). The promise will either:

- resolve with a `response` if successful
- fail with an `err` if unsuccessful

To get the most recent messages, you must pass in an empty `olderThan` argument or `null`.

To get older messages, pass the ID of an older notification into the `olderThan` argument. This returns the next oldest messages from the specified notification ID.

#### Arguments

You can pass in empty arguments or `null` to ignore these filters.

##### status (optional)

You can filter by each:

* [email status](#email-status-descriptions)
* [text message status](#text-message-status-descriptions)
* [letter status](#letter-status-descriptions)
* [precompiled letter status](#precompiled-letter-status-descriptions)

You can leave out this argument to ignore this filter.

##### notificationType (optional)

You can filter by:

* `email`
* `sms`
* `letter`

##### reference (optional)

A unique identifier you create if necessary. This reference identifies a single unique notification or a batch of notifications. It must not contain any personal information such as name or postal address. For example:

```javascript
let reference  = "your_reference_here";
```

##### olderThan (optional)

Input the ID of a notification into this argument. If you use this argument, the client returns the next 250 received notifications older than the given ID. For example:

```javascript
let olderThan = "8e222534-7f05-4972-86e3-17c5d9f894e2";
```

If you pass in an empty argument or `null`, the client returns the most recent 250 notifications.

#### Response

If the request is successful, the promise resolves with a `response` `object`. For example, the `response.data` property will look like this:

```javascript
{
  "notifications": [
    {
      "id": "740e5834-3a29-46b4-9a6f-16142fde533a",  // required string - notification ID
      "reference": "STRING",  // optional string - client reference
      "email_address": "sender@something.com",  // required string for emails
      "phone_number": "+447900900123",  // required string for text messages
      "line_1": "ADDRESS LINE 1",  // required string for letter
      "line_2": "ADDRESS LINE 2",  // required string for letter
      "line_3": "ADDRESS LINE 3",  // required string for letter
      "line_4": "ADDRESS LINE 4",  // optional string for letter
      "line_5": "ADDRESS LINE 5",  // optional string for letter
      "line_6": "ADDRESS LINE 6",  // optional string for letter
      "postcode": "valid UK postcode", // optional string 
      "postage": "first / second / europe / rest-of-world", // required string for letter
      "type": "sms / letter / email",  // required string
      "status": "sending / delivered / permanent-failure / temporary-failure / technical-failure",  // required string
      "template": {
        "version": 1, // required integer
        "id": "f33517ff-2a88-4f6e-b855-c550268ce08a",  // required string - template ID
        "uri": "/v2/template/{id}/{version}"  // required string
      },
      "body": "STRING",  // required string - body of notification
      "subject": "STRING",  // required string for email - subject of email
      "created_at": "2024-05-17 15:58:38.342838",  // required string - date and time notification created
      "created_by_name": "STRING",  // optional string - name of the person who sent the notification if sent manually
      "sent_at": "2024-05-17 15:58:30.143000",  // optional string - date and time notification sent to provider
      "completed_at": "2024-05-17 15:59:10.321000",  // optional string - date and time notification delivered or failed
      "one_click_unsubscribe": "STRING", // optional string, email only - URL that you provided so your recipients can unsubscribe
      "is_cost_data_ready": true,  // required boolean, this field is true if cost data is ready, and false if it isn't
      "cost_in_pounds": 0.0027,  // optional number - cost of the notification in pounds. The cost does not take free allowance into account
      "cost_details": {
        // for text messages:
        "billable_sms_fragments": 1,  // optional integer - number of billable sms fragments in your text message
        "international_rate_multiplier": 1,  // optional integer - for international sms rate is multiplied by this value
        "sms_rate": 0.0027,  // optional number - cost of 1 sms fragment
        // for letters:
        "billable_sheets_of_paper": 2,  // optional integer - number of sheets of paper in the letter you sent, that you will be charged for
        "postage": "first / second / europe / rest-of-world"  // optional string
      }
    }
  ],
  "links": {
    "current": "/notifications?template_type=sms&status=delivered",
    "next": "/notifications?other_than=last_id_in_list&template_type=sms&status=delivered"
  }
}
```

#### Error codes

If the request is not successful, the promise fails with an `err`.

|err.response.data.status_code|err.response.data.errors|How to fix|
|:---|:---|:---|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "bad status is not one of [created, sending, sent, delivered, pending, failed, technical-failure, temporary-failure, permanent-failure, accepted, received]"`<br>`}]`|[Contact the GOV.UK Notify team](https://www.notifications.service.gov.uk/support)|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "Applet is not one of [sms, email, letter]"`<br>`}]`|[Contact the GOV.UK Notify team](https://www.notifications.service.gov.uk/support)|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Error: Your system clock must be accurate to within 30 seconds"`<br>`}]`|Check your system clock|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Invalid token: API key not found"`<br>`}]`|Use the correct API key. Refer to [API keys](#api-keys) for more information|

### Email status descriptions

|Status|Description|
|:---|:---|
|#`created`|GOV.UK Notify has placed the message in a queue, ready to be sent to the provider. It should only remain in this state for a few seconds.|
|#`sending`|GOV.UK Notify has sent the message to the provider. The provider will try to deliver the message to the recipient for up to 72 hours. GOV.UK Notify is waiting for delivery information.|
|#`delivered`|The message was successfully delivered.|
|#`permanent-failure`|The provider could not deliver the message because the email address was wrong. You should remove these email addresses from your database.|
|#`temporary-failure`|The provider could not deliver the message. This can happen when the recipient’s inbox is full or their anti-spam filter rejects your email. [Check your content does not look like spam](https://www.gov.uk/service-manual/design/sending-emails-and-text-messages#protect-your-users-from-spam-and-phishing) before you try to send the message again.|
|#`technical-failure`|Your message was not sent because there was a problem between Notify and the provider.<br>You’ll have to try sending your messages again.|

### Text message status descriptions

|Status|Description|
|:---|:---|
|#`created`|GOV.UK Notify has placed the message in a queue, ready to be sent to the provider. It should only remain in this state for a few seconds.|
|#`sending`|GOV.UK Notify has sent the message to the provider. The provider will try to deliver the message to the recipient for up to 72 hours. GOV.UK Notify is waiting for delivery information.|
|#`pending`|GOV.UK Notify is waiting for more delivery information.<br>GOV.UK Notify received a callback from the provider but the recipient’s device has not yet responded. Another callback from the provider determines the final status of the text message.|
|#`sent`|The message was sent to an international number. The mobile networks in some countries do not provide any more delivery information. The GOV.UK Notify website displays this status as 'Sent to an international number'.|
|#`delivered`|The message was successfully delivered. If a recipient blocks your sender name or mobile number, your message will still show as delivered.|
|#`permanent-failure`|The provider could not deliver the message. This can happen if the phone number was wrong or if the network operator rejects the message. If you’re sure that these phone numbers are correct, you should [contact GOV.UK Notify support](https://www.notifications.service.gov.uk/support). If not, you should remove them from your database. You’ll still be charged for text messages that cannot be delivered.
|#`temporary-failure`|The provider could not deliver the message. This can happen when the recipient’s phone is off, has no signal, or their text message inbox is full. You can try to send the message again. You’ll still be charged for text messages to phones that are not accepting messages.|
|#`technical-failure`|Your message was not sent because there was a problem between Notify and the provider.<br>You’ll have to try sending your messages again. You will not be charged for text messages that are affected by a technical failure.|

### Letter status descriptions

|Status|Description|
|:---|:---|
|#`accepted`|GOV.UK Notify has sent the letter to the provider to be printed.|
|#`received`|The provider has printed and dispatched the letter.|
|#`cancelled`|Sending cancelled. The letter will not be printed or dispatched.|
|#`technical-failure`|GOV.UK Notify had an unexpected error while sending the letter to our printing provider.|
|#`permanent-failure`|The provider cannot print the letter. Your letter will not be dispatched.|

### Precompiled letter status descriptions

|Status|Description|
|:---|:---|
|#`accepted`|GOV.UK Notify has sent the letter to the provider to be printed.|
|#`received`|The provider has printed and dispatched the letter.|
|#`cancelled`|Sending cancelled. The letter will not be printed or dispatched.|
|#`pending-virus-check`|GOV.UK Notify has not completed a virus scan of the precompiled letter file.|
|#`virus-scan-failed`|GOV.UK Notify found a potential virus in the precompiled letter file.|
|#`validation-failed`|Content in the precompiled letter file is outside the printable area. See the [GOV.UK Notify letter specification](https://www.notifications.service.gov.uk/using-notify/guidance/letter-specification) for more information.|
|#`technical-failure`|GOV.UK Notify had an unexpected error while sending the letter to our printing provider.|
|#`permanent-failure`|The provider cannot print the letter. Your letter will not be dispatched.|

### Get a PDF for a letter notification

#### Method

```javascript
notifyClient
  .getPdfForLetterNotification(notificationId)
  .then(function (fileBuffer) {
    return fileBuffer
  }) /* the response is a file buffer, an instance of Buffer */
  .catch((err) => console.error(err))
```

The method returns a [promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Using_promises). The promise will either:

- resolve with `fileBuffer` if successful
- fail with an `err` if unsuccessful

#### Arguments

##### notificationId (required)

The ID of the notification. To find the notification ID, you can either:

* check the response to the [original notification method call](#get-the-status-of-one-message-response)
* [sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in) and go to the __API integration__ page

#### Response

If the request to the client is successful, the client will return an instance of the [Buffer](https://nodejs.org/api/buffer.html#buffer_buffer) class containing the raw PDF data.

#### Error codes

If the request is not successful, the client will return an `HTTPError` containing the relevant error code:

|error.status_code|error.message|How to fix|
|:---|:---|:---|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "id is not a valid UUID"`<br>`}]`|Check the notification ID|
|`400`|`[{`<br>`"error": "PDFNotReadyError",`<br>`"message": "PDF not available yet, try again later"`<br>`}]`|Wait for the notification to finish processing. This usually takes a few seconds|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "File did not pass the virus scan"`<br>`}]`|You cannot retrieve the contents of a letter notification that contains a virus|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "PDF not available for letters in technical-failure"`<br>`}]`|You cannot retrieve the contents of a letter notification in technical-failure|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "Notification is not a letter"`<br>`}]`|Check that you are looking up the correct notification|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Error: Your system clock must be accurate to within 30 seconds"`<br>`}]`|Check your system clock|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Invalid token: API key not found"`<br>`}]`|Use the correct API key. Refer to [API keys](#api-keys) for more information|
|`404`|`[{`<br>`"error": "NoResultFound",`<br>`"message": "No result found"`<br>`}]`|Check the notification ID|


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
