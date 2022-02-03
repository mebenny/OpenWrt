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
# git clone https://github.com/pymumu/luci-app-smartdns.git package/lean/luci-app-smartdns
# git clone https://github.com/rufengsuixing/luci-app-autoipsetadder.git package/lean/luci-app-autoipsetadder
# IPTV
echo 'src-git mebenny https://github.com/mebenny/openwrt-packages' >>feeds.conf.default
# echo 'src-git opentopd https://github.com/sirpdboy/luci-theme-opentopd' >>feeds.conf.default
# git clone https://github.com/sirpdboy/luci-theme-opentopd.git package/lean/luci-theme-opentopd
# git clone https://github.com/riverscn/luci-app-omcproxy.git package/lean/luci-app-omcproxy
# git clone https://github.com/riverscn/openwrt-iptvhelper.git package/lean/luci-app-iptvhelper
# 获取日志查看器
# git clone https://github.com/gdck/luci-app-tn-logview package/lean/luci-app-tn-logview
# 添加luci-app-advanced
# git clone https://github.com/sirpdboy/luci-app-advanced.git package/lean/luci-app-advanced
# autotimeset 定时设置插件
# git clone https://github.com/sirpdboy/luci-app-autotimeset.git package/lean/luci-app-autotimeset

# 修改IP项的EOF于EOF之间请不要插入其他扩展代码，可以删除或注释里面原本的代码
cat >$NETIP <<-EOF
uci delete network.wan                                            # 删除wan口
uci delete network.wan6                                           # 删除wan6口
uci set network.lan.type='bridge'                                 # lan口桥接
uci set network.lan.proto='static'                                # lan口静态IP
uci set network.lan.ipaddr='192.168.10.77'                        # IPv4 地址(openwrt后台地址)
uci set network.lan.netmask='255.255.255.0'                       # IPv4 子网掩码
uci set network.lan.gateway='192.168.10.1'                        # IPv4 网关
uci set network.lan.broadcast='192.168.10.255'                    # IPv4 广播
uci set network.lan.dns='192.168.10.1'                            # DNS(多个DNS要用空格分开)
uci set network.lan.delegate='0'                                  # 去掉LAN口使用内置的 IPv6 管理
uci set network.lan.ifname='eth0'                                 # 设置lan口物理接口为eth0、eth1
uci set network.lan.mtu='1492'                                    # lan口mtu设置为1492
uci commit network                                                # 不要删除跟注释,除非上面全部删除或注释掉了
uci delete dhcp.lan.ra                                            # 路由通告服务，设置为“已禁用”
uci delete dhcp.lan.ra_management                                 # 路由通告服务，设置为“已禁用”
uci delete dhcp.lan.dhcpv6                                        # DHCPv6 服务，设置为“已禁用”
uci set dhcp.lan.ignore='1'                                       # 关闭DHCP功能
uci commit dhcp                                                   # 跟‘关闭DHCP功能’联动,同时启用或者删除跟注释
# uci set system.@system[0].hostname='OpenWrtX'                     # 修改主机名称为OpenWrtX
# sed -i 's/\/bin\/login/\/bin\/login -f root/' /etc/config/ttyd    # 设置ttyd免帐号登录，如若开启，进入OPENWRT后可能要重启一次才生效
EOF

cat >$WEBWEB <<-EOF
#!/bin/bash
[[ ! -f /mnt/network ]] && chmod +x /etc/networkip && source /etc/networkip
cp -Rf /etc/config/network /mnt/network
uci set argon.@global[0].bing_background=0
uci commit argon
rm -rf /etc/networkip
rm -rf /etc/webweb.sh
exit 0
EOF

echo "diy-part1.sh已执行完毕！"
