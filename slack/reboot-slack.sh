:log info "[REBOOTER] Started"
#== Get env varibles ==
:global slackURL
:global slackToken
#======================
:local message "[REBOOTER] Regular reboot..."
:local routerName [/system identity get name]

:log info $message
:log info "[REBOOTER] Sending notification to slack: $message"

/tool fetch mode=https url="$slackURL/$slackToken" http-method=post http-data="payload={
\"attachments\": [
{
\"title\": \"Router $routerName (uptime $[/system resource get uptime])\",
\"text\": \"[$routerName] $message\",  \"color\": \"danger\" }
] }"
:delay 15s;
/system reboot
