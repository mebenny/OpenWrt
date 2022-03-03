#!/bin/bash
#============================================================
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#============================================================

REPO_URL="https://github.com/coolsnowwolf/lede"     # 编译固件源码链接（请勿修改）
REPO_BRANCH="master"                                # 源码链接的分支（请勿修改）
CONFIG_FILE=".config"            # 配置文件（可SSH远程定制固件插件，也可在本地提取配置粘贴到此文件）
DIY_PART_SH="diy-part.sh"        # 自定义文件(增加插件或者修改IP之类的自定义设置)
SSH_ACTIONS="false"              # SSH远程配置固件（true=开启）（false=关闭）
UPLOAD_BIN_DIR="false"           # 上传【bin文件夹】到github空间（true=开启）（false=关闭）
UPLOAD_CONFIG="true"             # 上传【.config】配置文件到github空间（true=开启）（false=关闭）
UPLOAD_FIRMWARE="true"           # 上传固件到github空间（true=开启）（false=关闭）
UPLOAD_COWTRANSFER="false"       # 上传固件到到【奶牛快传】和【WETRANSFER】（true=开启）（false=关闭）
UPLOAD_RELEASE="true"           # 发布固件（true=开启）（false=关闭）
SERVERCHAN_SCKEY="TELE"          # Telegram或push通知,填"TELE"为Telegram通知，填"PUSH"为pushplus通知，（false=关闭）
USE_CACHEWRTBUILD="true"         # 是否开启缓存加速,如出现带有缓存编译时莫名错误导致失败的,请关闭（true=开启）（false=关闭）
REGULAR_UPDATE="true"            # 把自动在线更新的插件编译进固件（请看说明）（true=开启）（false=关闭）
AUTO_UPDATE="true"                     # 把编译的自动更新固件上传至Github AutoUpdate（true=开启）（false=关闭）
BY_INFORMATION="true"            # 是否显示编译信息,如出现信息显示错误导致信息不显示,请关闭（true=开启）（false=关闭）

echo '修改 IP设置'
cat >$NETIP <<-EOF
uci delete network.wan                                                               # 删除wan口
uci delete network.wan6                                                             # 删除wan6口
uci set network.lan.type='bridge'                                               # lan口桥接
uci set network.lan.proto='static'                                               # lan口静态IP
uci set network.lan.ipaddr='192.168.1.2'                                    # IPv4 地址(openwrt后台地址)
uci set network.lan.netmask='255.255.255.0'                             # IPv4 子网掩码
uci set network.lan.gateway='192.168.1.1'                                 # IPv4 网关
#uci set network.lan.broadcast='192.168.1.255'                           # IPv4 广播
uci set network.lan.dns='192.168.1.2'                                         # DNS(多个DNS要用空格分开)
uci set network.lan.delegate='0'                                                 # 去掉LAN口使用内置的 IPv6 管理
uci set network.lan.ifname='eth0'                                               # 设置lan口物理接口为eth0
#uci set network.lan.ifname='eth0 eth1'                                     # 设置lan口物理接口为eth0、eth1
uci set network.lan.mtu='1492'                                                   # lan口mtu设置为1492
uci delete network.lan.ip6assign                                                 #接口→LAN→IPv6 分配长度——关闭，恢复uci set network.lan.ip6assign='64'
uci commit network
uci delete dhcp.lan.ra                                                                  # 路由通告服务，设置为“已禁用”
uci delete dhcp.lan.ra_management                                           # 路由通告服务，设置为“已禁用”
uci delete dhcp.lan.dhcpv6                                                         # DHCPv6 服务，设置为“已禁用”
uci set dhcp.lan.ignore='1'                                                          # 关闭DHCP功能
uci set dhcp.@dnsmasq[0].filter_aaaa='1'                                   # DHCP/DNS→高级设置→解析 IPv6 DNS 记录——禁止
uci set dhcp.@dnsmasq[0].cachesize='0'                                    # DHCP/DNS→高级设置→DNS 查询缓存的大小——设置为'0'
uci add dhcp domain
uci set dhcp.@domain[0].name='openwrtx'                                 # 网络→主机名→主机目录——“openwrtx”
uci set dhcp.@domain[0].ip='192.168.1.2'                                  # 对应IP解析——192.168.1.2
uci add dhcp domain
uci set dhcp.@domain[1].name='cdn.jsdelivr.net'                       # 网络→主机名→主机目录——“cdn.jsdelivr.net”
uci set dhcp.@domain[1].ip='104.16.86.20'                                 # 对应IP解析——'104.16.86.20'
uci commit dhcp
uci delete firewall.@defaults[0].syn_flood                                 # 防火墙→SYN-flood 防御——关闭；默认开启
uci set firewall.@defaults[0].fullcone='1'                                     # 防火墙→FullCone-NAT——启用；默认关闭
uci commit firewall
uci set dropbear.@dropbear[0].Port='8822'                                # SSH端口设置为'8822'
uci commit dropbear
uci set system.@system[0].hostname='OpenWrtX'                     # 修改主机名称为OpenWrtX
sed -i 's/\/bin\/login/\/bin\/login -f root/' /etc/config/ttyd       # 设置ttyd免帐号登录，如若开启，进入OPENWRT后可能要重启一次才生效
EOF

