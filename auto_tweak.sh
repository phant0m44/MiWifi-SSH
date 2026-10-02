#!/bin/sh

# Ensure SSH port is open and Dropbear is running
iptables -D INPUT -p tcp --dport 22 -j ACCEPT 2>/dev/null
iptables -I INPUT -p tcp --dport 22 -j ACCEPT
sed -i 's/channel=.*/channel="debug"/' /etc/init.d/dropbear
pgrep dropbear >/dev/null || /etc/init.d/dropbear start

# Force maximum CPU frequency
echo "performance" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null
echo "performance" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor 2>/dev/null

sysctl -w net.netfilter.nf_conntrack_max=131072 >/dev/null 2>&1

# Enable TCP BBR to reduce latency
sysctl -w net.core.default_qdisc=fq >/dev/null 2>&1
sysctl -w net.ipv4.tcp_congestion_control=bbr >/dev/null 2>&1

# Increase TCP buffers for Wi-Fi 6
sysctl -w net.ipv4.tcp_rmem="4096 87380 16777216" >/dev/null 2>&1
sysctl -w net.ipv4.tcp_wmem="4096 65536 16777216" >/dev/null 2>&1

# Free some RAM and CPU by disabling shitty xiaomi telemetry
for service in stat_points datacenter plugin_manager milog syslog_upload; do
    if [ -f "/etc/init.d/$service" ]; then
        /etc/init.d/$service stop >/dev/null 2>&1
        /etc/init.d/$service disable >/dev/null 2>&1
    fi
done

exit 0
