#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
# sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
# echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
# echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
# echo 'src-git opentopd  https://github.com/sirpdboy/sirpdboy-package' >>feeds.conf.default
# echo 'src-git kenzo https://github.com/kenzok8/openwrt-packages' >>feeds.conf.default
# echo 'src-git small https://github.com/kenzok8/small' >>feeds.conf.default
# echo 'src-git kiddin9 https://github.com/kiddin9/openwrt-packages' >>feeds.conf.default
# echo 'src-git xiaorouji https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
# echo 'src-git mebenny https://github.com/mebenny/openwrt-packages' >>feeds.conf.default
# git clone https://github.com/pymumu/luci-app-smartdns.git package/lean/luci-app-smartdns
# git clone https://github.com/rufengsuixing/luci-app-autoipsetadder.git package/lean/luci-app-autoipsetadder
# IPTV
# git clone https://github.com/riverscn/luci-app-omcproxy.git package/lean/luci-app-omcproxy
# git clone https://github.com/riverscn/openwrt-iptvhelper.git package/lean/luci-app-iptvhelper
# 获取日志查看器
# git clone https://github.com/gdck/luci-app-tn-logview package/lean/luci-app-tn-logview
# 添加luci-app-advanced
# git clone https://github.com/sirpdboy/luci-app-advanced package/lean/luci-app-advanced

#sirpdboy
# autotimeset 定时设置插件
# git clone https://github.com/sirpdboy/luci-app-autotimeset package/lean/luci-app-autotimeset