echo '选择argon为默认主题'
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

echo '增加个性名字 ${Author} 默认为你的github帐号'
sed -i "s/OpenWrt /Ss. compiled in $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" $ZZZ

echo '恢复OPKG软件源为snapshot'
sed -i '/openwrt_luci/d' $ZZZ

# x86机型,默认内核5.10，修改内核为5.15
#sed -i 's/PATCHVER:=5.10/PATCHVER:=5.15/g' target/linux/x86/Makefile

echo '设置密码为空'
sed -i '/CYXluq4wUazHjmCDBCqXF/d' $ZZZ

#############################################pushd#############################################
pushd feeds/luci
cd applications

echo "添加插件 luci-app-advanced"
rm -rf ./luci-app-advanced
git clone https://github.com/sirpdboy/luci-app-advanced

cd ../themes

echo "添加主题 new theme neobird"
rm -rf ./luci-theme-neobird
git clone https://github.com/thinktip/luci-theme-neobird.git

#echo "添加插件 luci-app-passwall"
#git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall

#echo "添加插件 luci-app-ssr-plus"
#git clone --depth=1 https://github.com/fw876/helloworld luci-app-ssr-plus

popd
#############################################popd#############################################

echo "修改插件名字"
sed -i 's/"Argon 主题设置"/"Argon设置"/g' `grep "Argon 主题设置" -rl ./`
sed -i 's/"Turbo ACC 网络加速"/"Turbo ACC"/g' `grep "Turbo ACC 网络加速" -rl ./`

# 在线更新删除不想保留固件的某个文件，在EOF跟EOF直接加入删除代码，比如： rm /etc/config/luci，rm /etc/opkg/distfeeds.conf
#cat >$DELETE <<-EOF
#EOF

# 整理固件包时候,删除您不想要的固件或者文件,让它不需要上传到Actions空间
cat >${GITHUB_WORKSPACE}/Clear <<-EOF
rm -rf config.buildinfo
rm -rf feeds.buildinfo
rm -rf openwrt-x86-64-generic-kernel.bin
rm -rf openwrt-x86-64-generic.manifest
rm -rf sha256sums
rm -rf version.buildinfo
EOF


ZZZ="package/lean/default-settings/files/zzz-default-settings"
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 整理固件包时候,删除您不想要的固件或者文件,让它不需要上传到Actions空间
cat >${GITHUB_WORKSPACE}/Clear <<-EOF
rm -rf config.buildinfo
rm -rf feeds.buildinfo
rm -rf sha256sums
rm -rf version.buildinfo
EOF


#禁止内网访问公网某个IP或域名
iptables -I FORWARD -d 8.8.8.8 -j DROP
iptables -I FORWARD -d 8.8.4.4 -j DROP
#端口转发，将10809端口转发至hostyun.kxsw.fun:443
iptables -t nat -A PREROUTING -p tcp --dport 10809 -j DNAT --to-destination hostyun.kxsw.fun:443

