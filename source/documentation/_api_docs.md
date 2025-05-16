### Send a precompiled letter

```
POST /v2/notifications/letter
```
#### Request body

```javascript
{
  "reference": "your reference",
  "content": "file as base64 encoded string"
}
```

#### Arguments

##### reference (required)

An identifier you create. This reference identifies a single unique precompiled letter or a batch of precompiled letters. It must not contain any personal information such as name or postal address.

```javascript
"reference": "your reference" // required string - identifies notification(s)
```

##### content (required)

The precompiled letter must be a PDF file which meets [the GOV.UK Notify letter specification](https://www.notifications.service.gov.uk/using-notify/guidance/letter-specification). You’ll need to convert the file into a string that is base64 encoded.

```javascript
"content": "file as base64 encoded string"
```

##### postage (optional)

You can choose first or second class postage for your precompiled letter. Set the value to `first` for first class, or `second` for second class. If you do not pass in this argument, the postage will default to second class.

```javascript
"postage": "second"
```


#### Response

If the request is successful, the response body is `json` and the status code is `201`:

```javascript
{
  "id": "1d986ba7-fba6-49fb-84e5-75038a1dd968",  // required string - notification ID
  "reference": "your reference",  // required string - reference your provided
  "postage": "first"  // required string - postage you provided, or else default postage for the letter
}
```

#### Error codes

If the request is not successful, the API returns `json` containing the relevant error code. For example:

```javascript
{
  "status_code": 400,
  "errors": [
    {"error": "BadRequestError", "message": "Can't send to this recipient using a team-only API key"}
  ]
}
```

|status_code|Error message|How to fix|
|:---|:---|:---|
|`403`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can't send letters with a team API key"`<br>`}]`|Use the correct type of [API key](#api-keys)|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Letter content is not a valid PDF"`<br>`}]`|PDF file format is required|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can't send letters when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode"`<br>`}]`|Your service cannot send this notification in [trial mode](https://www.notifications.service.gov.uk/using-notify/trial-mode)|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "reference is a required property"`<br>`}]`|Add a `reference` argument to the method call|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "postage invalid. It must be either first or second."`<br>`}]`|Change the value of `postage` argument in the method call to either `'first'` or `'second'`|
|`429`|`[{`<br>`"error": "RateLimitError",`<br>`"message": "Exceeded rate limit for key type live of 10 requests per 20 seconds"`<br>`}]`|Use the correct API key. Refer to [API keys](#api-keys) for more information|
|`429`|`[{`<br>`"error": "TooManyRequestsError",`<br>`"message": "Exceeded send limits (50) for today"`<br>`}]`|Refer to [service limits](#daily-limits) for the limit size|


## Get message status

### Get the status of one message

You can only get the status of messages sent within the retention period. The default retention period is 7 days.

#### Method

```
GET /v2/notifications/{notification_id}
```

#### URL parameters

##### notification_id (required)

The ID of the notification. To find the notification ID, you can either:

* check the response to the [original notification method call](#get-the-status-of-one-message-response).
* [sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in) and go to the __API integration__ page

```
3d1ce039-5476-414c-99b2-fac1e6add62c
```

#### Response

If the request is successful, the response body is `json` and the status code is `200`:

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
    "body": "Hi Amala, your appointment is on 1 January 2018 at 1:00PM",  // required string - body of notification
    "subject": "Your upcoming pigeon registration appointment",  // required string for email - subject of email
    "created_at": "2024-05-17 15:58:38.342838",  // required string - date and time notification created
    "created_by_name": "Charlie Smith",  // optional string - name of the person who sent the notification if sent manually
    "sent_at": "2024-05-17 15:58:30.143000",  // optional string - date and time notification sent to provider
    "completed_at": "2024-05-17 15:59:10.321000",  // optional string - date and time notification delivered or failed
    "scheduled_for": "2024-05-17 9:00:00.000000", // optional string - date and time notification has been scheduled to be sent at
    "one_click_unsubscribe": "https://example.com/unsubscribe.html?opaque=123456789", // optional string, email only - URL that you provided so your recipients can unsubscribe
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
```

#### Error codes

If the request is not successful, the API returns `json` containing the relevant error code. For example:

```javascript
{
  "status_code": 400,
  "errors": [
    {"error": "BadRequestError", "message": "Can't send to this recipient using a team-only API key"}
  ]
}
```

|status_code|Error message|How to fix|
|:---|:---|:---|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "id is not a valid UUID"`<br>`}]`|Check the notification ID|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Error: Your system clock must be accurate to within 30 seconds"`<br>`}]`|Check your system clock|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Invalid token: API key not found"`<br>`}]`|Use the correct API key. Refer to [API keys](#api-keys) for more information|
|`404`|`[{`<br>`"error": "NoResultFound",`<br>`"message": "No result found"`<br>`}]`|Check the notification ID|


### Get the status of multiple messages

This API call returns one page of up to 250 messages and statuses. You can get either the most recent messages, or get older messages by specifying a particular notification ID in the `older_than` argument.

You can only get messages that are within your data retention period. The default data retention period is 7 days. It can be changed in your Service Settings.

```
GET /v2/notifications
```

You can filter the returned messages by including the following optional arguments in the method:

- [`template_type`](#template-type-optional)
- [`status`](#status-optional)
- [`reference`](#get-the-status-of-multiple-messages-arguments-reference-optional)
- [`older_than`](#older-than-optional)
- [`include_jobs`](#include-jobs-optional)

#### Query parameters

You can omit any of these arguments to ignore these filters.

##### template_type (optional)

You can filter by:

* `email`
* `sms`
* `letter`

```
?template_type=email
```

##### status (optional)

You can filter by each:

* [email status](#email-status-descriptions)
* [text message status](#text-message-status-descriptions)
* [letter status](#letter-status-descriptions)
* [precompiled letter status](#precompiled-letter-status-descriptions)

You can leave out this argument to ignore this filter.

You can filter on multiple statuses by repeating the query string.

```
?status=created&status=sending&status=delivered
```

##### reference (optional)

An identifier you can create if necessary. This reference identifies a single unique message or a batch of messages. It must not contain any personal information such as name or postal address. For example:

```javascript
?reference=your%20reference // optional string - reference you provided when sending the message
```

You can leave out this argument to ignore this filter.

##### older_than (optional)

Input a notification ID into this argument. If you use this argument, the method returns the next 250 messages older than the given ID.

```
?older_than=740e5834-3a29-46b4-9a6f-16142fde533a // optional string - notification ID
```

If you leave out this argument, the method returns the most recent 250 messages.

The API only returns messages sent within the retention period. The default retention period is 7 days. If the message specified in this argument was sent before the retention period, the API returns an empty response.

##### include_jobs (optional)

Includes notifications sent as part of a batch upload.

If you leave out this argument, the method only returns notifications sent using the API.

```
?include_jobs=true
```

#### Response

If the request is successful, the response body is `json` and the status code is `200`.

##### All messages

```javascript
{
    "notifications": [
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
            "body": "Hi Amala, your appointment is on 1 January 2018 at 1:00PM",  // required string - body of notification
            "subject": "Your upcoming pigeon registration appointment",  // required string for email - subject of email
            "created_at": "2024-05-17 15:58:38.342838",  // required string - date and time notification created
            "created_by_name": "Charlie Smith",  // optional string - name of the person who sent the notification if sent manually
            "sent_at": "2024-05-17 15:58:30.143000",  // optional string - date and time notification sent to provider
            "completed_at": "2024-05-17 15:59:10.321000",  // optional string - date and time notification delivered or failed
            "scheduled_for": "2024-05-17 9:00:00.000000", // optional string - date and time notification has been scheduled to be sent at
            "one_click_unsubscribe": "https://example.com/unsubscribe.html?opaque=123456789", // optional string, email only - URL that you provided so your recipients can unsubscribe
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
        },
        {
            ...another notification
        }
    ],
    "links": {
        "current": "https://api.notifications.service.gov.uk/v2/notifications?template_type=sms&status=delivered",
        "next": "https://api.notifications.service.gov.uk/v2/notifications?other_than=last_id_in_list&template_type=sms&status=delivered"
    }
}
```

#### Error codes

If the request is not successful, the API returns `json` containing the relevant error code. For example:

```javascript
{
  "status_code": 400,
  "errors": [
    {"error": "BadRequestError", "message": "Can't send to this recipient using a team-only API key"}
  ]
}
```

|status_code|Error message|How to fix|
|:---|:---|:---|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "status ‘elephant’ is not one of [cancelled, created, sending, sent, delivered, pending, failed, technical-failure, temporary-failure, permanent-failure, pending-virus-check, validation-failed, virus-scan-failed, returned-letter, accepted, received]"`<br>`}]`|Change the [status argument](#status-optional)|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "‘Apple’ is not one of [sms, email, letter]"`<br>`}]`|Change the [template_type argument](#template-type-optional)|

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

This returns the PDF contents of a letter.

```
GET /v2/notifications/{notification_id}/pdf
```

#### URL parameters

##### notification_id (required)

The ID of the notification. To find the notification ID, you can either:

* check the response to the [original notification POST call](#response)
* [sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in) and go to the __API integration__ page

```
3d1ce039-5476-414c-99b2-fac1e6add62c
```

#### Response

If the request to the API is successful, the API will return bytes representing the raw PDF data.

#### Error codes

If the request is not successful, the API returns `json` containing the relevant error code. For example:

```javascript
{
  "status_code": 400,
  "errors": [
    {"error": "ValidationError", "message": "Notification is not a letter"}
  ]
}
```

|error.status_code|error.message|How to fix|
|:---|:---|:---|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "id is not a valid UUID"`<br>`}]`|Check the notification ID|
|`400`|`[{`<br>`"error": "PDFNotReadyError",`<br>`"message": "PDF not available yet, try again later"`<br>`}]`|Wait for the letter to finish processing. This usually takes a few seconds|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "File did not pass the virus scan"`<br>`}]`|You cannot retrieve the contents of a letter that contains a virus|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "PDF not available for letters in technical-failure"`<br>`}]`|You cannot retrieve the contents of a letter in technical-failure|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "Notification is not a letter"`<br>`}]`|Check that you are looking up the correct notification|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Error: Your system clock must be accurate to within 30 seconds"`<br>`}]`|Check your system clock|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Invalid token: API key not found"`<br>`}]`|Use the correct API key. Refer to [API keys](#api-keys) for more information|
|`404`|`[{`<br>`"error": "NoResultFound",`<br>`"message": "No result found"`<br>`}]`|Check the notification ID|

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
