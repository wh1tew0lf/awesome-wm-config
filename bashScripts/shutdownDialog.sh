#!/bin/sh

ACTION=`zenity --width=90 --height=200 --list --text="Select logout action" --title="Logout" --column "Action" Shutdown Reboot LockScreen`

if [ -n "${ACTION}" ];then
  case $ACTION in
  Shutdown)
    zenity --question --text "Are you sure you want to halt?" && gksudo halt
    ## or via ConsoleKit
    # dbus-send --system --dest=org.freedesktop.ConsoleKit.Manager \
    # /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop
    ;;
  Reboot)
    zenity --question --text "Are you sure you want to reboot?" && gksudo reboot
    ## Or via ConsoleKit
    # dbus-send --system --dest=org.freedesktop.ConsoleKit.Manager \
    # /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Restart
    ;;
  LockScreen)
    slock
    # Or gnome-screensaver-command -l
    ;;
  esac
fi
