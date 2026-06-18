function reload-bluetooth --description "reload Linux Bluetooth kernel modules"
    sudo rmmod btusb
    sudo rmmod btintel
    sudo modprobe btusb
    sudo modprobe btintel
end
