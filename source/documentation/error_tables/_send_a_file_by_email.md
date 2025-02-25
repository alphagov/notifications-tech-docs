`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Unsupported file type '(FILE TYPE)'. Supported types are: '(ALLOWED TYPES)'"`<br>`}]`|Wrong file type. You can only upload .csv, .doc, .docx, .jpeg, .jpg, .odt, .pdf, .png, .rtf, .txt or .xlsx files|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>```"message": "`filename` cannot be longer than 100 characters"```<br>`}]`|Choose a shorter filename|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>```"message": "`filename` must end with a file extension. For example, filename.csv"```<br>`}]`|Include the file extension in your filename|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Unsupported value for retention_period '(PERIOD)'. Supported periods are from 1 to 78 weeks."`<br>`}]`|Choose a period between 1 and 78 weeks|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Unsupported value for confirm_email_before_download: '(VALUE)'. Use a boolean true or false value."`<br>`}]`|Use either True or False|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "File did not pass the virus scan"`<br>`}]`|The file contains a virus|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Send files by email has not been set up - add contact details for your service at https://www.notifications.service.gov.uk/services/(SERVICE ID)/service-settings/send-files-by-email"`<br>`}]`|See how to [add contact details to the file download page](#add-contact-details-to-the-file-download-page)|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can only send a file by email"`<br>`}]`|Make sure you are using an email template|
|-|`ValueError('File is larger than 2MB')`|The file is too big. Files must be smaller than 2MB.|

In addition to the above, you can also encounter:

* other errors related to [sending an email](#send-an-email).
* various schema validation errors, for example when you forget to pass in an argument, or pass in an argument of a wrong type.
* errors that are not related to sending an email, but instead are related to things like authentication and rate limits. You can find a list of these errors [in the Errors Messages section](#error-messages)