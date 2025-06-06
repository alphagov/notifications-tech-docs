**ValidationError (status code 400)**|
`id is not a valid UUID`|Check the notification ID.|
`Notification is not a letter`|Check that you are looking up the correct notification.|
**PDFNotReadyError (status code 400)**|
`PDF not available yet, try again later`|Wait for the letter to finish processing. This usually takes a few seconds.|
**BadRequestError (status code 400)**|
`File did not pass the virus scan`|You cannot retrieve the contents of a letter that contains a virus.|
`PDF not available for letters in technical-failure`|You cannot retrieve the contents of a letter in technical-failure.|
`Notification is not a letter`|Check that you are looking up the correct notification.|
**NoResultFound (status code 404)**|
`No result found`|Check the notification ID.|

In addition to the above, you may also encounter:

* various schema validation errors, for example when you forget to pass in an argument, or pass in an argument of a wrong type.
* errors that are not related to getting a PDF for a letter, but instead are related to things like authentication and rate limits. You can find a list of these errors [in General errors](#general-errors)