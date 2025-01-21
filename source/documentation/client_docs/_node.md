# Node.js client documentation

This documentation is for developers interested in using the GOV.UK Notify Node.js client to send emails, text messages or letters.

## Set up the client

### Install the client

Run the following in the command line:

```shell
npm install --save notifications-node-client
```

### Create a new instance of the client

Add this code to your application:

```javascript
let NotifyClient = require("notifications-node-client").NotifyClient;

let notifyClient = new NotifyClient(apiKey);
```

#### Arguments

##### api_key (required)

To get an API key, [sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in) and go to the __API integration__ page. You can find more information in the [API keys](#api-keys) section of this documentation.


#### Connect through a proxy (optional)

Add this code to your application:

```javascript
const proxyConfig = {
  host: proxyHost,
  port: proxyPort
};

notifyClient.setProxy(proxyConfig);
```

where the `proxyConfig` should be an object supported by [axios](https://github.com/axios/axios).

#### Provide your own underlying Axios client (optional)

You can provide your own Axios client to the Notify client. This is useful if you want to use a custom Axios client with specific settings, like custom interceptors.

Add this code to your application:

```javascript
notifyClient.setClient(customAxiosClient);
```

where `customAxiosClient` is an instance of Axios.

## Send a message

You can use GOV.UK Notify to send emails, text messages and letters.

### Send a text message

#### Method

```javascript
notifyClient
  .sendSms(templateId, phoneNumber, {
    personalisation: personalisation,
    reference: reference,
    smsSenderId: smsSenderId
  })
  .then(response => console.log(response))
  .catch(err => console.error(err));
```

The method returns a [promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Using_promises). The promise will either:

- resolve with a `response` if successful
- fail with an `err` if unsuccessful

#### Arguments

##### phoneNumber (required)

The phone number of the recipient of the text message. This can be a UK or international number.

For example:
```javascript
let phoneNumber = "+447900900123";
```

##### templateId (required)

To find the template ID:

1. [Sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in).
1. Go to the __Templates__ page and select the relevant template.
1. Select __Copy template ID to clipboard__.

For example:

```javascript
let templateId = "f33517ff-2a88-4f6e-b855-c550268ce08a"; // required UUID string
```

##### personalisation (optional)

If a template has placeholder fields for personalised information such as name or reference number, you must provide their values in an `object`. For example:

```javascript
let personalisation = {
    first_name: "Amala",
    appointment_date: "1 January 2018 at 1:00pm"
};
```

##### reference (optional)

A unique identifier you can create if necessary. This reference identifies a single unique message or a batch of messages. It must not contain any personal information such as name or postal address. For example:

```javascript
let reference = "your reference"; // optional string - identifies notification(s)
```

##### smsSenderId (optional)

A unique identifier of the sender of the text message.

To find the text message sender:

1. [Sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in).
1. Go to the __Settings__ page.
1. In the __Text Messages__ section, select __Manage__ on the __Text Message sender__ row.

You can then either:

- copy the sender ID that you want to use and paste it into the method
- select __Change__ to change the default sender that the service will use, and select __Save__

```javascript
let smsSenderId = "8e222534-7f05-4972-86e3-17c5d9f894e2";
```

You can leave out this argument if your service only has one text message sender, or if you want to use the default sender.


#### Response

If the request is successful, the promise resolves with a `response` `object`. For example, the `response.data` property will look like this:

```javascript
{
    "id": "740e5834-3a29-46b4-9a6f-16142fde533a", // required string - notification ID
    "reference": "your reference", // optional string - reference you provided when sending the message
    "content": {
        "body": "Hi Amala, your appointment is on 1 January 2018 at 1:00pm", // required string - message content
        "from_number": "GOVUK" // required string - sender name / phone number
    },
    "uri": "https://api.notifications.service.gov.uk/v2/notifications/740e5834-3a29-46b4-9a6f-16142fde533a", // required string
    "template": {
        "id": "f33517ff-2a88-4f6e-b855-c550268ce08a", // required string - template ID
        "version": 3, // required integer
        "uri": "https://api.notifications.service.gov.uk/v2/template/f33517ff-2a88-4f6e-b855-c550268ce08a" // required string
    }
};
```

If you are using the [test API key](#test), all your messages will come back with a `delivered` status.

All messages sent using the [team and guest list](#team-and-guest-list) or [live](#live) keys will appear on your dashboard.

#### Error codes

If the request is not successful, the promise fails with an `err`.

|err.response.data.status_code|err.response.data.errors|How to fix|
|:---|:---|:---|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can't send to this recipient using a team-only API key"`<br>`}]`|Use the correct type of [API key](#api-keys)|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can't send to this recipient when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode"`<br>`}]`|Your service cannot send this notification in [trial mode](https://www.notifications.service.gov.uk/using-notify/trial-mode)|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Error: Your system clock must be accurate to within 30 seconds"`<br>`}]`|Check your system clock|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Invalid token: API key not found"`<br>`}]`|Use the correct API key. Refer to [API keys](#api-keys) for more information|
|`429`|`[{`<br>`"error": "RateLimitError",`<br>`"message": "Exceeded rate limit for key type TEAM/TEST/LIVE of 3000 requests per 60 seconds"`<br>`}]`|Refer to [API rate limits](#rate-limits) for more information|
|`429`|`[{`<br>`"error": "TooManyRequestsError",`<br>`"message": "Exceeded send limits (LIMIT NUMBER) for today"`<br>`}]`|Refer to [service limits](#daily-limits) for the limit number|
|`500`|`[{`<br>`"error": "Exception",`<br>`"message": "Internal server error"`<br>`}]`|Notify was unable to process the request, resend your notification|

### Send an email

#### Method

```javascript
let options = {
    personalisation: {
        first_name: "Amala",
        appointment_date: "1 January 2018 at 1:00pm",
        required_documents: ["passport", "utility bill", "other id"]
    },
    reference: "your reference",
    oneClickUnsubscribeURL: "https://example.com/unsubscribe.html?opaque=123456789",
    emailReplyToId: "ca4fdde7-2a67-4a6c-8393-62aa7245751f" 
};

notifyClient
  .sendEmail(templateId, emailAddress, options) // Pass options as the third argument (optional)
  .then(response => console.log(response))
  .catch(err => console.error(err));
```

The method returns a [promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Using_promises). The promise will either:

- resolve with a `response` if successful
- fail with an `err` if unsuccessful

#### Arguments

##### emailAddress (required)

The email address of the recipient. For example:

```javascript
let emailAddress = "amala@example.com";
```

##### templateId (required)

To find the template ID:

1. [Sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in).
1. Go to the __Templates__ page and select the relevant template.
1. Select __Copy template ID to clipboard__.

For example:

```javascript
let templateId = "9d751e0e-f929-4891-82a1-a3e1c3c18ee3";
```

##### personalisation (optional)

If a template has placeholder fields for personalised information such as name or application date, you must provide their values in an `object`. For example:

```javascript
let options = {
    personalisation: {
        first_name: "Amala",
        appointment_date: "1 January 2018 at 1:00pm",
        required_documents: ["passport", "utility bill", "other id"] 
    },
};
```

Note: if you pass a list like `required_documents` in the example above, it will appear as bullet points in your message.

##### reference (optional)

A unique identifier you can create if necessary. This reference identifies a single unique email or a batch of emails. It must not contain any personal information such as name or postal address. For example:

```javascript
let options = {
    reference: "your-reference"
};
```

##### oneClickUnsubscribeURL (recommended)

If you send subscription emails you must let recipients opt out of receiving them. Read our Using Notify page for more information about [unsubscribe links](https://www.notifications.service.gov.uk/using-notify/unsubscribe-links).

The one-click unsubscribe URL will be added to the headers of your email. Email clients will use it to add an unsubscribe button.

```javascript
let options = {
    oneClickUnsubscribeURL: "https://example.com/unsubscribe.html?opaque=123456789"
};
```

The one-click unsubscribe URL must respond to an empty `POST` request by unsubscribing the user from your emails. You can include query parameters to help you identify the user.

Your unsubscribe URL and response must comply with the guidance specified in [Section 3.1 of IETF RFC 8058](https://www.rfcreader.com/#rfc8058_line139).

You can leave out this argument if the email being sent is not a subscription email.

You should also add an unsubscribe link to the bottom of your email. Find out how to add an unsubscribe link when you create a __New template__ or __Edit__ an email template. 

You must also add an unsubscribe link to the bottom of your email. The unsubscribe link at the bottom of your email should take the email recipient to a webpage where they can confirm that they want to unsubscribe.  

Find out how to add a link when you create a __New template__ or __Edit__ an email template. 

##### emailReplyToId (optional)

This is an email address specified by you to receive replies from your users. You must add at least one reply-to email address before your service can go live.

To add a reply-to email address:

1. [Sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in).
1. Go to the __Settings__ page.
1. In the __Email__ section, select __Manage__ on the __Reply-to email addresses__ row.
1. Select __Add reply-to address__.
1. Enter the email address you want to use, and select __Add__.


```javascript
let options = {
    emailReplyToId:"ca4fdde7-2a67-4a6c-8393-62aa7245751f"
};
```

You can leave out this argument if your service only has one reply-to email address, or you want to use the default email address.

#### Response

If the request is successful, the promise resolves with a `response` `object`. For example, the `response.data` property will look like this:

```javascript
{
    "id": "201b576e-c09b-467b-9dfa-9c3b689ee730", // required string - notification ID
    "reference": "your reference", // optional string - reference you provided when sending the message
    "content": {
        "subject": "Your upcoming pigeon registration appointment",  // required string - message subject
        "body": "Dear Amala\r\n\r\nYour pigeon registration appointment is scheduled for 1 January 2018 at 1:00pm.\r\n\r\nPlease bring:\r\n\n\n* passport\n* utility bill\n* other id\r\n\r\nYours,\r\nPigeon Affairs Bureau",  // required string - message content
        "from_email": "pigeon.affairs.bureau@notifications.service.gov.uk", // required string - "FROM" email address, not a real inbox
        "one_click_unsubscribe_url": "https://example.com/unsubscribe.html?opaque=123456789" // optional string
    },
    "uri": "https://api.notifications.service.gov.uk/v2/notifications/201b576e-c09b-467b-9dfa-9c3b689ee730", // required string
    "template": {
        "id": "9d751e0e-f929-4891-82a1-a3e1c3c18ee3", // required string - template ID
        "version": 1, // required integer
        "uri": "https://api.notifications.service.gov.uk/v2/template/9d751e0e-f929-4891-82a1-a3e1c3c18ee3" // required string
    }
};
```

#### Error codes

If the request is not successful, the promise fails with an `err`.

|err.response.data.status_code|err.response.data.errors|How to fix|
|:--- |:---|:---|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can't send to this recipient using a team-only API key"`<br>`}]`|Use the correct type of [API key](#api-keys)|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can't send to this recipient when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode"`<br>`}]`|Your service cannot send this notification in [trial mode](https://www.notifications.service.gov.uk/using-notify/trial-mode)|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Error: Your system clock must be accurate to within 30 seconds"`<br>`}]`|Check your system clock|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Invalid token: API key not found"`<br>`}]`|Use the correct API key. Refer to [API keys](#api-keys) for more information|
|`429`|`[{`<br>`"error": "RateLimitError",`<br>`"message": "Exceeded rate limit for key type TEAM/TEST/LIVE of 3000 requests per 60 seconds"`<br>`}]`|Refer to [API rate limits](#rate-limits) for more information|
|`429`|`[{`<br>`"error": "TooManyRequestsError",`<br>`"message": "Exceeded send limits (LIMIT NUMBER) for today"`<br>`}]`|Refer to [service limits](#daily-limits) for the limit number|
|`500`|`[{`<br>`"error": "Exception",`<br>`"message": "Internal server error"`<br>`}]`|Notify was unable to process the request, resend your notification|

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

Pass the file object as a value into the `personalisation` argument. For example:

```javascript
let fs = require("fs")

fs.readFile("path/to/document.pdf", function (err, pdfFile) {
  console.log(err)
  notifyClient.sendEmail(templateId, emailAddress, {
    personalisation: {
      first_name: "Amala",
      appointment_date: "1 January 2018 at 1:00pm",
      link_to_file: notifyClient.prepareUpload(pdfFile)
    }
  }).then(response => console.log(response)).catch(err => console.error(err))
})
```

The method returns a [promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Using_promises). The promise will either:

- resolve with a `response` if successful
- fail with an `err` if unsuccessful

#### Set the filename

To do this you will need version 8.0.0 of the Node client library, or a more recent version.

You should provide a filename when you upload your file.

The filename should tell the recipient what the file contains. A memorable filename can help the recipient to find the file again later.

The filename must end with a file extension. For example, `.csv` for a CSV file. If you include the wrong file extension, recipients may not be able to open your file.

If you do not provide a filename for your file, Notify will:

* generate a random filename
* try to add the correct file extension

If Notify cannot add the correct file extension, recipients may not be able to open your file.

```javascript
let fs = require("fs")
fs.readFile("path/to/document.csv", function (err, csvFile) {
  console.log(err)
  notifyClient.sendEmail(templateId, emailAddress, {
    personalisation: {
      first_name: "Amala",
      appointment_date: "1 January 2018 at 1:00pm",
      link_to_file: notifyClient.prepareUpload(csvFile, { filename: "amala_pigeon_affairs_bureau_invite.csv" })
    }
  }).then(response => console.log(response)).catch(err => console.error(err))
})
```

#### Ask recipients to confirm their email address before they can download the file

When a recipient clicks the link in the email you’ve sent them, they have to enter their email address. Only someone who knows the recipient’s email address can download the file.

This security feature is turned on by default.

##### Turn off email address check (not recommended)

If you do not want to use this feature, you can turn it off on a file-by-file basis.

To do this you will need version 5.2.0 of the Node.js client library, or a more recent version.

You should not turn this feature off if you send files that contain:

* personally identifiable information
* commercially sensitive information
* information classified as ‘OFFICIAL’ or ‘OFFICIAL-SENSITIVE’ under the [Government Security Classifications](https://www.gov.uk/government/publications/government-security-classifications) policy

To let the recipient download the file without confirming their email address, set the `confirmEmailBeforeDownload` option to `false`.

```javascript
let fs = require("fs")

fs.readFile("path/to/document.pdf", function (err, pdfFile) {
  console.log(err)
  notifyClient.sendEmail(templateId, emailAddress, {
    personalisation: {
      first_name: "Amala",
      appointment_date: "1 January 2018 at 1:00pm",
      link_to_file: notifyClient.prepareUpload(pdfFile, { confirmEmailBeforeDownload: false })
    }
  }).then(response => console.log(response)).catch(err => console.error(err))
})
```

#### Choose the length of time that a file is available to download

Set the number of weeks you want the file to be available using the `retentionPeriod` option.

To use this feature will need version 5.2.0 of the Node.js client library, or a more recent version.

You can choose any value between 1 week and 78 weeks. When deciding this, you should consider:

* the need to protect the recipient’s personal information
* whether the recipient will need to download the file again later

If you do not choose a value, the file will be available for the default period of 26 weeks (6 months).

Files sent before 12 April 2023 had a longer default period of 78 weeks (18 months).

```javascript
let fs = require("fs")

fs.readFile("path/to/document.pdf", function (err, pdfFile) {
  console.log(err)
  notifyClient.sendEmail(templateId, emailAddress, {
    personalisation: {
      first_name: "Amala",
      appointment_date: "1 January 2018 at 1:00pm",
      link_to_file: notifyClient.prepareUpload(pdfFile, { retentionPeriod: "52 weeks" })
    }
  }).then(response => console.log(response)).catch(err => console.error(err))
})
```

#### Response

If the request is successful, the promise resolves with a `response` `object`. For example, the `response.data` property will look like this:

```javascript
{
  "id": "201b576e-c09b-467b-9dfa-9c3b689ee730",  // required string - notification ID
  "reference": "your reference",  // optional string - reference you provided when sending the message
  "content": {
    "subject": "Your upcoming pigeon registration appointment",  // required string - message subject
    "body": "Dear Amala\r\n\r\nYour pigeon registration appointment is scheduled for 1 January 2018 at 1:00pm.\r\n\r\n Here is a link to your invitation document:\r\nhttps://documents.service.gov.uk/d/YlxDzgNUQYi1Qg6QxIpptA/th46VnrvRxyVO9div6f7hA?key=R0VDmwJ1YzNYFJysAIjQd9yHn5qKUFg-nXHVe3Ioa3A\r\n\r\nPlease bring the invite with you to the appointment.\r\n\r\nYours,\r\nPigeon Affairs Bureau",  // required string - message content - see that the link to document is embedded in the message content
    "from_email": "pigeon.affairs.bureau@notifications.service.gov.uk",  // required string - "FROM" email address, not a real inbox
    "one_click_unsubscribe": "https://example.com/unsubscribe.html?opaque=123456789",  // optional string
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

If the request is not successful, the promise fails with an `err`.

|err.response.data.status_code|err.response.data.errors|How to fix|
|:---|:---|:---|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can't send to this recipient using a team-only API key"`<br>`}]`|Use the correct type of [API key](#api-keys)|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can't send to this recipient when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode"`<br>`}]`|Your service cannot send this notification in [trial mode](https://www.notifications.service.gov.uk/using-notify/trial-mode)|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Unsupported file type '(FILE TYPE)'. Supported types are: '(ALLOWED TYPES)'"`<br>`}]`|Wrong file type. You can only upload .csv, .doc, .docx, .jpeg, .jpg, .odt, .pdf, .png, .rtf, .txt or .xlsx files|
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
|`N/A`|`File is larger than 2MB`|The file is too big. Files must be smaller than 2MB|

### Send a letter

When you add a new service it will start in [trial mode](https://www.notifications.service.gov.uk/using-notify/trial-mode). You can only send letters when your service is live.

To send Notify a request to go live:

1. [Sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in).
1. Go to the __Settings__ page.
1. In the __Your service is in trial mode__ section, select __request to go live__.

#### Method

```javascript
notifyClient
  .sendLetter(templateId, {
    personalisation: personalisation,
    reference: reference
  })
  .then(response => console.log(response))
  .catch(err => console.error(err))
```

The method returns a [promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Using_promises). The promise will either:

- resolve with a `response` if successful
- fail with an `err` if unsuccessful

#### Arguments

##### templateId (required)

To find the template ID:

1. [Sign in to GOV.UK Notify](https://www.notifications.service.gov.uk/sign-in).
1. Go to the __Templates__ page and select the relevant template.
1. Select __Copy template ID to clipboard__.

For example:

```javascript
let templateId = "64415853-cb86-4cc4-b597-2aaa94ef8c39";
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

Any other placeholder fields included in the letter template also count as required parameters. You must provide their values in an `object`. For example:

```javascript
{
  personalisation: {
    "address_line_1": "Amala Bird", // required string
    "address_line_2": "123 High Street", // required string
    "address_line_3": "Richmond upon Thames", // required string
    "address_line_4": "Middlesex",
    "address_line_5": "SW14 6BF",  // last line of address you include must be a postcode or a country name  outside the UK
    "name": "Amala",
    "appointment_date": "1 January 2018 at 1:00pm",
    // pass in an array and it will appear as bullet points in the letter:
    "required_documents": ["passport", "utility bill", "other id"]
  }
}
```

##### reference (optional)

A unique identifier you can create if required. This reference identifies a single unique notification or a batch of notifications. It must not contain any personal information such as name or postal address. For example:

```javascript
let reference = "your_reference_here";
```

#### Response

If the request is successful, the promise resolves with a `response` `object`. For example, the `response.data` property will look like this:

```javascript
{
    "id": "3d1ce039-5476-414c-99b2-fac1e6add62c",  // required string - notification ID
    "reference": "your reference",  // optional string - reference you provided when sending the message
    "content": {
        "subject": "Your upcoming pigeon registration appointment",  // required string - letter heading
        "body": "Dear Amala\r\n\r\nYour pigeon registration appointment is scheduled for 1 January 2018 at 1:00pm.\r\n\r\nPlease bring:\r\n\n\n* passport\n* utility bill\n* other id\r\n\r\nYours,\r\nPigeon Affairs Bureau",  // required string - letter content
    },
    "uri": "https://api.notifications.service.gov.uk/v2/notifications/3d1ce039-5476-414c-99b2-fac1e6add62c",  // required string
    "template": {
        "id": "64415853-cb86-4cc4-b597-2aaa94ef8c39",  // required string - template ID
        "version": 3,  // required integer
        "uri": "https://api.notifications.service.gov.uk/v2/template/64415853-cb86-4cc4-b597-2aaa94ef8c39"  // required string
    }
}
```

#### Error codes

If the request is not successful, the promise fails with an `err`.

|err.response.data.status_code|err.response.data.errors|How to fix|
|:--- |:---|:---|
|`403`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Cannot send letters with a team api key"`<br>`}]`|Use the correct type of [API key](#api-keys).|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Cannot send letters when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode"`<br>`}]`|Your service cannot send this notification in [trial mode](https://www.notifications.service.gov.uk/using-notify/trial-mode).|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "personalisation address_line_1 is a required property"`<br>`}]`|Ensure that your template has a field for the first line of the address, refer to [personalisation](#send-a-letter-arguments-personalisation-required) for more information.|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "Must be a real UK postcode"`<br>`}]`|Ensure that the value for the last line of the address is a real UK postcode.|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "Last line of address must be a real UK postcode or another country"`<br>`}]`|Ensure that the value for the last line of the address is a real UK postcode or the name of a country outside the UK.|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Error: Your system clock must be accurate to within 30 seconds"`<br>`}]`|Check your system clock.|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Invalid token: API key not found"`<br>`}]`|Use the correct API key. Refer to [API keys](#api-keys) for more information.|
|`429`|`[{`<br>`"error": "RateLimitError",`<br>`"message": "Exceeded rate limit for key type TEAM/TEST/LIVE of 3000 requests per 60 seconds"`<br>`}]`|Refer to [API rate limits](#rate-limits) for more information.|
|`429`|`[{`<br>`"error": "TooManyRequestsError",`<br>`"message": "Exceeded send limits (LIMIT NUMBER) for today"`<br>`}]`|Refer to [service limits](#daily-limits) for the limit number.|
|`500`|`[{`<br>`"error": "Exception",`<br>`"message": "Internal server error"`<br>`}]`|Notify was unable to process the request, resend your notification.|


### Send a precompiled letter

#### Method

```javascript
let response = notifyClient.sendPrecompiledLetter(
  reference,
  pdfFile,
  postage
)
```

#### Arguments

##### reference (required)

A unique identifier you create. This reference identifies a single unique notification or a batch of notifications. It must not contain any personal information such as name or postal address. For example:

```javascript
let reference = "your reference";
```

##### pdfFile (required)

The precompiled letter must be a PDF file which meets [the GOV.UK Notify letter specification](https://www.notifications.service.gov.uk/using-notify/guidance/letter-specification). For example:

```javascript
let fs = require("fs")

fs.readFile("path/to/document.pdf", function (err, pdfFile) {
  if (err) {
    console.error(err)
  }
  let notification = notifyClient.sendPrecompiledLetter(
    "your reference", pdfFile
  )
})
```

##### postage (optional)

You can choose first or second class postage for your precompiled letter. Set the value to `first` for first class, or `second` for second class. If you do not pass in this argument, the postage will default to second class.

```javascript
let postage = "first";
```

#### Response

If the request is successful, the promise resolves with a `response` `object`. For example, the `response.data` property will look like this:

```javascript
{
    "id": "1d986ba7-fba6-49fb-84e5-75038a1dd968",  // required string - notification ID
    "reference": "your reference",  // required string - reference your provided
    "postage": "first"  // required string - postage you provided, or else default postage for the letter
}
```

#### Error codes

If the request is not successful, the promise fails with an `err`.

|err.response.data.status_code|err.response.data.errors|How to fix|
|:--- |:---|:---|
|`403`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Cannot send letters with a team api key"`<br>`}]`|Use the correct type of [API key](#api-keys)|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Cannot send letters when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode"`<br>`}]`|Your service cannot send this notification in [trial mode](https://www.notifications.service.gov.uk/using-notify/trial-mode)|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "personalisation address_line_1 is a required property"`<br>`}]`|Send a valid PDF file|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "postage invalid. It must be either first or second."`<br>`}]`|Change the value of `postage` argument in the method call to either 'first' or 'second'|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Error: Your system clock must be accurate to within 30 seconds"`<br>`}]`|Check your system clock|
|`403`|`[{`<br>`"error": "AuthError",`<br>`"message": "Invalid token: API key not found"`<br>`}]`|Use the correct API key. Refer to [API keys](#api-keys) for more information|
|`429`|`[{`<br>`"error": "RateLimitError",`<br>`"message": "Exceeded rate limit for key type TEAM/TEST/LIVE of 3000 requests per 60 seconds"`<br>`}]`|Refer to [API rate limits](#rate-limits) for more information|
|`429`|`[{`<br>`"error": "TooManyRequestsError",`<br>`"message": "Exceeded send limits (LIMIT NUMBER) for today"`<br>`}]`|Refer to [service limits](#daily-limits) for the limit number|
|N/A|`"message":"precompiledPDF must be a valid PDF file"`|Send a valid PDF file|
|N/A|`"message":"reference cannot be null or empty"`|Populate the reference parameter|
|N/A|`"message":"precompiledPDF cannot be null or empty"`|Send a PDF file with data in it|

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
let olderThan= "740e5834-3a29-46b4-9a6f-16142fde533a";
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
