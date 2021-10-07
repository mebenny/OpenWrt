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

# 修改默认主题
sed -i "s/luci-theme-bootstrap/luci-theme-opentomcat/g" feeds/luci/collections/luci/Makefile

# 修改机器名称
sed -i "s/OpenWrt/Home803/g" package/base-files/files/bin/config_generate

# 修改密码
sed -i 's/root::0:0:99999:7:::/root:$1$qTM.tEk0$J0I9VtO1JT99G4R2iZKaA.:18858:0:99999:7:::/g' package/base-files/files/etc/shadow

# 修改路由


# 修改时区
# sed -i "s/'UTC'/'CST-8'\n   set system.@system[-1].zonename='$utc_name'/g" package/base-files/files/bin/config_generate
