**BadRequestError (status code 400)**|
`Missing personalisation: [PERSONALISATION FIELD]`|Check that the personalisation arguments in the method match the placeholder fields in the template.|
**NoResultFound (status code 404)**|
`No Result Found`|Check your [template ID](#get-a-template-by-id-arguments-template-id-required).|

In addition to the above, you may also encounter:

* [various schema validation errors](#schema-validation-errors), for example when you forget to pass in an argument, or pass in an argument of a wrong type.
* errors that are not related to generating a preview template, but instead are related to things like authentication and rate limits. You can find a list of these errors [in General errors](#general-errors)