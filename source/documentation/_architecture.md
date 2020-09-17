## API architecture

### Send a text message - architecture

![](documentation/images/notify-send-a-message.png)

1. The service sends a text message notification to Notify.
1. Notify sends the text message to the provider.
1. The provider delivers the text message to the recipient.
1. The recipient receives the text message and sends a delivery receipt to the provider.
1. The provider sends the delivery receipt to Notify.
1. Notify receives the delivery receipt and sends an API response to the service.
1. The service receives the API response.

### Send an email - architecture

![](documentation/images/notify-send-a-message.png)

1. The service sends an email notification to Notify.
1. Notify sends the email to the provider.
1. The provider delivers the email to the recipient.
1. The recipient receives the email and sends a delivery receipt to the provider.
1. The provider sends the delivery receipt to Notify.
1. Notify receives the delivery receipt and sends an API response to the service.
1. The service receives the API response.

### Send a letter - architecture

![](documentation/images/notify-send-a-message.png)

1. The service sends a letter notification to Notify.
1. Notify populates the letter template, prints and sends the letter to the provider.
1. The provider delivers the letter to the recipient.
1. The recipient receives the letter.

### Get status of one or all messages - architecture

![](documentation/images/notify-get-message-status.png)

1. The service requests a notification status from Notify.
1. Notify queries the database and retrieves the notification status.
1. Notify sends the API response with notification status to the service.
1. The service received the API response.

### Get all received text messages - architecture

![](documentation/images/notify-get-inbound-messages.png)

1. Recipients send text messages.
1. Notify receives the text messages.
1. The service requests all received text messages from Notify.
1. Notify receives the request for all received text messages.
1. Notify sends the received text messages to the service.
1. The service receives the received text messages.

### Get specific received text messages - architecture

![](documentation/images/notify-get-inbound-messages.png)

1. The service requests specific received text messages from Notify.
1. Notify receives the request for specific received text messages.
1. Notify sends specific received text messages to the service.
1. The service receives specific received text messages.