# 获取日志查看器
git clone https://github.com/gdck/luci-app-tn-logview package/lean/luci-app-tn-logview

#本地启动脚本
#启动脚本插入到 'exit 0' 之前即可随系统启动运行。
sed -i '3i /etc/init.d/samba stop' package/base-files/files/etc/rc.local #停止samba服务
sed -i '4i /etc/init.d/samba disable' package/base-files/files/etc/rc.local #禁止samba服务开机自动

#移除不用软件包
rm -rf package/lean/luci-app-dockerman
rm -rf package/lean/luci-app-wrtbwmon
rm -rf package/lean/adbyby
rm -rf package/lean/luci-app-adbyby-plus

# Modify default IP
sed -i 's/192.168.1.1/192.168.2.2/g' package/base-files/files/bin/config_generate                  # 修改后台IP地址
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile            # 选择argon为默认主题
sed -i "s/OpenWrt /281677160 compiled in $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" $ZZZ           # 增加个性名字 281677160
sed -i '/CYXluq4wUazHjmCDBCqXF/d' $ZZZ                                                             # 设置密码为空

# 修改网络
sed -i 's/eth0/eth0 eth2 eth3/' package/base-files/files/etc/board.d/99-default_network
sed -i '2i # network config' package/lean/default-settings/files/zzz-default-settings
sed -i "3i uci set network.wan.proto='pppoe'" package/lean/default-settings/files/zzz-default-settings
sed -i "4i uci set network.wan.username='CD0283366379757'" package/lean/default-settings/files/zzz-default-settings
sed -i "5i uci set network.wan.password='19701115'" package/lean/default-settings/files/zzz-default-settings
sed -i "6i uci set network.wan.ifname='eth1'" package/lean/default-settings/files/zzz-default-settings
sed -i "7i uci set network.wan6.ifname='eth1'" package/lean/default-settings/files/zzz-default-settings
sed -i '8i uci commit network' package/lean/default-settings/files/zzz-default-settings

# 修改密码
sed -i 's/V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0/SOP5eWTA$fJV8ty3QohO0chErhlxCm1:18775/g' package/lean/default-settings/files/zzz-default-settings

# 修改默认主题
sed -i 's/bootstrap/argon/' feeds/luci/collections/luci/Makefile

# 删除文件夹
rm -rf package/lean/adbyby
rm -rf package/lean/luci-app-adbyby-plus
rm -rf package/lean/luci-app-unblockmusic
rm -rf package/lean/UnblockNeteaseMusic
rm -rf package/lean/UnblockNeteaseMusicGo
# 修改插件名字
sed -i 's/"aMule设置"/"电驴下载"/g' `grep "aMule设置" -rl ./`
sed -i 's/"网络存储"/"NAS"/g' `grep "网络存储" -rl ./`
sed -i 's/"Turbo ACC 网络加速"/"网络加速"/g' `grep "Turbo ACC 网络加速" -rl ./`
sed -i 's/"实时流量监测"/"流量"/g' `grep "实时流量监测" -rl ./`
sed -i 's/"KMS 服务器"/"KMS激活"/g' `grep "KMS 服务器" -rl ./`
sed -i 's/"TTYD 终端"/"命令窗"/g' `grep "TTYD 终端" -rl ./`
sed -i 's/"USB 打印服务器"/"打印服务"/g' `grep "USB 打印服务器" -rl ./`
sed -i 's/"Web 管理"/"Web"/g' `grep "Web 管理" -rl ./`
sed -i 's/"管理权"/"改密码"/g' `grep "管理权" -rl ./`
sed -i 's/"带宽监控"/"监控"/g' `grep "带宽监控" -rl ./`
sed -i 's/"Argon 主题设置"/"Argon设置"/g' `grep "Argon 主题设置" -rl ./`
# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate
#移除不用软件包    
rm -rf package/lean/luci-app-dockerman
rm -rf package/lean/luci-app-wrtbwmon
rm -rf feeds/packages/net/smartdns

#添加额外软件包
git clone https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter

