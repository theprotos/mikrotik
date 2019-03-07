:log info "[UPDATER] Started"
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
:local message "[UPDATER] Checking firmware and RouterOS update..."

:log info $message

/system package update
set channel=stable
check-for-updates

:delay 15s;

:if ([get installed-version] != [get latest-version]) do={
    :local installed [/system package update get installed-version]
    :local latest [/system package update get latest-version]
    :local channel [/system package update get channel]
    :local name [/system identity get name];
    :set message "1 Upgrading RouterOS on router $routerName from $installed to $latest (channel:$channel)"
    /system backup save
    :log info "[UPDATER] Sending notification to Telegram: $message";
    :local msg ("*Router: $routerName ($verFirmware@$verPackages^$routerUptime~$cpuLoad%):*%0A")
    :set $msg ($msg . "```$message```")
    /tool fetch url="$teleURL/$teleBotToken/sendMessage?chat_id=$c=teleChatToken&parse_mode=markdown&text=$msg" keep-result=no
    install
    :delay 180s;
    /system reboot
}

/system routerboard
:if ([get current-firmware] != [get upgrade-firmware]) do={
    #:local currentfw [/system routerboard get current-firmware]
    :set message "1 Updating firmware from $[/system routerboard get current-firmware] to $[/system routerboard get upgrade-firmware]";
    /system backup save
    :log info "[UPDATER] Sending notification to slack: $message";
    :local msg ("*Router: $routerName ($verFirmware@$verPackages^$routerUptime~$cpuLoad%):*%0A")
    :set $msg ($msg . "```$message```")
    /tool fetch url="$teleURL/$teleBotToken/sendMessage?chat_id=$teleChatToken&parse_mode=markdown&text=$msg" keep-result=no
    upgrade;
    :delay 180s;
    /system reboot;
    } else={
        :set message "[UPDATER] Firmware $[/system routerboard get current-firmware] and RouterOS $[/system package update get installed-version] is up to date";
        :log info $message
    }
