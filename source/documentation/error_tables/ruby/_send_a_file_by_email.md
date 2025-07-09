**BadRequestError (status code 400)**|
`BadRequestError: Unsupported file type '(FILE TYPE)'. Supported types are: '(ALLOWED TYPES)'`|Wrong file type. You can only upload .csv, .doc, .docx, .jpeg, .jpg, .odt, .pdf, .png, .rtf, .txt or .xlsx files|
`BadRequestError: filename cannot be longer than 100 characters`|Choose a shorter filename|
`BadRequestError: filename must end with a file extension. For example, filename.csv`|Include the file extension in your filename|
`BadRequestError: Unsupported value for retention_period '(PERIOD)'. Supported periods are from 1 to 78 weeks.`|Choose a period between 1 and 78 weeks|
`BadRequestError: Unsupported value for confirm_email_before_download: '(VALUE)'. Use a boolean true or false value.`|Use either True or False|
`BadRequestError: File did not pass the virus scan`|The file contains a virus|
`BadRequestError: Send files by email has not been set up - add contact details for your service at https://www.notifications.service.gov.uk/services/(SERVICE ID)/service-settings/send-files-by-email`|See how to [add contact details to the file download page](#add-contact-details-to-the-file-download-page)|
`BadRequestError: Can only send a file by email`|Make sure you are using an email template|
**ArgumentError (no status code)**|
`File is larger than 2MB`|The file is too big. Files must be smaller than 2MB.|

In addition to the above, you may also encounter:

* other errors related to [sending an email](#send-an-email).
* [various schema validation errors](#schema-validation-errors), for example when you forget to pass in an argument, or pass in an argument of a wrong type.
* errors that are not related to sending an email, but instead are related to things like authentication and rate limits. You can find a list of these errors [in General errors](#general-errors)