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
sed -i 's/192.168.1.1/192.168.111.3/g' package/base-files/files/bin/config_generate
# sed -i 's/+IPV6:libip6tc//g' package/network/config/firewall/Makefile
# sed -i 's/+IPV6:kmod-nf-conntrack6//g' package/network/config/firewall/Makefile
# sed -i 's/+IPV6:libip6tc//g' package/network/utils/iptables/Makefile

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
sed -i 's/192.168.1.1/192.168.111.3/g' package/base-files/files/bin/config_generate
# sed -i 's/+IPV6:libip6tc//g' package/network/config/firewall/Makefile
# sed -i 's/+IPV6:kmod-nf-conntrack6//g' package/network/config/firewall/Makefile
# sed -i 's/+IPV6:libip6tc//g' package/network/utils/iptables/Makefile

# 删除原主题
rm -rf package/lean/luci-theme-argon

# 添加新的主题
git clone https://github.com/kenzok8/luci-theme-ifit.git package/lean/luci-theme-ifit

# 取消bootstrap为默认主题
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap

# 修改默认主题
sed -i "s/luci-theme-bootstrap/luci-theme-ifit/g" feeds/luci/collections/luci/Makefile
# sed -i "s/luci-theme-bootstrap/luci-theme-argon/g" feeds/luci/collections/luci/Makefile

# 修改机器名称
sed -i "s/OpenWrt/Home803P/g" package/base-files/files/bin/config_generate

# 修改密码
# sed -i 's/root:::0:99999:7:::/root:$1$qTM.tEk0$J0I9VtO1JT99G4R2iZKaA.:18858:0:99999:7:::/g' package/base-files/files/etc/shadow
#### 修改想要的root密码
sed -i 's/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/root:$1$qTM.tEk0$J0I9VtO1JT99G4R2iZKaA.:18858:0:99999:7:::/g' package/lean/default-settings/files/zzz-default-settings

# 打开NTP
# sed -i "3i uci set system.ntp.enable_server='1'" package/lean/default-settings/files/zzz-default-settings
# sed -i "s/system.ntp.enable_server='0'/system.ntp.enable_server='1'/g" package/base-files/files/bin/config_generate

# 修改连接数数
# sed -i 's/net.netfilter.nf_conntrack_max=.*/net.netfilter.nf_conntrack_max=65535/g' package/kernel/linux/files/sysctl-nf-conntrack.conf

#修正连接数
# sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf

#启动脚本插入到 'exit 0' 之前即可随系统启动运行。
# sed -i '3i /etc/init.d/samba stop' package/base-files/files/etc/rc.local #停止samba服务
# sed -i '4i /etc/init.d/samba disable' package/base-files/files/etc/rc.local #禁止samba服务开机自动

# Remove some default packages
# sed -i 's/luci-app-accesscontrol//g;s/luci-app-adbyby-plus//g;s/luci-app-ddns//g;s/luci-app-ipsec-vpnd//g;s/luci-app-nlbwmon//g;s/luci-app-ssr-plus//g;s/luci-app-ttyd//g;s/luci-app-unblockmusic//g;s/luci-app-vlmcsd//g;s/luci-app-vsftpd//g;s/luci-app-wireguard//g;s/luci-app-xlnetacc//g;s/luci-app-zerotier//g' include/target.mk

#移除不用软件包
# rm -rf package/lean/luci-app-accesscontrol
# rm -rf package/lean/luci-app-adbyby-plus
# rm -rf package/lean/luci-app-ddns
# rm -rf package/lean/luci-app-ipsec-vpnd
# rm -rf package/lean/luci-app-nlbwmon
# rm -rf package/lean/luci-app-ssr-plus
# rm -rf package/lean/luci-app-ttyd
# rm -rf package/lean/luci-app-unblockmusic
# rm -rf package/lean/luci-app-vlmcsd
# rm -rf package/lean/luci-app-vsftpd
# rm -rf package/lean/luci-app-wireguard
# rm -rf package/lean/luci-app-wol
# rm -rf package/lean/luci-app-xlnetacc
# rm -rf package/lean/luci-app-zerotier



./scripts/feeds update -a
./scripts/feeds install -a

