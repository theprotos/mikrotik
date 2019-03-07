:log info "[UPDATER] Started"
#== Get env varibles ==
:global slackURL
:global slackToken
#======================
:local message "[UPDATER] Checking firmware and RouterOS update..."
:local routerName [/system identity get name]

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
    :set message "Upgrading RouterOS on router $routerName from $installed to $latest (channel:$channel)"
    /system backup save
    :log info "[UPDATER] Sending notification to Slack: $message";
    /tool fetch mode=https url=$slackURL/$slackToken" http-method=post http-data="payload={
    \"attachments\": [
    {
    \"title\": \"Router $routerName (uptime $[/system resource get uptime])\",
    \"text\": \"[$routerName] $message\",  \"color\": \"danger\" }
    ] }";
    install
    #/system reboot
} else={
    /system routerboard
    :if ([get current-firmware] != [get upgrade-firmware]) do={
        #:local currentfw [/system routerboard get current-firmware]
        :set message "Updating firmware from $[/system routerboard get current-firmware] to $[/system routerboard get upgrade-firmware]";
        /system backup save
        :log info "[UPDATER] Sending notification to slack: $message";
        /tool fetch mode=https url="$slackURL/$slackToken" http-method=post http-data="payload={
        \"attachments\": [
        {
        \"title\": \"Router $routerName (uptime $[/system resource get uptime])\",
        \"text\": \"[$routerName] $message\",  \"color\": \"danger\" }
        ] }";
        upgrade;
        :delay 180s;
        /system reboot;
        } else={
            :set message "[UPDATER] Firmware $[/system routerboard get current-firmware] and RouterOS $[/system package update get installed-version] is up to date";
            :log info $message
            #:log info "Sending notifiction to slack: $message";
            #/tool fetch mode=https url="$slackURL/$slackToken" http-method=post http-data="payload={
            #\"attachments\": [
            #{
            #\"title\": \"Router $routerName Firmware Status\",
            #\"text\": \"[$routerName] $message\",  \"color\": \"danger\" }
            #] }";
        }
    }
