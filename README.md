# Mikrotik automation 

## Scripts  
- credentials-slack.sh  
    Set global variables: ``slackToken``, ``slackURL``
- credentials-telegram.sh    
    Set global variables: ``teleBotToken``, ``teleChatToken``, ``teleURL``

    
- logging-slack.sh
    Send desired log events to slack
- logging-telegram.sh
    Send desired log events to telegram


- upgrade-slack.sh
    Check and Update RouterOS and packages; make backup; send notification to slack 
- upgrade-telegram.sh
    Check and Update RouterOS and packages; make backup; send notification to slack


- reboot-slack.sh
    Reboot device and send notification to slack
- reboot-telegram.sh
    Reboot device and send notification to slack

## How to setup Telegram alerts
  - Create telegram bot and save bot-id
  - add bot to channel.
  - get channel-id as https://api.telegram.org/bot<bot-id>/getUpdates
  - put bot-id to ``teleBotToken``
  - put channel-id to ``teleChatToken``

###TODO  
- https://wiki.mikrotik.com/wiki/Bruteforce_login_prevention
- if no internet
