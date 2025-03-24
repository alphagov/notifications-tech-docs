# REST API documentation

This documentation is for developers interested in using the GOV.UK Notify API to send emails, text messages or letters.

You can use it to integrate directly with the API if you cannot use one of our 6 client libraries.

Developers can also use [our OpenAPI file](https://github.com/alphagov/notifications-tech-docs/blob/main/openapi/publicapi_spec.json) with tools such as [Swagger](https://swagger.io/) and [Redoc](https://github.com/Redocly/redoc) to assist with using the REST API.  You cannot use Swagger Editor to make test API requests.

## Making a request

### Base URL
```
https://api.notifications.service.gov.uk
```

### Headers

#### Authorisation header

The authorisation header is an [API key](#api-keys) that is encoded using [JSON Web Tokens](https://jwt.io/). You must include an authorisation header.

JSON Web Tokens have a standard header and a payload. The header consists of:

```javascript
{
  "typ": "JWT",
  "alg": "HS256"
}
```

The payload consists of:

```javascript
{
  "iss": "26785a09-ab16-4eb0-8407-a37497a57506",
  "iat": 1568818578
}
```

JSON Web Tokens are encoded using a secret key with the following format:

```
3d844edf-8d35-48ac-975b-e847b4f122b0
```

That secret key forms a part of your [API key](#api-keys), which follows the format `{key_name}-{iss-uuid}-{secret-key-uuid}`.

For example, if your API key is
`my_test_key-26785a09-ab16-4eb0-8407-a37497a57506-3d844edf-8d35-48ac-975b-e847b4f122b0`:

* your API key name is `my_test_key`
* your iss (your service id) is `26785a09-ab16-4eb0-8407-a37497a57506`
* your secret key is `3d844edf-8d35-48ac-975b-e847b4f122b0`

`iat` (issued at) is the current time in UTC in epoch seconds. The token expires within 30 seconds of the current time.

Refer to the [JSON Web Tokens website](https://jwt.io/) for more information on encoding your authorisation header.

When you have an encoded and signed token, add that token to a header as follows:

```javascript
"Authorization": "Bearer encoded_jwt_token"
```

#### Content header

The content header is `application/json`:

```javascript
"Content-type": "application/json"
```

## Send a message

You can use GOV.UK Notify to send emails, text messages and letters.

### Send a text message

#### Method

```
POST /v2/notifications/sms
```

#### Request body

```javascript
{
  "phone_number": "+447900900123",
  "template_id": "f33517ff-2a88-4f6e-b855-c550268ce08a"
}
 ```

#### Arguments

##### phone_number (required)

The phone number of the recipient of the text message. This can be a UK or international number.

For example:

```javascript
"phone_number": "+447900900123"
```

##### template_id (required)

To find the template ID:

1. [Sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in).
1. Go to the __Templates__ page and select the relevant template.
1. Select __Copy template ID to clipboard__.

For example:

```javascript
"template_id": "f33517ff-2a88-4f6e-b855-c550268ce08a"
```

##### personalisation (optional)

If a template has placeholder fields for personalised information such as name or reference number, you must provide their values in a dictionary with key value pairs. For example:

```javascript
"personalisation": {
  "first_name": "Amala",
  "appointment_date": "1 January 2018 at 1:00PM",
}
```

You can leave out this argument if a template does not have any placeholder fields for personalised information.

##### reference (optional)

An identifier you can create if necessary. This reference identifies a single unique message or a batch of messages. It must not contain any personal information such as name or postal address. For example:

```javascript
// optional string - identifies notification(s)
"reference": "your reference"
```

You can leave out this argument if you do not have a reference.

##### sms_sender_id (optional)

A unique identifier of the sender of the text message notification.

To find the text message sender:

1. [Sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in).
1. Go to the __Settings__ page.
1. In the __Text Messages__ section, select __Manage__ on the __Text Message sender__ row.

You can then either:

- copy the sender ID that you want to use and paste it into the method
- select __Change__ to change the default sender that the service will use, and select __Save__

```javascript
"sms_sender_id": "8e222534-7f05-4972-86e3-17c5d9f894e2"
```

You can leave out this argument if your service only has one text message sender, or if you want to use the default sender.

#### Response

If the request is successful, the response body is `json` with a status code of `201`:

```javascript
{
  "id": "740e5834-3a29-46b4-9a6f-16142fde533a",  // required string - notification ID
  "reference": "your reference", // optional string - reference you provided when sending the message
  "content": {
    "body": "Hi Amala, your appointment is on 1 January 2018 at 1:00PM",  // required string - message content
    "from_number": "GOVUK"  // required string - sender name / phone number
  },
  "uri": "https://api.notifications.service.gov.uk/v2/notifications/740e5834-3a29-46b4-9a6f-16142fde533a",  // required string
  "template": {
    "id": "f33517ff-2a88-4f6e-b855-c550268ce08a", // required string - template ID
    "version": 3,  // required integer
    "uri": "https://api.notifications.service.gov.uk/v2/template/f33517ff-2a88-4f6e-b855-c550268ce08a"  // required string
  }
}
```

If you are using the [test API key](#test), all your messages will come back with a `delivered` status.

All messages sent using the [team and guest list](#team-and-guest-list) or [live](#live) keys will appear on your dashboard.

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
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can't send to this recipient using a team-only API key"`<br>`}]`|Use the correct type of [API key](#api-keys)|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can't send to this recipient when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode"`<br>`}]`|Your service cannot send this notification in [trial mode](https://www.notifications.service.gov.uk/using-notify/trial-mode)|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Error: Your system clock must be accurate to within 30 seconds"`<br>`}]`|Check your system clock|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Invalid token: API key not found"`<br>`}]`|Use the correct API key. Refer to [API keys](#api-keys) for more information|
|`429`|`[{`<br>`"error": "RateLimitError",`<br>`"message": "Exceeded rate limit for key type TEAM/TEST/LIVE of 3000 requests per 60 seconds"`<br>`}]`|Refer to [API rate limits](#rate-limits) for more information|
|`429`|`[{`<br>`"error": "TooManyRequestsError",`<br>`"message": "Exceeded send limits (LIMIT NUMBER) for today"`<br>`}]`|Refer to [service limits](#daily-limits) for the limit number|
|`500`|`[{`<br>`"error": "Exception",`<br>`"message": "Internal server error"`<br>`}]`|Notify was unable to process the request, resend your notification.|

### Send an email

#### Method

```
POST /v2/notifications/email
```

#### Request body
```javascript
{
  "email_address": "amala@example.com",
  "template_id": "9d751e0e-f929-4891-82a1-a3e1c3c18ee3"
}
```

#### Arguments

##### email_address (required)

The email address of the recipient.

For example:

```javascript
"email_address": "amala@example.com" // required string
```

##### template_id (required)

To find the template ID:

1. [Sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in).
1. Go to the __Templates__ page and select the relevant template.
1. Select __Copy template ID to clipboard__.

For example:

```javascript
"template_id": "9d751e0e-f929-4891-82a1-a3e1c3c18ee3", // required UUID string
```

##### personalisation (optional)

If a template has placeholder fields for personalised information such as name or reference number, you need to provide their values in a dictionary with key value pairs. For example:

```javascript
"personalisation": {
  "first_name": "Amala",
  "appointment_date": "1 January 2018 at 1:00PM",
  // pass in a list and it will appear as bullet points in the message:
  "required_documents": ["passport", "utility bill", "other id"],
}
```
You can leave out this argument if a template does not have any placeholder fields for personalised information.

Find out how to reduce the risk of malicious content injection in placeholders [here](#reducing-the-risk-of-malicious-content-injection-in-placeholders) 

##### reference (optional)

An identifier you can create if necessary. This reference identifies a single unique email or a batch of emails. It must not contain any personal information such as name or postal address. For example:

```javascript
"reference": "your reference"
```
You can leave out this argument if you do not have a reference.

##### one_click_unsubscribe_url (recommended)

If you send subscription emails you must let recipients opt out of receiving them. Read our Using Notify page for more information about [unsubscribe links](https://www.notifications.service.gov.uk/using-notify/unsubscribe-links).

The one-click unsubscribe URL will be added to the headers of your email. Email s will use it to add an unsubscribe button.

```javascript
"one_click_unsubscribe_url": "https://example.com/unsubscribe.html?opaque=123456789" // optional string, a URL
```
The one-click unsubscribe URL must respond to an empty `POST` request by unsubscribing the user from your emails. You can include query parameters to help you identify the user.

Your unsubscribe URL and response must comply with the guidance specified in [Section 3.1 of IETF RFC 8058](https://www.rfcreader.com/#rfc8058_line139).

You can leave out this argument if the email being sent is not a subscription email.

You must also add an unsubscribe link to the bottom of your email. The unsubscribe link at the bottom of your email should take the email recipient to a webpage where they can confirm that they want to unsubscribe.

Find out how to add a link when you create a __New template__ or __Edit__ an email template.

##### email_reply_to_id (optional)

This is an email address specified by you to receive replies from your users. You must add at least one reply-to email address before your service can go live.

To add a reply-to email address:

1. [Sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in).
1. Go to the __Settings__ page.
1. In the __Email__ section, select __Manage__ on the __Reply-to email addresses__ row.
1. Select __Add reply-to address__.
1. Enter the email address you want to use, and select __Add__.

For example:

```javascript
"email_reply_to_id": "8e222534-7f05-4972-86e3-17c5d9f894e2" // optional UUID string
```

You can leave out this argument if your service only has one reply-to email address, or you want to use the default email address.

#### Response

If the request is successful, the response body is `json` with a status code of `201`:

```javascript
{
  "id": "201b576e-c09b-467b-9dfa-9c3b689ee730",  // required string - notification ID
  "reference": "your reference",  // optional string - reference you provided when sending the message
  "content": {
    "subject": "Your upcoming pigeon registration appointment",  // required string - message subject
    "body": "Dear Amala\r\n\r\nYour pigeon registration appointment is scheduled for 1 January 2018 at 1:00PM.\r\n\r\nPlease bring:\r\n\n\n* passport\n* utility bill\n* other id\r\n\r\nYours,\r\nPigeon Affairs Bureau",  // required string - message content
    "from_email": "pigeon.affairs.bureau@notifications.service.gov.uk",  // required string - "FROM" email address, not a real inbox
    "one_click_unsubscribe_url": "https://example.com/unsubscribe.html?opaque=123456789",  // optional string
  },
  "uri": "https://api.notifications.service.gov.uk/v2/notifications/201b576e-c09b-467b-9dfa-9c3b689ee730",  // required string
  "template": {
    "id": "9d751e0e-f929-4891-82a1-a3e1c3c18ee3",  // required string - template ID
    "version": 1,  // required integer
    "uri": "https://api.notifications.service.gov.uk/v2/template/9d751e0e-f929-4891-82a1-a3e1c3c18ee3"  // required string
  }
}
```


#### Reducing the risk of malicious content injection in placeholders

Notify lets you [personalise messages](https://www.notifications.service.gov.uk/using-notify/personalisation) using placeholders.

You can [format](https://www.notifications.service.gov.uk/using-notify/formatting) content or add links and urls into placeholders using Markdown. 

If you pass in information from untrusted sources (such as online forms) into your Notify template using personalisation, this may be used to add malicious content and links to notifications you send via Notify. 

The malicious content could be:

  * Markdown syntax intended to be rendered into HTML 
  * a plain text URL which would be rendered into a clickable phishing link

An example of how malicious content can be injected into Notify personalisation:

**Template in Notify**:

```
Hello ((name))
```

**Personalisation**: 

```
{name: "Anne Example, now [click this evil link](https://malicious.link)"}
```

**Email will appear as**: 

<pre>
 <small>Dear Anne Example, now <a href="https://malicious.link>click this evil link">click this evil link</a></small>
</pre>


We recommend you sanitise all input from untrusted sources to prevent the injection of malicious content. You can:

1. Use a backslash to escape [individual characters](https://www.markdownguide.org/basic-syntax/#characters-you-can-escape). 
   The characters of most concern are those that could be used to add a URL link such as: “\[”, “\]”, “\(”, "\)".

2. Use the Markdown triple backtick [fenced code blocks](https://www.markdownguide.org/extended-syntax/#fenced-code-blocks) syntax
   to escape all characters within a placeholder. 
   Keep in mind that to use this option, the placeholder needs to be on a separate line from the backticks in the template. 
   It is also a less effective option - an attacker could potentially overcome it by preceding malicious content with triple backticks of their own.
   For it to be effective, the input must be pre-processed to escape triple backticks.

~~~
```
((name))
```
~~~

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
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can't send to this recipient using a team-only API key"`<br>`}]`|Use the correct type of [API key](#api-keys)|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can't send to this recipient when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode"`<br>`}]`|Your service cannot send this notification in [trial mode](https://www.notifications.service.gov.uk/using-notify/trial-mode)|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Error: Your system clock must be accurate to within 30 seconds"`<br>`}]`|Check your system clock|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Invalid token: API key not found"`<br>`}]`|Use the correct API key. Refer to [API keys](#api-keys) for more information|
|`429`|`[{`<br>`"error": "RateLimitError",`<br>`"message": "Exceeded rate limit for key type TEAM/TEST/LIVE of 3000 requests per 60 seconds"`<br>`}]`|Refer to [API rate limits](#rate-limits) for more information|
|`429`|`[{`<br>`"error": "TooManyRequestsError",`<br>`"message": "Exceeded send limits (LIMIT NUMBER) for today"`<br>`}]`|Refer to [service limits](#daily-limits) for the limit number|
|`500`|`[{`<br>`"error": "Exception",`<br>`"message": "Internal server error"`<br>`}]`|Notify was unable to process the request, resend your notification.|


### Send a file by email

To send a file by email, add a placeholder to the template then upload a file. The placeholder will contain a secure link to download the file.

The links are unique and unguessable. GOV.UK Notify cannot access or decrypt your file.

Your file will be available to download for a default period of 26 weeks (6 months).

To help protect your files you can also:

* ask recipients to confirm their email address before downloading
* choose the length of time that a file is available to download

#### Add contact details to the file download page

1. [Sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in).
1. Go to the __Settings__ page.
1. In the __Email__ section, select __Manage__ on the __Send files by email__ row.
1. Enter the contact details you want to use, and select __Save__.

#### Add a placeholder to the template

1. [Sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in).
1. Go to the __Templates__ page and select the relevant email template.
1. Select __Edit__.
1. Add a placeholder to the email template using double brackets. For example: "Download your file at: ((link_to_file))"

Your email should also tell recipients how long the file will be available to download.

#### Upload your file

You can upload the following file types:

- CSV (.csv)
- image (.jpeg, .jpg, .png)
- Microsoft Excel Spreadsheet (.xlsx)
- Microsoft Word Document (.doc, .docx)
- PDF (.pdf)
- text (.json, .odt, .rtf, .txt)


Your file must be smaller than 2MB. [Contact the GOV.UK Notify team](https://www.notifications.service.gov.uk/support) if you need to send other file types.

You’ll need to convert the file into a string that is base64 encoded.

Pass the encoded string into an object with a `file` key, and put that in the personalisation argument. For example:

```javascript
"personalisation":{
  "first_name": "Amala",
  "appointment_date": "1 January 2018 at 1:00PM",
  "link_to_file": {"file": "file as base64 encoded string"}
}
```

#### Set the filename

You should provide a filename when you upload your file.

The filename should tell the recipient what the file contains. A memorable filename can help the recipient to find the file again later.

The filename must end with a file extension. For example, `.csv` for a CSV file. If you include the wrong file extension, recipients may not be able to open your file.

If you do not provide a filename for your file, Notify will:

* generate a random filename
* try to add the correct file extension

If Notify cannot add the correct file extension, recipients may not be able to open your file.

```javascript
"personalisation":{
  "first_name": "Amala",
  "appointment_date": "1 January 2018 at 1:00PM",
  "link_to_file": {"file": "CSV file as base64 encoded string", "filename": "amala_pigeon_affairs_bureau_invite.csv"}
}
```

#### Ask recipients to confirm their email address before they can download the file

When a recipient clicks the link in the email you’ve sent them, they have to enter their email address. Only someone who knows the recipient’s email address can download the file.

This security feature is turned on by default.

##### Turn off email address check (not recommended)

If you do not want to use this feature, you can turn it off on a file-by-file basis.

You should not turn this feature off if you send files that contain:

* personally identifiable information
* commercially sensitive information
* information classified as ‘OFFICIAL’ or ‘OFFICIAL-SENSITIVE’ under the [Government Security Classifications](https://www.gov.uk/government/publications/government-security-classifications) policy

To let the recipient download the file without confirming their email address, set the `confirm_email_before_download` flag to `false`.


```javascript
"personalisation":{
  "first_name": "Amala",
  "appointment_date": "1 January 2018 at 1:00PM",
  "link_to_file": {"file": "file as base64 encoded string", "confirm_email_before_download": false}
}
```

#### Choose the length of time that a file is available to download

Set the number of weeks you want the file to be available using the `retention_period` key.

You can choose any value between 1 week and 78 weeks. When deciding this, you should consider:

* the need to protect the recipient’s personal information
* whether the recipient will need to download the file again later

If you do not choose a value, the file will be available for the default period of 26 weeks (6 months).

Files sent before 12 April 2023 had a longer default period of 78 weeks (18 months).

```javascript
"personalisation":{
  "first_name": "Amala",
  "appointment_date": "1 January 2018 at 1:00PM",
  "link_to_file": {"file": "file as base64 encoded string", "retention_period": "4 weeks"}
}
```

#### Response

If the request is successful, the response body is `json` with a status code of `201`:

```javascript
{
  "id": "201b576e-c09b-467b-9dfa-9c3b689ee730",  // required string - notification ID
  "reference": "your reference",  // optional string - reference you provided when sending the message
  "content": {
    "subject": "Your upcoming pigeon registration appointment",  // required string - message subject
    "body": "Dear Amala\r\n\r\nYour pigeon registration appointment is scheduled for 1 January 2018 at 1:00PM.\r\n\r\n Here is a link to your invitation document:\r\nhttps://documents.service.gov.uk/d/YlxDzgNUQYi1Qg6QxIpptA/th46VnrvRxyVO9div6f7hA?key=R0VDmwJ1YzNYFJysAIjQd9yHn5qKUFg-nXHVe3Ioa3A\r\n\r\nPlease bring the invite with you to the appointment.\r\n\r\nYours,\r\nPigeon Affairs Bureau",  // required string - message content - see that the link to document is embedded in the message content
    "from_email": "pigeon.affairs.bureau@notifications.service.gov.uk",  // required string - "FROM" email address, not a real inbox
    "one_click_unsubscribe_url": "https://example.com/unsubscribe.html?opaque=123456789",  // optional string
  },
  "uri": "https://api.notifications.service.gov.uk/v2/notifications/201b576e-c09b-467b-9dfa-9c3b689ee730",  // required string
  "template": {
    "id": "9d751e0e-f929-4891-82a1-a3e1c3c18ee3",  // required string - template ID
    "version": 1,  // required integer
    "uri": "https://api.notifications.service.gov.uk/v2/template/9d751e0e-f929-4891-82a1-a3e1c3c18ee3"  // required string
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
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can't send to this recipient using a team-only API key"`<br>`}]`|Use the correct type of [API key](#api-keys)|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can't send to this recipient when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode"`<br>`}]`|Your service cannot send this notification in [trial mode](https://www.notifications.service.gov.uk/using-notify/trial-mode)|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Unsupported file type '(FILE TYPE)'. Supported types are: '(ALLOWED TYPES)"`<br>`}]`|Wrong file type. You can only upload certain file formats.|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>```"message": "`filename` cannot be longer than 100 characters"```<br>`}]`|Choose a shorter filename|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>```"message": "`filename` must end with a file extension. For example, filename.csv"```<br>`}]`|Include the file extension in your filename|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Unsupported value for retention_period '(PERIOD)'. Supported periods are from 1 to 78 weeks."`<br>`}]`|Choose a period between 1 and 78 weeks|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Unsupported value for confirm_email_before_download: '(VALUE)'. Use a boolean true or false value."`<br>`}]`|Use either true or false|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "File did not pass the virus scan"`<br>`}]`|The file contains a virus|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Send files by email has not been set up - add contact details for your service at https://www.notifications.service.gov.uk/services/(SERVICE ID)/service-settings/send-files-by-email"`<br>`}]`|See how to [add contact details to the file download page](#add-contact-details-to-the-file-download-page)|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can only send a file by email"`<br>`}]`|Make sure you are using an email template|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Error: Your system clock must be accurate to within 30 seconds"`<br>`}]`|Check your system clock|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Invalid token: API key not found"`<br>`}]`|Use the correct API key. Refer to [API keys](#api-keys) for more information|
|`429`|`[{`<br>`"error": "RateLimitError",`<br>`"message": "Exceeded rate limit for key type TEAM/TEST/LIVE of 3000 requests per 60 seconds"`<br>`}]`|Refer to [API rate limits](#rate-limits) for more information|
|`429`|`[{`<br>`"error": "TooManyRequestsError",`<br>`"message": "Exceeded send limits (LIMIT NUMBER) for today"`<br>`}]`|Refer to [service limits](#daily-limits) for the limit number|
|`500`|`[{`<br>`"error": "Exception",`<br>`"message": "Internal server error"`<br>`}]`|Notify was unable to process the request, resend your notification.|

### Send a letter

When you add a new service it will start in [trial mode](https://www.notifications.service.gov.uk/using-notify/trial-mode). You can only send letters when your service is live.

To send Notify a request to go live:

1. [Sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in).
1. Go to the __Settings__ page.
1. In the __Your service is in trial mode__ section, select __request to go live__.

#### Method

```
POST /v2/notifications/letter
```

#### Request body

```javascript
{
  "template_id": "64415853-cb86-4cc4-b597-2aaa94ef8c39",
  "personalisation": {
    "address_line_1": "Amala Bird",
    "address_line_2": "123 High Street",
    "address_line_3": "SW14 6BH"
  }
}
```

#### Arguments

##### template_id (required)

To find the template ID:

1. [Sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in).
1. Go to the __Templates__ page and select the relevant template.
1. Select __Copy template ID to clipboard__.


For example:

```javascript
"template_id": "9d751e0e-f929-4891-82a1-a3e1c3c18ee3", // required UUID string
```

##### personalisation (required)

The personalisation argument always contains the following parameters for the letter recipient’s address:

- `address_line_1`
- `address_line_2`
- `address_line_3`
- `address_line_4`
- `address_line_5`
- `address_line_6`
- `address_line_7`

The address must have at least 3 lines.

The last line needs to be a real UK postcode or the name of a country outside the UK.

Notify checks for international addresses and will automatically charge you the correct postage.

The `postcode` personalisation argument has been replaced. If your template still uses `postcode`, Notify will treat it as the last line of the address.

Any other placeholder fields included in the letter template also count as required parameters. You need to provide their values in a dictionary with key value pairs. For example:

```javascript
"personalisation": {
  "address_line_1": "Amala Bird",  // required string
  "address_line_2": "123 High Street",  // required string
  "address_line_3": "Richmond upon Thames",  // required string
  "address_line_4": "Middlesex",
  "address_line_5": "SW14 6BF",  // last line of address you include must be a postcode or a country name  outside the UK
  "name": "Amala",
  "appointment_date": "1 January 2018 at 1:00PM",
  // pass in a list and it will appear as bullet points in the letter:
  "required_documents": ["passport", "utility bill", "other id"]
}
```

##### reference (optional)

An identifier you can create if necessary. This reference identifies a single unique letter or a batch of letters. It must not contain any personal information such as name or postal address. For example:

```javascript
"reference": "your reference" // optional string - identifies notification(s)
```

#### Response

If the request is successful, the response body is `json` and the status code is `201`:

```javascript
{
  "id": "3d1ce039-5476-414c-99b2-fac1e6add62c",  // required string - notification ID
  "reference": "your reference",  // optional string - reference you provided when sending the message
  "content": {
    "subject": "Your upcoming pigeon registration appointment",  // required string - letter heading
    "body": "Dear Amala\r\n\r\nYour pigeon registration appointment is scheduled for 1 January 2018 at 1:00PM.\r\n\r\nPlease bring:\r\n\n\n* passport\n* utility bill\n* other id\r\n\r\nYours,\r\nPigeon Affairs Bureau",  // required string - letter content
  },
  "uri": "https://api.notifications.service.gov.uk/v2/notifications/3d1ce039-5476-414c-99b2-fac1e6add62c",  // required string
  "template": {
    "id": "64415853-cb86-4cc4-b597-2aaa94ef8c39",  // required string - template ID
    "version": 3,  // required integer
    "uri": "https://api.notifications.service.gov.uk/v2/template/64415853-cb86-4cc4-b597-2aaa94ef8c39"  // required string
  },
  "scheduled_for": null
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
|`403`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can't send letters with a team API key"`<br>`}]`|Use the correct type of [API key](#api-keys).|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can't send letters when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode"`<br>`}]`|Your service cannot send this notification in  [trial mode](https://www.notifications.service.gov.uk/using-notify/trial-mode).|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "personalisation address_line_1 is a required property"`<br>`}]`|Ensure that your template has a field for the first line of the address, check [personalisation](#personalisation-required) for more information.|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "Must be a real UK postcode"`<br>`}]`|Ensure that the value for the last line of the address is a real UK postcode.|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "Last line of address must be a real UK postcode or another country"`<br>`}]`|Ensure that the value for the last line of the address is a real UK postcode or the name of a country outside the UK.|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Error: Your system clock must be accurate to within 30 seconds"`<br>`}]`|Check your system clock.|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Invalid token: API key not found"`<br>`}]`|Use the correct API key. Refer to [API keys](#api-keys) for more information.|
|`429`|`[{`<br>`"error": "RateLimitError",`<br>`"message": "Exceeded rate limit for key type TEAM/TEST/LIVE of 3000 requests per 60 seconds"`<br>`}]`|Refer to [API rate limits](#rate-limits) for more information.|
|`429`|`[{`<br>`"error": "TooManyRequestsError",`<br>`"message": "Exceeded send limits (LIMIT NUMBER) for today"`<br>`}]`|Refer to [service limits](#daily-limits) for the limit number.|
|`500`|`[{`<br>`"error": "Exception",`<br>`"message": "Internal server error"`<br>`}]`|Notify was unable to process the request, resend your notification.|

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
|`429`|`[{`<br>`"error": "TooManyRequestsError",`<br>`"message": "Exceeded send limits (50) for today"`<br>`}]`|Refer to [service limits](#daily-limits) for the limit number|


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
