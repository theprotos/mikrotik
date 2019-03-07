:log info "[REBOOTER] Started"
#== Get env varibles ==
:global teleURL
:global teleChatToken
:global teleBotToken
#======================
:local routerName [/system identity get name]
:local routerUptime [/system resource get uptime]
:local cpuLoad [/system resource get cpu-load]
:local verFirmware [/system routerboard get current-firmware]
:local verPackages [/system package update get installed-version]
:local message "[REBOOTER] Regular reboot..."

:log info $message
:log info "[REBOOTER] Sending notification to Telegram: $message"
:local msg ("*Router: $routerName ($verFirmware@$verPackages^$routerUptime~$cpuLoad%):*%0A")
:set $msg ($msg . "```$message```")
/tool fetch url="$teleURL/$teleBotToken/sendMessage?chat_id=$teleChatToken&parse_mode=markdown&text=$msg" keep-result=no

:delay 15s;
/system reboot
