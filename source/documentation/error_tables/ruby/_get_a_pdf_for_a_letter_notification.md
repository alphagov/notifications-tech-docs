**BadRequestError (status code 400)**|
`ValidationError: id is not a valid UUID`|Check the notification ID.|
`ValidationError: Notification is not a letter`|Check that you are looking up the correct notification.|
`PDFNotReadyError: PDF not available yet, try again later`|Wait for the letter to finish processing. This usually takes a few seconds.|
`BadRequestError: File did not pass the virus scan`|You cannot retrieve the contents of a letter that contains a virus.|
`BadRequestError: PDF not available for letters in technical-failure`|You cannot retrieve the contents of a letter in technical-failure.|
`BadRequestError: Notification is not a letter`|Check that you are looking up the correct notification.|
**NotFoundError (status code 404)**|
`NoResultFound: No result found`|Check the notification ID.|

In addition to the above, you may also encounter:

* [various schema validation errors](#schema-validation-errors), for example when you forget to pass in an argument, or pass in an argument of a wrong type.
* errors that are not related to getting a PDF for a letter, but instead are related to things like authentication and rate limits. You can find a list of these errors [in General errors](#general-errors)