**ValidationError&nbsp;(status&nbsp;code&nbsp;400)**|
`id is not a valid UUID`|Check the notification ID.|
**NoResultFound&nbsp;(status&nbsp;code&nbsp;404)**|
`No result found`| If it's outside the retention period, you may no longer get the status of the message. The default retention period is 7 days.|

In addition to the above, you may also encounter:

* various schema validation errors, for example when you forget to pass in an argument, or pass in an argument of a wrong type.
* errors that are not related to getting the status of a message, but instead are related to things like authentication and rate limits. You can find a list of these errors [in General errors](#general-errors)