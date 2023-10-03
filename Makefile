all : clean container eap245v3 wrt1900acs mikrotik_wap_ac

container :
	podman build -t johanneskastl/openwrt-imagebuilder:alpine-latest .

eap245v3 :
	./download_and_build_eap245v3.sh

wrt1900acs :
	./download_and_build_WRT1900ACS.sh

mikrotik_wap_ac :
	./download_and_build.sh env_Mikrotik_wAP_AC

clean : clean_eap245v3 clean_wrt1900acs clean_mikrotik_wap_ac

clean_eap245v3 :
	rm -vrf sha256sums_eap245v3 openwrt-imagebuilder-22.03.5-ath79-generic.Linux-x86_64.tar.xz openwrt-imagebuilder-22.03.5-ath79-generic.Linux-x86_64/

clean_wrt1900acs :
	rm -vrf sha256sums_wrt1900acs openwrt-imagebuilder-22.03.5-mvebu-cortexa9.Linux-x86_64.tar.xz openwrt-imagebuilder-22.03.5-mvebu-cortexa9.Linux-x86_64/
