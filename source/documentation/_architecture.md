# API architecture

### Architecture for send a text message

![](documentation/images/notify-send-a-message.png)

1. The service sends a text message notification to Notify.
1. Notify sends the text message to the provider.
1. The provider delivers the text message to the recipient.
1. The recipient receives the text message and sends a delivery receipt to the provider.
1. The provider sends the delivery receipt to Notify.
1. Notify receives the delivery receipt and sends an API response to the service.
1. The service receives the API response.

### Architecture for send an email

![](documentation/images/notify-send-a-message.png)

1. The service sends an email notification to Notify.
1. Notify sends the email to the provider.
1. The provider delivers the email to the recipient.
1. The recipient receives the email and sends a delivery receipt to the provider.
1. The provider sends the delivery receipt to Notify.
1. Notify receives the delivery receipt and sends an API response to the service.
1. The service receives the API response.

### Architecture for send a letter

![](documentation/images/notify-send-a-message.png)

1. The service sends a letter notification to Notify.
1. Notify sends the letter to the provider.
1. The provider prints the letter and posts it.
1. The postal service delivers the letter.
1. The recipient receives the letter.

### Architecture for get message status

![](documentation/images/notify-get-message-status.png)

1. The service requests a notification status from Notify.
1. Notify queries the database and retrieves the notification status.
1. Notify sends the API response with notification status to the service.
1. The service receives the API response.

### Architecture for get received text messages

![](documentation/images/notify-get-inbound-messages.png)

1. Recipients send text messages.
1. Notify receives the text messages.
1. The service requests all or specific received text messages from Notify.
1. Notify receives the request for received text messages.
1. Notify sends the received text messages to the service.
1. The service receives the received text messages.
