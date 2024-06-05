#!/bin/bash

# {{ Add luci-app-diskman
(cd friendlywrt && {
    mkdir -p package/luci-app-diskman
    wget https://raw.githubusercontent.com/lisaac/luci-app-diskman/master/applications/luci-app-diskman/Makefile -O package/luci-app-diskman/Makefile
    mkdir -p package/parted
    wget https://raw.githubusercontent.com/lisaac/luci-app-diskman/master/Parted.Makefile -O package/parted/Makefile
})
cat >> configs/rockchip/01-nanopi <<EOL
CONFIG_PACKAGE_luci-app-diskman=y
CONFIG_PACKAGE_luci-app-diskman_INCLUDE_btrfs_progs=y
CONFIG_PACKAGE_luci-app-diskman_INCLUDE_lsblk=y
CONFIG_PACKAGE_smartmontools=y
EOL
# }}

# {{ Add luci-theme-argon
(cd friendlywrt/package && {
    [ -d luci-theme-argon ] && rm -rf luci-theme-argon
    git clone https://github.com/jerrykuku/luci-theme-argon.git --depth 1 -b master
})
echo "CONFIG_PACKAGE_luci-theme-argon=y" >> configs/rockchip/01-nanopi
sed -i -e 's/function init_theme/function old_init_theme/g' friendlywrt/target/linux/rockchip/armv8/base-files/root/setup.sh
cat > /tmp/appendtext.txt <<EOL
function init_theme() {
    if uci get luci.themes.Argon >/dev/null 2>&1; then
        uci set luci.main.mediaurlbase="/luci-static/argon"
        uci commit luci
    fi
}
EOL
sed -i -e '/boardname=/r /tmp/appendtext.txt' friendlywrt/target/linux/rockchip/armv8/base-files/root/setup.sh
# }}

# {{ Add mosdns
(cd friendlywrt/package && {
    [ -d luci-app-mosdns ] && rm -rf luci-app-mosdns
    git clone https://github.com/sbwml/luci-app-mosdns.git -b v5
})
cat >> configs/rockchip/01-nanopi << EOF
CONFIG_PACKAGE_mosdns=y
EOF
# }}

# {{ Add luci-app-ssr-plus
(cd friendlywrt/package && {
    [ -d helloworld ] && rm -rf helloworld
    git clone https://github.com/fw876/helloworld.git -b main
})
cat >> configs/rockchip/01-nanopi << EOF
CONFIG_DEFAULT_luci-app-ssr-plus=y
CONFIG_PACKAGE_luci-app-ssr-plus=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Rust_Client=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Rust_Server=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Xray=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_ChinaDNS_NG=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Simple_Obfs=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_ShadowsocksR_Libev_Client=y
CONFIG_PACKAGE_luci-i18n-ssr-plus-zh-cn=y
CONFIG_PACKAGE_shadowsocksr-libev-ssr-check=y
CONFIG_PACKAGE_shadowsocksr-libev-ssr-local=y
CONFIG_PACKAGE_shadowsocksr-libev-ssr-redir=y
EOF
# }}

# {{ Add luci-app-adguardhome
(cd friendlywrt/package && {
    [ -d luci-app-adguardhome ] && rm -rf luci-app-adguardhome
    git clone https://github.com/rufengsuixing/luci-app-adguardhome.git -b master
})
cat >> configs/rockchip/01-nanopi << EOF
CONFIG_PACKAGE_luci-app-adguardhome=y
EOF
# }}

# {{ Add luci-app-vlmcsd
(cd friendlywrt/package && {
    [ -d luci-app-vlmcsd ] && rm -rf luci-app-vlmcsd
    git clone https://github.com/DokiDuck/luci-app-vlmcsd.git -b master
})
cat >> configs/rockchip/01-nanopi << EOF
CONFIG_DEFAULT_luci-app-vlmcsd=y
CONFIG_PACKAGE_luci-app-vlmcsd=y
CONFIG_PACKAGE_luci-i18n-vlmcsd-zh-cn=y
CONFIG_PACKAGE_vlmcsd=y
EOF
# }}
