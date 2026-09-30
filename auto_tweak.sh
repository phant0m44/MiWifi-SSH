#!/bin/sh

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
for service in stat_points datacenter plugin_manager; do
    if [ -f "/etc/init.d/$service" ]; then
        /etc/init.d/$service stop >/dev/null 2>&1
        /etc/init.d/$service disable >/dev/null 2>&1
    fi
done

exit 0
