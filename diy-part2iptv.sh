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

echo "修改默认LAN口IP，及相应的局域网设置，详细见diy-part1.sh设置"
sed -i "/exit 0/i\chmod +x /etc/webweb.sh && source /etc/webweb.sh" $ZZZ

# Modify default IP
sed -i 's/192.168.1.1/192.168.10.77/g' package/base-files/files/bin/config_generate
# sed -i 's/+IPV6:libip6tc//g' package/network/config/firewall/Makefile
# sed -i 's/+IPV6:kmod-nf-conntrack6//g' package/network/config/firewall/Makefile
# sed -i 's/+IPV6:libip6tc//g' package/network/utils/iptables/Makefile

# Modify default NAT
# export ZZ="package/lean/default-settings/files/zzz-default-settings"
# sed -i "13i uci set network.lan.proto='static'" $ZZ
# sed -i "14i uci set network.lan.netmask='255.255.255.0'" $ZZ
# sed -i "15i uci set network.lan.gateway='192.168.10.1'" $ZZ
# sed -i "16i uci set network.lan.dns='192.168.10.1'" $ZZ
# sed -i "17i uci set network.lan.ip6assign='64'" $ZZ
# sed -i "18i uci commit network\n" $ZZ

# 修改默认主题
sed -i "s/luci-theme-bootstrap/luci-theme-mcat/g" feeds/luci/collections/luci/Makefile

# 修改机器名称
sed -i "s/OpenWrt/IPTV/g" package/base-files/files/bin/config_generate

# 修改密码
sed -i 's/root:::0:99999:7:::/root:$1$qTM.tEk0$J0I9VtO1JT99G4R2iZKaA.:18858:0:99999:7:::/g' package/base-files/files/etc/shadow
# sed -i 's/root::0:0:99999:7:::/root:$1$qTM.tEk0$J0I9VtO1JT99G4R2iZKaA.:18858:0:99999:7:::/g' package/base-files/files/etc/shadow
#### 修改想要的root密码
#sed -i 's/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/root:$1$qTM.tEk0$J0I9VtO1JT99G4R2iZKaA.:18858:0:99999:7:::/g' package/lean/default-settings/files/zzz-default-settings

# 修改连接数数
sed -i 's/net.netfilter.nf_conntrack_max=.*/net.netfilter.nf_conntrack_max=65535/g' package/kernel/linux/files/sysctl-nf-conntrack.conf

#修正连接数
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf

#启动脚本插入到 'exit 0' 之前即可随系统启动运行。
# sed -i '3i /etc/init.d/samba stop' package/base-files/files/etc/rc.local #停止samba服务
# sed -i '4i /etc/init.d/samba disable' package/base-files/files/etc/rc.local #禁止samba服务开机自动

#
# 防火墙自定义
sed -i "46i echo 'iptables -t nat -I POSTROUTING -j MASQUERADE' >> /etc/firewall.user" package/lean/default-settings/files/zzz-default-settings

# Remove some default packages
sed -i 's/luci-app-arpbind//g;s/luci-app-turboacc//g;s/luci-app-upnp//g;s/luci-app-ssr-plus//g;s/luci-app-accesscontrol//g;s/luci-app-adbyby-plus//g;s/luci-app-ddns//g;s/luci-app-ipsec-vpnd//g;s/luci-app-nlbwmon//g;s/luci-app-qbittorrent//g;s/luci-app-unblockmusic//g;s/luci-app-uugamebooster//g;s/luci-app-vlmcsd//g;s/luci-app-ttyd//g;s/luci-app-xlnetacc//g;s/luci-app-wol//g' include/target.mk

#移除不用软件包
rm -rf package/luci-app-arpbind
rm -rf package/lean/luci-app-turboacc
rm -rf package/lean/luci-app-upnp
rm -rf package/lean/luci-app-ssr-plus
rm -rf package/lean/luci-app-accesscontrol
rm -rf package/lean/luci-app-adbyby-plus
rm -rf package/lean/luci-app-ddns
rm -rf package/lean/luci-app-ipsec-vpnd
rm -rf package/lean/luci-app-nlbwmon
rm -rf package/lean/luci-app-qbittorrent
rm -rf package/lean/luci-app-wrtbwmon
rm -rf package/lean/adbyby
rm -rf package/lean/luci-app-unblockmusic
rm -rf package/lean/luci-app-uugamebooster
rm -rf package/lean/luci-app-vlmcsd
rm -rf package/lean/luci-app-vsftpd
rm -rf package/lean/luci-app-xlnetacc

./scripts/feeds update -a
./scripts/feeds install -a