#replace mirrors
#rm -rf ./include
#rm -rf ./ scripts
#svn co https://github.com/immortalwrt/immortalwrt/trunk/include
#svn co https://github.com/immortalwrt/immortalwrt/trunk/scripts

git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/luci-app-jd-dailybonus
git clone https://github.com/jerrykuku/luci-app-ttnode.git package/luci-app-ttnode
git clone https://github.com/jerrykuku/lua-maxminddb.git package/lua-maxminddb
git clone https://github.com/jerrykuku/luci-app-vssr.git package/luci-app-vssr
git clone https://github.com/kongfl888/luci-app-adguardhome.git package/luci-app-adguardhome
svn co https://github.com/lisaac/luci-app-dockerman/trunk/applications/luci-app-dockerman package/luci-app-dockerman
git clone https://github.com/rufengsuixing/luci-app-autoipsetadder.git package/luci-app-autoipsetadder
git clone https://github.com/mchome/openwrt-dogcom.git package/openwrt-dogcom
git clone https://github.com/mchome/luci-app-dogcom.git package/luci-app-dogcom
#git clone https://github.com/garypang13/luci-app-dnsfilter package/luci-app-dnsfilter
git clone https://github.com/small-5/luci-app-adblock-plus package/luci-app-adblock-plus
git clone https://github.com/project-lede/luci-app-godproxy package/luci-app-godproxy

#git clone https://github.com/vernesong/OpenClash.git package/OpenClash
#cp -r package/OpenClash/luci-app-openclash package/
#rm -rf package/OpenClash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
# 编译 po2lmo (如果有po2lmo可跳过)
pushd package/luci-app-openclash/tools/po2lmo
make && sudo make install
popd
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/brook package/brook
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/chinadns-ng package/chinadns-ng
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/tcping package/tcping
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/trojan-go package/trojan-go
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/trojan-plus package/trojan-plus
#svn co https://github.com/immortalwrt/luci/branches/openwrt-18.06/applications/luci-app-filebrowser package/luci-app-filebrowser
#svn co https://github.com/immortalwrt/packages/branches/openwrt-18.06/utils/filebrowser package/filebrowser
#svn co https://github.com/immortalwrt/luci/branches/openwrt-18.06/applications/luci-app-fileassistant package/luci-app-fileassistant
svn co https://github.com/immortalwrt/luci/branches/openwrt-18.06/applications/luci-app-socat package/luci-app-socat
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/luci-app-passwall package/luci-app-passwall
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/ssocks package/ssocks
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/hysteria package/hysteria
svn co https://github.com/fw876/helloworld/trunk/xray-core package/xray-core
svn co https://github.com/fw876/helloworld/trunk/xray-plugin package/xray-plugin
svn co https://github.com/fw876/helloworld/trunk/shadowsocks-rust package/shadowsocks-rust
svn co https://github.com/fw876/helloworld/trunk/shadowsocksr-libev package/shadowsocksr-libev
svn co https://github.com/fw876/helloworld/trunk/v2ray-plugin package/v2ray-plugin
svn co https://github.com/fw876/helloworld/trunk/v2ray-core package/v2ray-core
#svn co https://github.com/xiaorouji/openwrt-passwall/trunk/xray-core package/xray-core
#svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-gost package/luci-app-gost
#svn co https://github.com/kenzok8/openwrt-packages/trunk/gost package/gost
svn co https://github.com/immortalwrt/luci/branches/openwrt-18.06/applications/luci-app-gost package/luci-app-gost
svn co https://github.com/immortalwrt/packages/branches/openwrt-18.06/net/gost package/gost
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-eqos package/luci-app-eqos
git clone https://github.com/tty228/luci-app-serverchan.git package/luci-app-serverchan
# cd package/luci-app-serverchan && git reset --hard 6387b3b47b03d95d3f3bcd42ff98db5bb84fd056 && git pull && cd ../..
svn co https://github.com/brvphoenix/wrtbwmon/trunk/wrtbwmon package/wrtbwmon
git clone https://github.com/brvphoenix/luci-app-wrtbwmon
cd luci-app-wrtbwmon
git reset --hard ff7773abbf71120fc39a276393b29ba47353a7e2
cp -r luci-app-wrtbwmon ../package/
cd ..
# themes
git clone https://github.com/Leo-Jo-My/luci-theme-Butterfly package/luci-theme-Butterfly
git clone https://github.com/Leo-Jo-My/luci-theme-Butterfly-dark package/luci-theme-Butterfly-dark
svn co https://github.com/apollo-ng/luci-theme-darkmatter/trunk/luci/themes/luci-theme-darkmatter package/luci-theme-darkmatter
svn co https://github.com/solidus1983/luci-theme-opentomato/trunk/luci/themes/luci-theme-opentomato package/luci-theme-opentomato
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-edge package/luci-theme-edge
#svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-argon_new package/luci-theme-argon_new
svn co https://github.com/rosywrt/luci-theme-rosy/trunk/luci-theme-rosy package/luci-theme-rosy
#svn co https://github.com/rosywrt/luci-theme-purple/trunk/luci-theme-purple package/luci-theme-purple
git clone https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
git clone https://github.com/Leo-Jo-My/luci-theme-opentomcat.git package/luci-theme-opentomcat
git clone https://github.com/openwrt-develop/luci-theme-atmaterial.git package/luci-theme-atmaterial
git clone https://github.com/sirpdboy/luci-theme-opentopd package/luci-theme-opentopd
git clone https://github.com/xrouterservice/luci-app-koolddns.git package/luci-app-koolddns
svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/luci-app-ssr-plus
svn co https://github.com/fw876/helloworld/trunk/naiveproxy package/naiveproxy
#赋予koolddns权限
chmod 0755 package/luci-app-koolddns/root/etc/init.d/koolddns
chmod 0755 package/luci-app-koolddns/root/usr/share/koolddns/aliddns

