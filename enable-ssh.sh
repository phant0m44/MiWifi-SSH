#!/bin/sh
# Enables Dropbear (SSH) on Xiaomi routers and removes the root password.

nvram set ssh_en=1
nvram commit
sed -i 's/channel=.*/channel="debug"/' /etc/init.d/dropbear
/etc/init.d/dropbear start
passwd -d root
exit 0
