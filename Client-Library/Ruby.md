# GOV.UK Notify Ruby client

This documentation is for developers interested in using this Ruby client to integrate their government service with GOV.UK Notify.

[![Gem Version](https://badge.fury.io/rb/notifications-ruby-client.svg)](https://badge.fury.io/rb/notifications-ruby-client)

## Installation

Prior to usage an account must be created through the Notify admin console. This will allow access to the API credentials you application.

You can then install the gem or require it in your application.

```
gem install 'notifications-ruby-client'
```

## Getting started

```ruby
require 'notifications/client'
client = Notifications::Client.new(api_key)
```

Generate an API key by logging in to GOV.UK Notify [GOV.UK Notify](https://www.notifications.service.gov.uk) and going to the **API integration** page.

## Send messages

### Text message

#### Method 

<details>
<summary>
Click here to expand for more information.
</summary>

```ruby
sms = client.send_sms(
  phone_number: number,
  template_id: template_id,
  personalisation: {
    name: "name",
    year: "2016",                      
  }
  reference: "your_reference_string"
) # => Notifications::Client::ResponseNotification
```

</details>

#### Response

If the request is successful, a `Notifications::Client:ResponseNotification` is returned.
<details>
<summary>
Click here to expand for more information.
</summary>

```ruby
sms => Notifications::Client::ResponseNotification

sms.id         # => uuid for the notification
sms.reference  # => Reference string you supplied in the request
sms.content    # => Hash containing body => the message sent to the recipient, with placeholders replaced.
               #                    from_number => the sms sender number of your service found **Settings** page
sms.template   # => Hash containing id => id of the template
               #                    version => version of the template
               #                    uri => url of the template
sms.uri        # => URL of the notification
```


Otherwise the client will raise a `Notifications::Client::RequestError`:

|`error.code`|`error.message`|
|:---|:---|
|`429`|`[{`<br>`"error": "RateLimitError",`<br>`"message": "Exceeded rate limit for key type TEAM of 10 requests per 10 seconds"`<br>`}]`|
|`429`|`[{`<br>`"error": "TooManyRequestsError",`<br>`"message": "Exceeded send limits (50) for today"`<br>`}]`|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can"t send to this recipient using a team-only API key"`<br>`]}`|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can"t send to this recipient when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode"`<br>`}]`|

</details>

#### Arguments

???
<details>
<summary>
Click here to expand for more information.
</summary>

???
</details>


### Email

#### Method

<details>
<summary>
Click here to expand for more information.
</summary>

```ruby
email = client.send_email(
  email_address: email_address,
  template_id: template_id,
  personalisation: {
    name: "name",
    year: "2016"
  },
  reference: "your_reference_string"
  email_reply_to_id: email_reply_to_id
) # => Notifications::Client::ResponseNotification
```

</details>


#### Response

If the request is successful, a `Notifications::Client:ResponseNotification` is returned.

<details>
<summary>
Click here to expand for more information.
</summary>

```ruby
email => Notifications::Client::ResponseNotification

email.id         # => uuid for the notification
email.reference  # => Reference string you supplied in the request
email.content    # => Hash containing body => the message sent to the recipient, with placeholders replaced.
                 #                    subject => subject of the message sent to the recipient, with placeholders replaced.
                 #                    from_email => the from email of your service found **Settings** page
email.template   # => Hash containing id => id of the template
                 #                    version => version of the template
                 #                    uri => url of the template
email.uri        # => URL of the notification
```

Otherwise the client will raise a `Notifications::Client::RequestError`:

|`error.code`|`error.message`|
|:---|:---|
|`429`|`[{`<br>`"error": "RateLimitError",`<br>`"message": "Exceeded rate limit for key type TEAM of 10 requests per 10 seconds"`<br>`}]`|
|`429`|`[{`<br>`"error": "TooManyRequestsError",`<br>`"message": "Exceeded send limits (50) for today"`<br>`}]`|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can"t send to this recipient using a team-only API key"`<br>`]}`|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can"t send to this recipient when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode"`<br>`}]`|

</details>


#### Arguments

???
<details>
<summary>
Click here to expand for more information.
</summary>

???
</details>


### Letter

#### Method

<details>
<summary>
Click here to expand for more information.
</summary>

```ruby
letter = client.send_letter(
  template_id: template_id,
  personalisation: {
    address_line_1: 'Her Majesty The Queen',  # required
    address_line_2: 'Buckingham Palace', # required
    address_line_3: 'London',
    postcode: 'SW1 1AA',  # required

    ... # any other personalisation found in your template
  },
  reference: "your_reference_string"
) # => Notifications::Client::ResponseNotification
```

</details>


#### Response

If the request is successful, a `Notifications::Client:ResponseNotification` is returned.

<details>
<summary>
Click here to expand for more information.
</summary>