svn co https://github.com/immortalwrt/luci/branches/openwrt-18.06/applications/luci-app-unblockneteasemusic-mini package/luci-app-unblockneteasemusic-mini
#添加subweb&subconverter
svn co https://github.com/immortalwrt/packages/branches/openwrt-18.06/libs/quickjspp package/quickjspp
svn co https://github.com/immortalwrt/packages/branches/openwrt-18.06/libs/jpcre2 package/jpcre2
svn co https://github.com/immortalwrt/packages/branches/openwrt-18.06/libs/libcron/ package/libcron
svn co https://github.com/immortalwrt/packages/branches/openwrt-18.06/libs/rapidjson package/rapidjson
#svn co https://github.com/immortalwrt/immortalwrt/trunk/package/ctcgfw/subweb package/subweb
svn co https://github.com/immortalwrt/packages/branches/openwrt-18.06/net/subconverter package/subconverter
#添加smartdns
#svn co https://github.com/immortalwrt/packages/branches/openwrt-18.06/net/smartdns package/smartdns
svn co https://github.com/kenzok8/openwrt-packages/trunk/smartdns package/smartdns
svn co https://github.com/garypang13/openwrt-packages/trunk/smartdns-le package/smartdns-le
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-smartdns package/luci-app-smartdns

#git clone https://github.com/pymumu/openwrt-smartdns package/smartdns
#git clone -b lede https://github.com/pymumu/luci-app-smartdns.git package/luci-app-smartdns
svn co https://github.com/linkease/ddnsto-openwrt/trunk/ddnsto package/ddnsto
svn co https://github.com/linkease/ddnsto-openwrt/trunk/luci-app-ddnsto package/luci-app-ddnsto
#添加ksmbd
#svn co https://github.com/openwrt/luci/trunk/applications/luci-app-ksmbd package/luci-app-ksmbd
#添加udp2raw
#git clone https://github.com/sensec/openwrt-udp2raw package/openwrt-udp2raw
#git clone https://github.com/sensec/luci-app-udp2raw package/luci-app-udp2raw
#sed -i "s/PKG_SOURCE_VERSION:=.*/PKG_SOURCE_VERSION:=f2f90a9a150be94d50af555b53657a2a4309f287/" package/openwrt-udp2raw/Makefile
#sed -i "s/PKG_VERSION:=.*/PKG_VERSION:=20200920\.0/" package/openwrt-udp2raw/Makefile
svn co https://github.com/immortalwrt/packages/branches/openwrt-18.06/net/udp2raw-tunnel package/udp2raw-tunnel
svn co https://github.com/immortalwrt/luci/branches/openwrt-18.06/applications/luci-app-udp2raw package/luci-app-udp2raw
#添加luci-app-advanced
git clone https://github.com/sirpdboy/luci-app-advanced package/luci-app-advanced
#添加luci-app-amlogic
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic
#修改晶晨宝盒默认配置
# 1.Set the download repository of the OpenWrt files to your github.com （OpenWrt 文件的下载仓库）
sed -i "s|https.*/amlogic-s9xxx-openwrt|https://github.com/HoldOnBro/Actions-OpenWrt|g" package/luci-app-amlogic/root/etc/config/amlogic

