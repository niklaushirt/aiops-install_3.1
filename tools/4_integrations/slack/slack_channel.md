# Configuring the Slack Channel

You can use an existing Slack channel or create a new Slack channel. A sample channel is shown here named `#watson-aiops-aimgr` and is made private (invitation only).

![slackc1](images/slackc1.png)

Capture the channel ID by right-clicking on the channel name, the select **Copy Link** to get the web URL link. The last part of the link is the channel ID.

Example: `https://watsonaiforit.slack.com/archives/G017SA7NQ9L`

The channel ID for example above is `G017SA7NQ9L`. Save this ID to use for further configuration in AI Manager.

## Configuring an Application Group with a Slack Channel

Switch back to AI Manager, and Open **waiops.**  From **Bookinfo**, select edit.

![slackc7](images/Bookinfo_edit.png)

Set the **Platform channel ID** to the value of your Slack channel ID saved earlier, and save.

![slackc2](images/BookInfo_Channel.png)

<!--
Switch back to AI Manager in your browser. On the instance page, click **Create new application group**. Name the application group and set the **Platform channel ID** to the value of your Slack channel ID saved earlier.  
![slackc2](images/slackc2.png)

Click **Save application group**. Now all the applications added to this application group will target the Slack channel created earlier.

-->

## Invite the Slack app to the channel

At this point it is possible to add the Slack app to a channel and test basic communications. Open the Slack channel created previously and tag the application in a message.  
![slackc3](images/slackc3.png)

A dialog will display allowing an invitation to the Slack app.   
![slackc4](images/slackc4.png)

Click **Invite to Channel**. The Slack app will send a message to the channel.  
![slackc5](images/slackc5.png)

You can also show the welcome message any time by using the slash command configured for the Slack app.  
![slackc6](images/slackc6.png)

Congratulations, you have configured a Slack app for communication with AI Manager.
