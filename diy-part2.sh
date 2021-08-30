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

# 修改默认主题为luci-theme-argon_new
# sed -i "s/luci-theme-argon_new/$default_theme/g" feeds/luci/modules/luci-base/root/etc/config/luci

# 修改密码为空
# sed -i 's/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.//g' openwrt/package/lean/default-settings/files/zzz-default-settings
# sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow
# ZZZ="package/lean/default-settings/files/zzz-default-settings"
# sed -i '/CYXluq4wUazHjmCDBCqXF/d' $ZZZ
# sed -i 's@.*CYXluq4wUazHjmCDBCqXF*@#&@g' package/lean/default-settings/files/zzz-default-settings  #设置密码为空（安装固件时无需密码登陆，然后自己修改想要的密码）

#2. Clear the login password
sed -i 's/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.//g' openwrt/package/lean/default-settings/files/zzz-default-settings

#取消掉feeds.conf.default文件里面的helloworld的#注释
# sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default  #使用源码自带ShadowSocksR Plus+出国软件

# 自定义内容
sed -i 's/OpenWrt /meBenny compiled in $(TZ=UTC-8 date +%Y.%m.%d) @ OpenWrt /g' $ZZZ

# 修改机器名称
# sed -i "s/meBenny/$device_name/g" package/base-files/files/bin/config_generate

# 修改时区
# sed -i "s/'UTC'/'CST-8'\n   set system.@system[-1].zonename='$utc_name'/g" package/base-files/files/bin/config_generate