```ruby
letter => Notifications::Client::ResponseNotification

letter.id           # => uuid for the notification
letter.reference    # => Reference string you supplied in the request
letter.content      # => Hash containing body => the body of the letter sent to the recipient, with placeholders replaced
                    #                    subject => the main heading of the letter
letter.template     # => Hash containing id => id of the template
                    #                    version => version of the template
                    #                    uri => url of the template
letter.uri          # => URL of the notification
```

|`error.code`|`error.message`|
|:---|:---|
|`429`|`[{`<br>`"error": "RateLimitError",`<br>`"message": "Exceeded rate limit for key type TEAM of 10 requests per 10 seconds"`<br>`}]`|
|`429`|`[{`<br>`"error": "TooManyRequestsError",`<br>`"message": "Exceeded send limits (50) for today"`<br>`}]`|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can"t send to this recipient using a team-only API key"`<br>`]}`|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can"t send to this recipient when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode"`<br>`}]`|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "personalisation address_line_1 is a required property"`<br>`}]`|

</details>


#### Arguments

XYZ
<details>
<summary>
Click here to expand for more information.
</summary>

#### `phone_number`
The phone number of the recipient, only required when using `client.send_sms`.

#### `email_address`
The email address of the recipient, only required when using `client.send_email`.

#### `template_id`
Find by clicking **API info** for the template you want to send.

#### `reference`
An optional identifier you generate. The `reference` can be used as a unique reference for the notification. Because Notify does not require this reference to be unique you could also use this reference to identify a batch or group of notifications.

You can omit this argument if you do not require a reference for the notification.

#### `personalisation`
If the template has placeholders you need to provide their values as a Hash, for example:

```ruby
  personalisation: {
    'first_name' => 'Amala',
    'reference_number' => '300241',
  }
```

You can omit this argument if the template does not contain placeholders and is for email or sms.

#### `personalisation` (for letters)

If you are sending a letter, you will need to provide the letter fields in the format `"address_line_#"`, for example:

```ruby
personalisation: {
    'address_line_1' => 'The Occupier',
    'address_line_2' => '123 High Street',
    'address_line_3' => 'London',
    'postcode' => 'SW14 6BH',
    'first_name' => 'Amala',
    'reference_number' => '300241',
}
```

The fields `address_line_1`, `address_line_2` and `postcode` are required.

#### `email_reply_to_id`

Optional. Specifies the identifier of the email reply-to address to set for the notification. The identifiers are found in your service Settings, when you 'Manage' your 'Email reply to addresses'. 

If you omit this argument your default email reply-to address will be set for the notification.

</details>


## Get the status of one message

#### Method

XYZ
<details>
<summary>
Click here to expand for more information.
</summary>

XYZ
</details>


#### Response

XYZ
<details>
<summary>
Click here to expand for more information.
</summary>

XYZ
</details>

#### Arguments

XYZ
<details>
<summary>
Click here to expand for more information.
</summary>

XYZ
</details>

## Get the status of all messages (with pagination)

#### Method

XYZ
<details>
<summary>
Click here to expand for more information.
</summary>

XYZ
</details>


#### Response

XYZ
<details>
<summary>
Click here to expand for more information.
</summary>

XYZ
</details>



#### Arguments

XYZ
<details>
<summary>
Click here to expand for more information.
</summary>

XYZ
</details>


## Get the status of all messages (without pagination)

#### Method

XYZ
<details>
<summary>
Click here to expand for more information.
</summary>

XYZ
</details>

#### Response

XYZ
<details>
<summary>
Click here to expand for more information.
</summary>

XYZ
</details>


#### Arguments

XYZ
<details>
<summary>
Click here to expand for more information.
</summary>

XYZ
</details>


## Get a template by ID

#### Method 

XYZ
<details>
<summary>
Click here to expand for more information.
</summary>

XYZ
</details>


#### Response

XYZ
<details>
<summary>
Click here to expand for more information.
</summary>

XYZ
</details>


#### Arguments

XYZ
<details>
<summary>
Click here to expand for more information.
</summary>

XYZ
</details>


## Get all templates

#### Method

XYZ
<details>
<summary>
Click here to expand for more information.
</summary>

XYZ
</details>


#### Response

XYZ
<details>
<summary>
Click here to expand for more information.
</summary>

XYZ
</details>


#### Arguments

XYZ
<details>
<summary>
Click here to expand for more information.
</summary>

XYZ
</details>


## Generate a preview template

#### Method

XYZ
<details>
<summary>
Click here to expand for more information.
</summary>

XYZ
</details>


#### Response

XYZ
<details>
<summary>
Click here to expand for more information.
</summary>

XYZ
</details>


#### Arguments

XYZ
<details>
<summary>
Click here to expand for more information.
</summary>

XYZ
</details>



