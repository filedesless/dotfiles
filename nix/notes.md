# update nix channel

	nix-channel --update

# garbage collection

	nix-collect-garbage

# disable binary cache in nix

	nix-build --option substitute false

# check out this guy

https://www.reddit.com/r/NixOS/comments/9aa08b/whats_your_configurationnix_like/

# nmcli wireless

from: https://blog.khmersite.net/2018/08/connect-to-a-wpa2-enterprise-connection-using-nmcli/

	# nmcli con add type wifi ifname wlp3s0 con-name work-wifi ssid work-ssid
	# nmcli con edit id work-wifi
	nmcli> set ipv4.method auto
	nmcli> set 802-1x.eap peap
	nmcli> set 802-1x.phase2-auth mschapv2
	nmcli> set 802-1x.identity myusername
	nmcli> set 802-1x.password mypassword
	nmcli> set wifi-sec.key-mgmt wpa-eap
	nmcli> save
	nmcli> activate
