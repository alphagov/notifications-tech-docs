**BadRequestError (status code 400)**|
`ValidationError: personalisation address_line_1 is a required property`|Ensure that your template has a field for the first line of the address, check [personalisation](#personalisation-required) for more information.|
`ValidationError: Must be a real UK postcode`|Ensure that the value for the last line of the address is a real UK postcode.|
`ValidationError: Must be a real address`|Provide a real recipient address. We do not accept letters for "no fixed abode" addresses, as those cannot be delivered.|
`ValidationError: Last line of address must be a real UK postcode or another country`|Ensure that the value for the last line of the address is a real UK postcode or the name of a country outside the UK.|
`ValidationError: The last line of a BFPO address must not be a country.`|The last line of a BFPO address must not be a country.|
`ValidationError: Address must be at least 3 lines`|Provide at least 3 lines of address.|
`ValidationError: Address must be no more than 7 lines`|Provide no more than 7 lines of address.|
`ValidationError: Address lines must not start with any of the following characters: @ ( ) = [ ] ” \\ / , < >`|Change the start of an address line, so it doesn't start with one of these characters. This is a requirement from our printing provider.|
`ValidationError: postage invalid. It must be either first, second or economy.`|Specify valid postage option.|
`BadRequestError: Cannot send letters when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode`|Your service cannot send this letter in  [trial mode](https://www.notifications.service.gov.uk/using-notify/trial-mode).|
`BadRequestError: Service is not allowed to send letters`|Turn on sending letters in your service Settings on GOV.UK Notify webpage|
`BadRequestError: letter_contact_id <letter_contact_id> does not exist in database for service id <service id>`|Go to your service Settings and copy a valid `letter_contact_id`. Check that the API key you are using and the `letter_contact_id` belong to the same service.|
**AuthError (status code 403)**|
`BadRequestError: Cannot send letters with a team api key`|Use the correct type of [API key](#api-keys).|

In addition to the above, you may also encounter:

* [various schema validation errors](#schema-validation-errors), for example when you forget to pass in an argument, or pass in an argument of a wrong type.
* errors that are not related to sending an email, but instead are related to things like authentication and rate limits. You can find a list of these errors [in General errors](#general-errors)