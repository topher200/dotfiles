#!/bin/bash

# Must be run as root for ydotool to access /dev/uinput
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   # exit 1
fi

# Setup non-blocking input
stty -echo -icanon time 0 min 0

# Trap to restore terminal on exit
cleanup() {
  stty sane
  echo -e "\nExiting..."
  exit 0
}
trap cleanup INT TERM

echo "Clicking loop started. Press 'q' to quit."

ydo=/home/topher/Downloads/ydotool-release-ubuntu-latest
YDOTOOL_SOCKET=/tmp/.ydotool_socket

while true; do
  # Read 1 char with no wait (non-blocking)
  key=$(dd if=/dev/tty bs=1 count=1 2>/dev/null)

  if [[ "$key" == "q" ]]; then
    cleanup
  fi

  # "Home"
  "$ydo" mousemove --absolute -x 720 -y 420
  "$ydo" click 0xC0
  sleep 2

  # "Make an Appointment"
  "$ydo" mousemove --absolute -x 1000 -y 1000
  "$ydo" click 0xC0
  sleep 2

  # "Drivers License -- first time"
  "$ydo" mousemove --absolute -x 1000 -y 1000
  "$ydo" click 0xC0
  sleep 10
done

