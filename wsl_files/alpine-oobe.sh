# put file in /etc folder
#!/bin/sh
set -ue
DEFAULT_GROUPS='wheel'
DEFAULT_UID='1000'
apk add doas
/usr/sbin/adduser -u $DEFAULT_UID -G $DEFAULT_GROUPS jimmy
