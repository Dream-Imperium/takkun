# takkun - a screenlocker for the **extremely** paranoid

This is a screenlocker with a lot of security features.

It is configured via `config.h` then recompiling, similar to iwakuramarie's [crow](https://github.com/iwakuramarie/crow). 
When it is active, the screen is dimmed, but if there is no compositor running, it will be black.

## Features
- Custom Password: You can provide a custom password so you don't have to enter
  your user password on the X server. Simply create a ~/.takkun_passwd file with
  your separate password in it.

- Alarms: A siren will play if a user enters an incorrect password. It must
  reside in ~/takkun.

- Automatic Shutdown: Your machine will immediately shutdown if:

  1. The wrong password is entered more than 5 times.

  2. ALT/CTRL/F1-F13 is pressed to switch VTs or to try to kill the X server.
     Also, if ALT+SYSRQ is attempted to be used.

  - Automatic shutdown requires a sudoers option to be set in /etc/sudoers:

    - systemd: `[username] [hostname] =NOPASSWD: /usr/bin/systemctl poweroff`
    - sysvinit: `[username] [hostname] =NOPASSWD: /usr/bin/shutdown -h now`

    You must change [username] and [hostname] to your username and the hostname
    of the machine.

    NOTE: It is wise to combine this feature with a BIOS password as well as an
    encrypted home+swap partition. Once your machine is powered off, your data
    is no longer accessible in any manner.

- GRSecurity BadUSB Prevention: If you have GRSecurity patched onto and enabled
  in your kernel, when takkun is started, all new USB devices will be disabled.
  This requires that the kernel.grsecurity.grsec_lock sysctl option be set to 0,
  which is a security risk to an attacker with local access. If you enable
  STRICT\_USBOFF when takkun comes on, kernel.grsecurity.grsec_lock will be set
  to 1 and new USB devices will denied until you reboot.

  You will need to have this line in your /etc/sysctl.d/grsec.conf

        kernel.grsecurity.grsec_lock = 0

  and it also requires similar permissions to Automatic Shutdown in
  /etc/sudoers.

    - `[username] [hostname] =NOPASSWD: /sbin/sysctl kernel.grsecurity.deny_new_usb=1`
    - `[username] [hostname] =NOPASSWD: /sbin/sysctl kernel.grsecurity.deny_new_usb=0`

- Webcam Support (requires ffmpeg): This will take a webcam shot of whoever may
  be tampering with your machine before poweroff. The shot will normally be stored as ~/takkun.png/.jpg

- Twilio Support: You will receive an SMS to your phone when someone inputs a
  wrong password or pressed ALT/CTRL/F1-13/SYSRQ. See twilio_example.h to create a
  twilio.h file. You will need a twilio account to set this up.

  These SMS's can optionally be MMS's containing a webcam shot of whoever is
  potentially tampering with your machine.

- Disabling alt+sysrq and ctrl+alt+backspace before shutting down: This
  prevents an attacker from killing the screenlock quickly before the shutdown.

  - This requires a sudoers option to be set in /etc/sudoers:

    - `[username] [hostname] =NOPASSWD: /usr/bin/tee /proc/sys/kernel/sysrq`

    You must change [username] and [hostname] to your username and the hostname
    of the machine.

- To ensure the OOM-killer is disabled, sudo can be used internally. This
  requires another sudoers option:

  - `[username] [hostname] =NOPASSWD: /usr/bin/tee /proc/[0-9][0-9]*/oom_score_adj`

  However, this is not recommended as now any process can modify the oom_score
  for any other process.

- Transparent Lock Screen

  - The lock screen is an ARGB window. The screen will dim on lock (or turn
    black with no compositor).

## Requirements

In order to build takkun you need the Xlib header files.

- Potential runtime deps: sudo, ffmpeg, setxkbmap, curl, aplay
- Other optional requirements: a twilio account, an imgur account

## Installation

Edit config.mk to match your local setup (takkun is installed into
the /usr/local namespace by default).

Afterwards enter the following command to build and install takkun
(if necessary as root):

``` bash
$ make clean install
```

## Running takkun

Simply invoke the `takkun` command. To get out of it, enter your password.