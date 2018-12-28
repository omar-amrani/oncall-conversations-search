#### Responsible Team: Team Customer Support

## Conversation Search Platform

Conversation Search Platform is composed of 3 areas:

- The web app, where you can search for conversations and filter them by tags
- An API endpoint ("/api/populate") that you can use to populate the database with existing conversations
- A webhook URL ("/conversations/webhook") that can be used to store the conversations as soon as they are closed by an admin

# Development

You'll need to expose your localhost so the webhook can POST to it. For that we'll use ngrok.

## 1. Install ngrok

- Download and install [ngrok](https://ngrok.com/).
- In the Terminal, run ./ngrok http 3000. Minimize the terminal window and let it run. 
This will assign a web public URL to your local localhost:3000 address, making it available on the web. It will look something like https://<some_string>.ngrok.io. You will use that URL when configuring the "closed conversation" webhook.

## 2. Configure environment variables
  Create a .env file in the root of the project directly and configure the following secrets:
  ```
  INTERCOM_KEY = <some_value>
  INTERCOM_SECRET = <some_value>
  REQUIRED_APP_ID = <some_value>
  INTERCOM_TOKEN = <some_value>
  ```
  ![image](https://user-images.githubusercontent.com/35232547/50016492-3fdcb500-ffc1-11e8-96df-e1d2354de98c.png)
  
  The three first variables are used for the Oauth process while the `INTERCOM_TOKEN` is used to interact with the workspace API.
  

## 3. Set up your OAuth redirect URL

Your OAuth redirect URL should have the following format: 
`https://<some_string>.ngrok.io/auth/intercom/callback`

![image](https://user-images.githubusercontent.com/35232547/50016853-4c154200-ffc2-11e8-8681-631adae60cc3.png)

## 4. Set up your "Closed conversation" webhook topic
Your webhook URL should have the following format: 
`https://<some_string>.ngrok.io/conversations/webhook`

![image](https://user-images.githubusercontent.com/35232547/50017125-2dfc1180-ffc3-11e8-83b7-bdd1f3981c4e.png)

## 5. Set up MYSQL
Run `brew install mysql` to install mysql. Then you can start mysql server by running `mysql.server start`.
If you are using any particular username/password for your mysql user, you'll need to update config/database.yml accordingly.

Finally you'll need to call `rails db:create` to create your test and development databases.

## 6. Install dependencies
Run `bundler` to install dependencies:

```
bundler install
```

If you get an error that bundler is not installed:

```
gem install bundler
```

Create the database tables:
 
``` 
rails db:migrate
```



## 7. Set up Elasticsearch for the [Searchkick gem](https://github.com/ankane/searchkick)
 Install Elasticsearch:
 
 ```
 brew install elasticsearch
 brew services start elasticsearch
 ```
 
 Add data to the search index by typing the following command in rails console:
 
 ```-
 ConversationPart.reindex
 ```


## 8.  Run the application

`cd` into the root of the project and run `rails server`. This will start the local development server. 

To test that the app is running, open the browser and go to `https://<some_string>.ngrok.io`. You should be redirected to the login page. 

Optionally you can populate the databases with the existing conversations by sending a GET request to `https://<some_string>.ngrok.io/api/populate`


