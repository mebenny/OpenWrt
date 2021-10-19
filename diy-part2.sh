#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.10.15/g' package/base-files/files/bin/config_generate
# sed -i 's/+IPV6:libip6tc//g' package/network/config/firewall/Makefile
# sed -i 's/+IPV6:kmod-nf-conntrack6//g' package/network/config/firewall/Makefile
# sed -i 's/+IPV6:libip6tc//g' package/network/utils/iptables/Makefile

# 修改默认主题
sed -i "s/luci-theme-bootstrap/luci-theme-opentomcat/g" feeds/luci/collections/luci/Makefile

# 修改机器名称
sed -i "s/OpenWrt/Home803/g" package/base-files/files/bin/config_generate

# 修改密码
sed -i 's/root::0:0:99999:7:::/root:$1$qTM.tEk0$J0I9VtO1JT99G4R2iZKaA.:18858:0:99999:7:::/g' package/base-files/files/etc/shadow
#### 修改想要的root密码
#sed -i 's/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/root:$1$qTM.tEk0$J0I9VtO1JT99G4R2iZKaA.:18858:0:99999:7:::/g' package/lean/default-settings/files/zzz-default-settings

# 打开NTP
sed -i "s/'0'/'1'\n   set system.ntp.enable_server='$ntp_name'/g" package/base-files/files/bin/config_generate

# Modify default network connect
echo 'net.netfilter.nf_conntrack_max=65535' | tee -a package/base-files/files/etc/sysctl.conf
echo 'net.ipv6.conf.default.forwarding=2' | tee -a package/base-files/files/etc/sysctl.conf
echo 'net.ipv6.conf.all.forwarding=2' | tee -a package/base-files/files/etc/sysctl.conf
echo 'net.ipv6.conf.default.accept_ra=2' | tee -a package/base-files/files/etc/sysctl.conf
echo ' net.ipv6.conf.all.accept_ra=2' | tee -a package/base-files/files/etc/sysctl.conf
# sed -i "2i net.netfilter.nf_conntrack_max=65535" ./package/base-files/files/etc/sysctl.conf
# sed -i "3i net.ipv6.conf.default.forwarding=2" ./package/base-files/files/etc/sysctl.conf
# sed -i "4i net.ipv6.conf.all.forwarding=2" ./package/base-files/files/etc/sysctl.conf
# sed -i "5i net.ipv6.conf.default.accept_ra=2" ./package/base-files/files/etc/sysctl.conf
# sed -i "6i net.ipv6.conf.all.accept_ra=2" ./package/base-files/files/etc/sysctl.conf

#启动脚本插入到 'exit 0' 之前即可随系统启动运行。
sed -i '3i /etc/init.d/samba stop' package/base-files/files/etc/rc.local #停止samba服务
sed -i '4i /etc/init.d/samba disable' package/base-files/files/etc/rc.local #禁止samba服务开机自动

# Remove some default packages
sed -i 's/luci-app-accesscontrol//g;s/luci-app-adbyby-plus//g;s/luci-app-ddns//g;s/luci-app-ipsec-vpnd//g;s/luci-app-nlbwmon//g;s/luci-app-qbittorrent//g;s/luci-app-unblockmusic//g;s/luci-app-uugamebooster//g;s/luci-app-vlmcsd//g;s/luci-app-vsftpd//g;s/luci-app-xlnetacc//g' include/target.mk

#移除不用软件包
rm -rf package/lean/luci-app-accesscontrol
rm -rf package/lean/luci-app-adbyby-plus
rm -rf package/lean/luci-app-ddns
rm -rf package/lean/luci-app-ipsec-vpnd
rm -rf package/lean/luci-app-nlbwmon
rm -rf package/lean/luci-app-qbittorrent
rm -rf package/lean/luci-app-dockerman
rm -rf package/lean/luci-app-wrtbwmon
rm -rf package/lean/adbyby
rm -rf package/lean/luci-app-unblockmusic
rm -rf package/lean/luci-app-uugamebooster
rm -rf package/lean/luci-app-vlmcsd
rm -rf package/lean/luci-app-vsftpd
rm -rf package/lean/luci-app-xlnetacc
rm -rf package/lean/luci-app-jd-dailybonus
rm -rf package/lean/luci-theme-argon
rm -rf package/lean/luci-app-netdata
rm -rf package/lean/luci-app-wireless-regdb
rm -rf package/lean/luci-app-serverchan
rm -rf package/lean/luci-app-pushbot
rm -rf package/lean/luci-app-ahcp
rm -rf package/lean/luci-app-amule
rm -rf package/lean/luci-app-kodexplorer
rm -rf package/lean/luci-app-vnstat
rm -rf feeds/packages/net/smartdns
rm -rf feeds/luci/applications/luci-app-openclash
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-vssr

# 修改时区
# sed -i "s/'UTC'/'CST-8'\n   set system.@system[-1].zonename='$utc_name'/g" package/base-files/files/bin/config_generate

./scripts/feeds update -a
./scripts/feeds install -a