# 2.Modify the keywords of Tags in your github.com Releases （Releases 里 Tags 的关键字）
sed -i "s|s9xxx_lede|ARMv8|g" package/luci-app-amlogic/root/etc/config/amlogic

# 3.Modify the suffix of the OPENWRT files in your github.com Releases （Releases 里 OpenWrt 文件的后缀）
sed -i "s|.img.gz|+_FOL+SFE.img.gz|g" package/luci-app-amlogic/root/etc/config/amlogic

# 4.Set the download path of the kernel in your github.com repository （OpenWrt 内核的下载路径）
sed -i "s|http.*/library|https://github.com/HoldOnBro/Actions-OpenWrt/tree/master/BuildARMv8|g" package/luci-app-amlogic/root/etc/config/amlogic

#添加argon-config 使用 最新argon
git clone https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
rm -rf package/lean/luci-theme-argon/
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
#修改makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/luci\.mk/include \$(TOPDIR)\/feeds\/luci\/luci\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/include\ \.\.\/\.\.\/lang\/golang\/golang\-package\.mk/include \$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang\-package\.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHREPO/PKG_SOURCE_URL:=https:\/\/github\.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=\@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload\.github\.com/g' {}
#svn co https://github.com/immortalwrt/immortalwrt/trunk/include/download.mk include/download.mk
#svn co https://github.com/immortalwrt/immortalwrt/trunk/include/package-immortalwrt.mk include/package-immortalwrt.mk

#readd cpufreq for aarch64
sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(arm\|\|aarch64\)/g' package/lean/luci-app-cpufreq/Makefile

#replace coremark.sh with the new one
cp -f $GITHUB_WORKSPACE/general/coremark.sh feeds/packages/utils/coremark/

find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-vssr/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-alt/shadowsocksr-libev-ssr-redir/g' {}
find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-vssr/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-server/shadowsocksr-libev-ssr-server/g' {}
#修改bypass的makefile
#find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-bypass/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-ssr-redir/shadowsocksr-libev-alt/g' {}
#find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-bypass/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-ssr-server/shadowsocksr-libev-server/g' {}

svn co https://github.com/kiddin9/openwrt-bypass/trunk/luci-app-bypass package/luci-app-bypass
find package/luci-app-bypass/* -maxdepth 8 -path "*" | xargs -i sed -i 's/smartdns-le/smartdns/g' {}

#temp fix for dnsforwarder
#sed -i "s/PKG_SOURCE_URL:=.*/PKG_SOURCE_URL:=https:\/\/github\.com\/1715173329\/dnsforwarder\.git/" package/lean/dnsforwarder/Makefile
#sed -i "s/PKG_SOURCE_VERSION:=.*/PKG_SOURCE_VERSION:=587e61ae4d75dc976f538088b715a3c8ee26c144/" package/lean/dnsforwarder/Makefile
#sed -i "s/\ \ URL:=.*/\ \ URL:=https:\/\/github\.com\/1715173329\/dnsforwarder/" package/lean/dnsforwarder/Makefile

./scripts/feeds update -a
./scripts/feeds install -a
