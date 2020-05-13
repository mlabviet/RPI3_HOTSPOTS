#! /bin/bash
if [ -z "$1" ] && [ -z "$2" ]
# No ssid, no pass
then
  echo "Connect using current information"
  sudo rm -rf /etc/network/interfaces
  sudo cp /etc/network/interfaces.sta /etc/network/interfaces
else
# have ssid, no pass
  if !([ -z "$1"  ]) && [ -z "$2" ] ; then
	echo "Connecting to Open SSID $1"
	a="\"$1\""
	b="NONE"
	sudo sed -i -e "s/\(ssid=\).*/\1$a/" /etc/wpa_supplicant/wpa_supplicant.conf
	sudo sed -i -e "s/\(key_mgmt=\).*/\1$b/" /etc/wpa_supplicant/wpa_supplicant.conf
  else
#have ssid. have pass
	echo "Connecting to ssid:$1, pass:$2"
	a="\"$1\""
	b="\"$2\""
	c="WPA-PSK"
	sudo sed -i -e "s/\(ssid=\).*/\1$a/" /etc/wpa_supplicant/wpa_supplicant.conf
	sudo sed -i -e "s/\(psk=\).*/\1$b/" /etc/wpa_supplicant/wpa_supplicant.conf
	sudo sed -i -e "s/\(key_mgmt=\).*/\1$c/" /etc/wpa_supplicant/wpa_supplicant.conf
  fi
fi

sudo /etc/init.d/hostapd stop &
sudo /etc/init.d/udhcpd stop &
# sudo /etc/init.d/dnsmasq stop &&
sudo /etc/init.d/dhcpcd stop &

sudo ip addr flush dev wlan0
sudo rm -rf /etc/network/interfaces
sudo cp /etc/network/interfaces.sta /etc/network/interfaces
sudo /etc/init.d/dhcpcd start
