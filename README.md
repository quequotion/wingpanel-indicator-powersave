# Wingpanel Powersave indicator
wingpanel-indicator-powersave is a user-discretion power management utility, serving as a front-end to [throttlectl](https://github.com/quequotion/pantheon-qq/tree/master/throttlectl), a command-line user-discretion power management utility written in bash.

---

#### Indicator (shows current CPU freqency)
![Screenshot](data/screenshot1.png)
#### Popover (provides power option toggles)
![Screenshot](data/screenshot2.png)

## Building and Installation

### For Debian and derivatives (Ubuntu, elementary OS, etc):

#### Preinstall the following dependencies:
* libgranite-dev
* libpolkit-gobject-1-dev
* libglib2.0-dev
* libgtk-3-dev
* libwingpanel-dev
* policykit-1
* meson
* valac

#### Build and install
##### Frontend (wingpanel-indicator-powersave)
    git clone https://github.com/quequotion/wingpanel-indicator-powersave.git
    cd wingpanel-indicator-powersave/
    meson build --prefix=/usr
    ninja -C build
    sudo ninja -C build install
##### Backend (throttlectl)
    curl https://raw.githubusercontent.com/quequotion/pantheon-qq/master/throttlectl/throttlectl -o throttlectl
    sudo install -Dm755 {,/usr/bin/}throttlectl
    curl https://raw.githubusercontent.com/quequotion/pantheon-qq/master/throttlectl/performance -o performance
    install -Dm644 {,/etc/throttle.d/}performance
    curl https://raw.githubusercontent.com/quequotion/pantheon-qq/master/throttlectl/powersave -o powersave
    install -Dm644 {,/etc/throttle.d/}powersave
    curl https://raw.githubusercontent.com/quequotion/pantheon-qq/master/throttlectl/throttle-cut.service -o throttle-cut.service
    install -Dm644 {,/etc/systemd/system/}throttle-cut.service

### For Archlinux and derivatives (Manjaro, Artix, etc)

A package is available in the AUR: [wingpanel-indicator-powersave-git](https://aur.archlinux.org/wingpanel-indicator-powersave-git).See the comments there for instructions on building it (without an AUR helper).
