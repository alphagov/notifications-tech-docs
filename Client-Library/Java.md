# GOV.UK Notify Java client

This documentation is for developers interested in using this Java client to integrate their government service with GOV.UK Notify.

## Table of Contents

* [Installation](#installation)
* [Getting started](#getting-started)
* [Send messages](#send-messages)
* [Get the status of one message](#get-the-status-of-one-message)
* [Get the status of all messages](#get-the-status-of-all-messages)
* [Get a template by ID](#get-a-template-by-id)
* [Get a template by ID and version](#get-a-template-by-id-and-version)
* [Get all templates](#get-all-templates)
* [Generate a preview template](#generate-a-preview-template)

## Installation

### Maven

The notifications-java-client is deployed to [Bintray](https://bintray.com/gov-uk-notify/maven/notifications-java-client). Add this snippet to your Maven `settings.xml` file.

<details>
<summary>
Click here to expand for more information.
</summary>

```xml
<?xml version='1.0' encoding='UTF-8'?>
<settings xsi:schemaLocation='http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd' xmlns='http://maven.apache.org/SETTINGS/1.0.0' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'>
<profiles>
	<profile>
		<repositories>
			<repository>
				<snapshots>
					<enabled>false</enabled>
				</snapshots>
				<id>bintray-gov-uk-notify-maven</id>
				<name>bintray</name>
				<url>http://dl.bintray.com/gov-uk-notify/maven</url>
			</repository>
		</repositories>
		<pluginRepositories>
			<pluginRepository>
				<snapshots>
					<enabled>false</enabled>
				</snapshots>
				<id>bintray-gov-uk-notify-maven</id>
				<name>bintray-plugins</name>
				<url>http://dl.bintray.com/gov-uk-notify/maven</url>
			</pluginRepository>
		</pluginRepositories>
		<id>bintray</id>
	</profile>
</profiles>
<activeProfiles>
	<activeProfile>bintray</activeProfile>
</activeProfiles>
</settings>
```
Then add the Maven dependency to your project.
```xml
    <dependency>
        <groupId>uk.gov.service.notify</groupId>
        <artifactId>notifications-java-client</artifactId>
        <version>3.6.0-RELEASE</version>
    </dependency>

```
</details>

### Gradle

<details>
<summary>
Click here to expand for more information.
</summary>

```
repositories {
    mavenCentral()
    maven {
        url  "http://dl.bintray.com/gov-uk-notify/maven"
    }
}

dependencies {
    compile('uk.gov.service.notify:notifications-java-client:3.6.0-RELEASE')
}
```
</details>

### Artifactory or Nexus

Click 'set me up!' on https://bintray.com/gov-uk-notify/maven/notifications-java-client for instructions.

## Getting started

```java
import uk.gov.service.notify.NotificationClient;
import uk.gov.service.notify.Notification;
import uk.gov.service.notify.NotificationList;
import uk.gov.service.notify.SendEmailResponse;
import uk.gov.service.notify.SendSmsResponse;

NotificationClient client = new NotificationClient(apiKey);
```

Generate an API key by signing in to [GOV.UK Notify](https://www.notifications.service.gov.uk) and going to the **API integration** page.

## Send messages

### Text message

#### Method 

<details>
<summary>
Click here to expand for more information.
</summary>

```java
Map<String, String> personalisation = new HashMap<>();
personalisation.put("name", "Jo");
personalisation.put("reference_number", "13566");
SendSmsResponse response = client.sendSms(templateId, mobileNumber, personalisation, "yourReferenceString", emailReplyToId);
```

</details>

#### Response

If the request is successful, the SendSmsResponse is returned from the client. Attributes of the SendSmsResponse are listed below. 
<details>
<summary>
Click here to expand for more information.
</summary>

```java
    UUID notificationId;
    Optional<String> reference;
    UUID templateId;
    int templateVersion;
    String templateUri;
    String body;
    Optional<String> fromNumber;

```

Otherwise the client will raise a `NotificationClientException`:

|status code|error message|
|:---|:---|
|`429`|`429 {`<br>`"errors":`<br>`[{`<br>`"error": "RateLimitError",`<br>`"message": "Exceeded rate limit for key type live of 10 requests per 10 seconds"`<br>`}]`<br>`}`|
|`429`|`429 {`<br>`"errors":`<br>`[{`<br>`"error": "TooManyRequestsError",`<br>`"message": "Exceeded send limits (50) for today"`<br>`}]`<br>`}`|
|`400`|`400 {`<br>`"errors":`<br>`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can"t send to this recipient using a team-only API key"`<br>`}]`<br>`}`|
|`400`|`400 {`<br>`"errors":`<br>`[{`<br>`"error": "BadRequestError",`<br>`"message": ""Can"t send to this recipient when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode""`<br>`}]`<br>`}`|

</details>

#### Arguments

<details>
<summary>
Click here to expand for more information.
</summary>

##### `mobileNumber`
The mobile number the SMS notification is sent to.

##### `templateId`

The template id is visible on the template page in the application.

##### `reference`
An optional unique identifier for the notification or an identifier for a batch of notifications. `reference` can be an empty string or null.

##### `personalisation`

If a template has placeholders, you need to provide their values, for example:

```java
personalisation={
    'first_name': 'Amala',
    'reference_number': '300241',
}
```

#### `email_reply_to_id`
Optional. Specifies the identifier of the email reply-to address to set for the notification. The identifiers are found in your service Settings, when you 'Manage' your 'Email reply to addresses'.
If you omit this argument your default email reply-to address will be set for the notification.

</details>

### Email

#### Method

<details>
<summary>
Click here to expand for more information.
</summary>

```java
HashMap<String, String> personalisation = new HashMap<>();
personalisation.put("name", "Jo");
personalisation.put("reference_number", "13566");
SendEmailResponse response = client.sendEmail(templateId, emailAddress, personalisation, reference, emailReplyToId);
```

</details>

#### Response

If the request is successful, the SendEmailResponse is returned from the client. Attributes of the SendEmailResponse are listed below. 

<details>
<summary>
Click here to expand for more information.
</summary>


```java
	UUID notificationId;
	Optional<String> reference;
	UUID templateId;
	int templateVersion;
	String templateUri;
	String body;
	String subject;
	Optional<String> fromEmail;

```

Otherwise the client will raise a `NotificationClientException`:

|`error.status_code`|`error.message`|
|:---|:---|
|`429`|`[{`<br>`"error": "RateLimitError",`<br>`"message": "Exceeded rate limit for key type TEAM of 10 requests per 10 seconds"`<br>`}]`|
|`429`|`[{`<br>`"error": "TooManyRequestsError",`<br>`"message": "Exceeded send limits (50) for today"`<br>`}]`|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can"t send to this recipient using a team-only API key"`<br>`]}`|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Can"t send to this recipient when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode"`<br>`}]`|

</details>

#### Arguments

<details>
<summary>Click here for more information</summary>

#### `emailAddress`
The email address the email notification is sent to.

#### `templateId`

The template id is visible on the template page in the application.

#### `personalisation`

If a template has placeholders, you need to provide their values, for example:

```java
personalisation={
    'first_name': 'Amala',
    'reference_number': '300241',
}
```

#### `reference`
An optional identifier you generate. The reference can be used as a unique reference for the notification. Because Notify does not require this reference to be unique you could also use this reference to identify a batch or group of notifications.

You can omit this argument if you do not require a reference for the notification.

#### `email_reply_to_id`
Optional. Specifies the identifier of the email reply-to address to set for the notification. The identifiers are found in your service Settings, when you 'Manage' your 'Email reply to addresses'.
If you omit this argument your default email reply-to address will be set for the notification.

</details>

### Letter

#### Method

The letter must contain:

- mandatory address fields
- optional address fields if applicable
- fields from template

<details>
<summary>
Click here to expand for more information.
</summary>

```java
HashMap<String, String> personalisation = new HashMap<>();
personalisation.put("address_line_1", "The Occupier"); // mandatory address field
personalisation.put("address_line_2", "Flat 2"); // mandatory address field
personalisation.put("address_line_3", "123 High Street"); // optional address field
personalisation.put("address_line_4", "Richmond upon Thames"); // optional address field
personalisation.put("address_line_5", "London"); // optional address field
personalisation.put("address_line_6", "Middlesex"); // optional address field
personalisation.put("postcode", "SW14 6BH"); // mandatory address field
personalisation.put("application_id", "1234"); // field from template
personalisation.put("application_date", "2017-01-01"); // field from template

SendLetterResponse response = client.sendLetter(templateId, personalisation, "yourReferenceString");
```
</details>

#### Response

If the request is successful, the SendLetterResponse is returned from the client. Attributes of the SendLetterResponse are listed below.
<details>
<summary>
Click here to expand for more information.
</summary>

```java
	UUID notificationId;
	Optional<String> reference;
	UUID templateId;
	int templateVersion;
	String templateUri;
	String body;
	String subject;
```

Otherwise the client will raise a `NotificationClientException`:

|`error.status_code`|`error.message`|
|:---|:---|
|`429`|`[{`<br>`"error": "RateLimitError",`<br>`"message": "Exceeded rate limit for key type live of 10 requests per 20 seconds"`<br>`}]`|
|`429`|`[{`<br>`"error": "TooManyRequestsError",`<br>`"message": "Exceeded send limits (50) for today"`<br>`}]`|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Cannot send letters with a team api key"`<br>`]}`|
|`400`|`[{`<br>`"error": "BadRequestError",`<br>`"message": "Cannot send letters when service is in trial mode - see https://www.notifications.service.gov.uk/trial-mode"`<br>`}]`|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "personalisation address_line_1 is a required property"`<br>`}]`|

</details>

#### Arguments

<details>
<summary>Click here to expand for more information.</summary>

#### `templateId`

The template id is visible on the template page in the application.

#### `personalisation`

The letter must contain:

- mandatory address fields
- optional address fields if applicable
- fields from template

If you are sending a letter, you will need to provide the address fields in the format `"address_line_#"`, numbered from 1 to 6, and also the `"postcode"` field
The fields `"address_line_1"`, `"address_line_2"` and `"postcode"` are required.

#### `reference`
An optional unique identifier for the notification or an identifier for a batch of notifications. `reference` can be an empty string or null.

</details>


## Get the status of one message

#### Method

<details>
<summary>
Click here to expand for more information.
</summary>

```java
Notification notification = client.getNotificationById(notificationId);
```
</details>

#### Response

If successful a `notification` is returned. Below is a list of attributes in a `notification`. 
<details>
<summary>
Click here to expand for more information.
</summary>


```java
    UUID id;
    Optional<String> reference;
    Optional<String> emailAddress;
    Optional<String> phoneNumber;
    Optional<String> line1;
    Optional<String> line2;
    Optional<String> line3;
    Optional<String> line4;
    Optional<String> line5;
    Optional<String> line6;
    Optional<String> postcode;
    String notificationType;
    String status;
    UUID templateId;
    int templateVersion;
    String templateUri;
    String body;
    Optional<String subject;
    DateTime createdAt;
    Optional<DateTime> sentAt;
		Optional<DateTime> completedAt;
    Optional<DateTime> estimatedDelivery;
```

Otherwise the client will raise a `NotificationClientException`.

|`error.status_code`|`error.message`|
|:---|:---|
|`404`|`[{`<br>`"error": "NoResultFound",`<br>`"message": "No result found"`<br>`}]`|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "id is not a valid UUID"`<br>`}]`|

</details>

## Get the status of all messages

#### Method

<details>

<summary>
Click here to expand for more information.
</summary>


```java
NotificationList notification = client.getNotifications(status, notificationType, reference, olderThanId);
```

</details>

#### Response

If successful a `NotificationList` is returned. Below is a list of attributes in a`NotificationList`. 
<details>
<summary>
Click here to expand for more information.
</summary>



```java
    List<Notification> notifications;
    String currentPageLink;
    Optional<String> nextPageLink;
```

Otherwise the client will raise a `NotificationClientException`.

|`error.status_code`|`error.message`|
|:---|:---|
|`404`|`[{`<br>`"error": "ValidationError",`<br>`"message": "bad status is not one of [created, sending, delivered, pending, failed, technical-failure, temporary-failure, permanent-failure]"`<br>`}]`|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "Apple is not one of [sms, email, letter]"`<br>`}]`|


</details>


#### Arguments

<details>
<summary>Click here to expand for more information.</summary>

##### `status`

__email__

You can filter by:

* `sending` - the message is queued to be sent by the provider.
* `delivered` - the message was successfully delivered.
* `failed` - this will return all failure statuses `permanent-failure`, `temporary-failure` and `technical-failure`.
* `permanent-failure` - the provider was unable to deliver message, email does not exist; remove this recipient from your list.
* `temporary-failure` - the provider was unable to deliver message, email box was full; you can try to send the message again.
* `technical-failure` - Notify had a technical failure; you can try to send the message again.

You can omit this argument to ignore this filter.

__text message__

You can filter by:

* `sending` - the message is queued to be sent by the provider.
* `delivered` - the message was successfully delivered.
* `failed` - this will return all failure statuses `permanent-failure`, `temporary-failure` and `technical-failure`.
* `permanent-failure` - the provider was unable to deliver message, phone number does not exist; remove this recipient from your list.
* `temporary-failure` - the provider was unable to deliver message, the phone was turned off; you can try to send the message again.
* `technical-failure` - Notify had a technical failure; you can try to send the message again.

You can omit this argument to ignore this filter.

__letter__

You can filter by:

* `accepted` - the letter has been generated.
* `technical-failure` - Notify had an unexpected error while sending to our printing provider

You can omit this argument to ignore this filter.

##### `reference`

This is the `reference` you gave at the time of sending the notification. The `reference` can be a unique identifier for the notification or an identifier for a batch of notifications.

##### `olderThanId`

You can get the notifications older than a given Notification.notificationId.

##### `notificationType`

???

</details>

## Get a template by ID

#### Method 

This will return the latest version of the template. Use [getTemplateVersion](#get-a-template-by-id-and-version) to retrieve a specific template version.

<details>
<summary>
Click here to expand for more information.
</summary>


```java
Template template = client.getTemplateById(templateId);
```
</details>

#### Response

<details>
<summary>
Click here to expand for more information.
</summary>


```Java
    UUID id;
    String templateType;
    DateTime createdAt;
    Optional<DateTime> updatedAt;
    String createdBy;
    int version;
    String body;
    Optional<String> subject;
    Optional<Map<String, Object>> personalisation;
```

Otherwise the client will raise a `NotificationClientException`.

|`error.status_code`|`error.message`|
|:---|:---|
|`404`|`[{`<br>`"error": "NoResultFound",`<br>`"message": "No Result Found"`<br>`}]`|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "id is not a valid UUID"`<br>`}]`|

</details>

#### Arguments

<details>
<summary>Click here to expand for more information.</summary>

##### `templateId`

The template id is visible on the template page in the application.

</details>


## Get a template by ID and version

#### Method

This will return the template for the given id and version.

<details>
<summary>
Click here to expand for more information.
</summary>

```java
Template template = client.getTemplateVersion(templateId, version);
```

</details>

#### Response

<details>
<summary>
Click here to expand for more information.
</summary>

```Java
    UUID id;
    String templateType;
    DateTime createdAt;
    Optional<DateTime> updatedAt;
    String createdBy;
    int version;
    String body;
    Optional<String> subject;
    Optional<Map<String, Object>> personalisation;
```

Otherwise the client will raise a `NotificationClientException`:

|`error.status_code`|`error.message`|
|:---|:---|
|`404`|`[{`<br>`"error": "NoResultFound",`<br>`"message": "No Result Found"`<br>`}]`|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "id is not a valid UUID"`<br>`}]`|

</details>

#### Arguments

<details>
<summary>Click here to expand for more information.</summary>

##### `templateId`
The template id is visible on the template page in the application.

##### `version`
A history of the template is kept. There is a link to `See previous versions` on the template page in the application.


</details>

## Get all templates

#### Method

This will return the latest version for each template for your service.

<details>
<summary>
Click here to expand for more information.
</summary>


```java
TemplateList templates = client.getAllTemplates(templateType);
```

[See available template types](#template_type)

</details>

#### Response

<details>
<summary>
Click here to expand for more information.
</summary>

```java
    List<Template> templates;
```

If the response is successful, a TemplateList is returned.

If no templates exist for a template type or there no templates for a service, the templates list will be empty.

</details>

#### Arguments

<details>
<summary>Click here to expand for more information.</summary>

##### `templateType`

You can filter the templates by the following options:

* `email`
* `sms`
* `letter`

You can also pass in an empty string or null to ignore the filter.

</details>

## Generate a preview template

#### Method

This will return the contents of a template with the placeholders replaced with the given personalisation.

<details>
<summary>
Click here to expand for more information.
</summary>


```Java
TemplatePreview templatePreview = client.getTemplatePreview(templateId, personalisation)
```

</details>

#### Response

<details>
<summary>
Click here to expand for more information.
</summary>


```java
    UUID id;
    String templateType;
    int version;
    String body;
    Optional<String> subject;
```

Otherwise the client will raise a `NotificationClientException`:

|`error.status_code`|`error.message`|
|:---|:---|
|`400`|`[{`<br>`"error": "NoResultFound",`<br>`"message": "No result found"`<br>`}]`|
|`400`|`[{`<br>`"error": "ValidationError",`<br>`"message": "id is not a valid UUID"`<br>`}]`|

</details>

#### Arguments

<details>
<summary>Click here to expand for more information.</summary>

##### `templateId`

The template id is visible on the template page in the application.

##### `personalisation`

If a template has placeholders, you need to provide their values. `personalisation` can be an empty or null in which case no placeholders are provided for the notification.

</details>
