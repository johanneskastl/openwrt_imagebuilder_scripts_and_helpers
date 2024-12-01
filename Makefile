all : clean container eap245v3 wrt1900acs mikrotik_wap_ac fritzbox_7490 fritzbox_7490_micron

container :
	podman image rm johanneskastl/openwrt-imagebuilder:alpine-latest || true
	podman build -t johanneskastl/openwrt-imagebuilder:alpine-latest .

eap245v3 :
	./download_and_build.sh env_EAP245v3

wrt1900acs :
	./download_and_build.sh env_WRT1900ACS

mikrotik_wap_ac :
	./download_and_build.sh env_Mikrotik_wAP_AC

fritzbox_7490 :
	./download_and_build.sh env_FritzBox_7490

fritzbox_7490_micron :
	./download_and_build.sh env_FritzBox_7490_Micron

clean : clean_eap245v3 clean_wrt1900acs clean_mikrotik_wap_ac clean_fritzbox_7490 clean_fritzbox_7490_micron

clean_eap245v3 :
	rm -vrf sha256sums_eap245v3 openwrt-imagebuilder-*ath79-generic.Linux-x86_64.tar.xz openwrt-imagebuilder*ath79-generic.Linux-x86_64/

clean_wrt1900acs :
	rm -vrf sha256sums_wrt1900acs openwrt-imagebuilder-*mvebu-cortexa9.Linux-x86_64.tar.xz openwrt-imagebuilder*mvebu-cortexa9.Linux-x86_64/

clean_mikrotik_wap_ac :
	rm -vrf sha256sums_Mikrotik_wAP_AC openwrt-imagebuilder*ipq40xx-mikrotik.Linux-x86_64.tar.xz openwrt-imagebuilder*ipq40xx-mikrotik.Linux-x86_64/

clean_fritzbox_7490 :
	rm -vrf sha256sums_FritzBox_7490 openwrt-imagebuilder*lantiq-xrx200.Linux-x86_64.tar.* openwrt-imagebuilder*lantiq-xrx200.Linux-x86_64/

clean_fritzbox_7490_micron :
	rm -vrf sha256sums_FritzBox_7490_Micron openwrt-imagebuilder*lantiq-xrx200.Linux-x86_64.tar.* openwrt-imagebuilder*lantiq-xrx200.Linux-x86_64/
