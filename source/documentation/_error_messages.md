## Error messages

Error messages consist of:

- a status_code, for example ‘400’
- an error, for example ’BadRequestError’
- a message, for example ‘Mobile numbers can only include: 0 1 2 3 4 5 6 7 8 9 ( ) + -‘

Do not use the content of the messages in your code. These can sometimes change, which may affect your API integration.

Use the status_code or the error instead, as these will not change.

Find error codes in:

- [send a message](#send-a-message)
- [get message data](#get-message-data)
- [get a template](#get-a-template)
- [get received text messages](#get-received-text-messages)
