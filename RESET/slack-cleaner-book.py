from slack_cleaner2 import *
import ssl
import os
ssl._create_default_https_context = ssl._create_unverified_context
s = SlackCleaner('xoxp-1624757694871-1639736885955-1836502989072-cfa52831b5810d58ab063512e6b90e2b')

# list of users
s.users

# list of all kind of channels
s.conversations

slack_channel=os.environ.get('SLACK_CHANNEL')

print (slack_channel)

# delete all messages in -bots channels
for msg in s.msgs(filter(match('slack_channel'), s.conversations)):
  # delete messages, its files, and all its replies (thread)
  msg.delete(replies=True, files=True)