#!/bin/bash

# echo '修改默认LAN口IP'
# sed -i 's/192.168.1.1/192.168.1.2/g' package/base-files/files/bin/config_generate

echo "修改默认LAN口IP，及相应的局域网设置，详细见diy-part1.sh设置"
sed -i "/exit 0/i\chmod +x /etc/webweb.sh && source /etc/webweb.sh" $ZZZ

# 设置密码为空
sed -i '/CYXluq4wUazHjmCDBCqXF/d' $ZZZ

# 选择argon为默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 更换 opkg 源
# echo "sed -i 's#https://mirrors.cloud.tencent.com/lede/snapshots#https://xxxxxxxx#g' /etc/opkg/distfeeds.conf" >> package/lean/default-settings/files/zzz-default-settings

if [ ! -d package/lean ];then
  mkdir -p package/lean
fi
pushd package/lean

# Add luci-app-diskman
echo "Add luci-app-diskman"
rm -rf ./luci-app-diskman
git clone --depth=1 https://github.com/lisaac/luci-app-diskman
mkdir parted
cp luci-app-diskman/Parted.Makefile parted/Makefile

# Add luci-app-onliner (need luci-app-nlbwmon)
echo "Add luci-app-onliner (need luci-app-nlbwmon)"
git clone --depth=1 https://github.com/rufengsuixing/luci-app-onliner

# Add luci-app-serverchan
echo "Add luci-app-serverchan"
git clone --depth=1 https://github.com/tty228/luci-app-serverchan

#add apps
echo "Clone kenzok8/openwrt-packages"
git clone --depth=1 https://github.com/kenzok8/openwrt-packages
rm -rf ./openwrt-packages/luci-app-jd-dailybonus
rm -rf ./openwrt-packages/luci-app-serverchan
rm -rf ./openwrt-packages/luci-app-ssr-plus
rm -rf ./openwrt-packages/luci-theme-argon_new
rm -rf ./openwrt-packages/naiveproxy
rm -rf ./openwrt-packages/tcping

echo "Clone  kenzok8/small"
git clone --depth=1 https://github.com/kenzok8/small
rm -rf ./small/shadowsocks-rust
rm -rf ./small/shadowsocksr-libev
rm -rf ./small/v2ray-core
rm -rf ./small/v2ray-plugin
rm -rf ./small/xray-core
rm -rf ./small/xray-plugin

#passwall setup
echo "Passwall setup"
svn co https://github.com/roacn/Actions-OpenWrt-Lede/trunk/files/root/usr/share/passwall/rules rules
cp -r ./rules/* ./openwrt-packages/luci-app-passwall/root/usr/share/passwall/rules
#cp -r ./rules/direct_ip ./openwrt-packages/luci-app-passwall/root/usr/share/passwall/rules/direct_ip
#cp -r ./rules/direct_host ./openwrt-packages/luci-app-passwall/root/usr/share/passwall/rules/direct_host
#cp -r ./rules/proxy_host ./openwrt-packages/luci-app-passwall/root/usr/share/passwall/rules/proxy_host

# Add luci-app-ssr-plus
echo "Add  luci-app-ssr-plus"
git clone --depth=1 https://github.com/fw876/helloworld
svn co https://github.com/roacn/Actions-OpenWrt-Lede/trunk/files/root/etc/ssrplus ssrplus
cp -r ./ssrplus/* ./helloworld/luci-app-ssr-plus/root/etc/ssrplus

# 以下为添加主题部分
# Add luci-theme-argon
echo "Add luci-theme-argon"
rm -rf ./luci-theme-argon
git clone --depth=1 -b master https://github.com/jerrykuku/luci-theme-argon

# Add luci-theme-argonne
echo "Add luci-theme-argonne"
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-argonne

# Add luci-app-argonne-config
echo "Add luci-app-argonne-config"
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-argonne-config

# Add luci-theme-atmaterial_new
echo "Add luci-theme-atmaterial_new"
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-atmaterial_new

# Add luci-theme-edge
echo "Add luci-theme-edge"
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-edge

# Add luci-theme-ifit
echo "Add luci-theme-ifit"
svn co  https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-ifit

#add new theme jj
echo "Add new theme jj"
git clone --depth=1 https://github.com/netitgo/luci-theme-jj.git

# Add luci-theme-mcat
echo "Add luci-theme-mcat"
svn co https://github.com/kenzok8/openwrt-packages/openwrt-packages/trunk/luci-theme-mcat

# Add luci-theme-tomato
echo "Add luci-theme-tomato"
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-theme-tomato

popd

echo "diy-part2.sh已执行完毕！"
