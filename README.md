![Image of game](/images/Crowd-game-image.png)

For Linux only.

Download the 'game' file to use.

Make sure that the framebuffer (/dev/fb0) is enabled. If it isn't, follow these instructions to build linux kernel from scratch: https://phoenixnap.com/kb/build-linux-kernel. Then follow these instructions to enable the framebuffer in the kernel config menu: https://www.kernel.org/doc/html/latest/fb/fbcon.html.

When you run the game file, you may get an error saying 'bash: ./game: Permission denied'. To fix this add executable permission to the file owner (which is now you) using the command chmod +x game

Your user will need to be added to the video group

sudo usermod -a -G video username

groups username

You need to switch to TTY3 by pressing Ctrl + Alt + F3 to run this program. To switch back press Ctrl + Alt + F2.

TTY3 doesn't use a windowing system like X11 or Wayland, so you can see the output of the program.

If the application does something weird type in echo $? in the terminal and that will provide the memory address of the instruction where the error occured.

If you want to modify the code and then run it, do git clone https://github.com/uzougochukwu/crowd-simulator

Then in the crowd-simulator folder run the following commands. Replace USER with your username.

nasm -I/home/USER/crowd-simulator/ -felf64 -gdwarf ./src/*.asm -o ./src/game.o

ld ./src/game.o -o game

./game

The error handler logs messages to either /var/log/syslog or /var/log/messages depending on which Linux distro you are using.

Check that one of those files exists.

If it doesn't run the command

systemctl status rsyslog

And you should see the following: Unit rsyslog.service could not be found.

If you don't then you need to investigate that.

If you do then run the following command

systemctl start rsyslog

If you get Failed to start rsyslog.service: Unit rsyslog.service not found.

Then type

which rsyslogd

If you get no rsyslog in

Then it needs to be installed

fedora
sudo dnf install rsyslog 

debian/ubuntu
sudo apt-get install rsyslog

Then go back and type

systemctl start rsyslog

Then check that you have either /var/log/syslog or /var/log/messages

run

logger 'hello2'

then cd /var/log/

then run

sudo cat messages | grep hello2

or

sudo cat syslog | grep hello2

And you should see the hello2 message

This is a video of what the program looks like when it runs: https://youtu.be/YC3ZaMMn42w

The logger command now works, after you run ./game run

sudo cat /var/log/messages | grep "This is a mistake"

or

sudo cat /var/log/syslog | grep "This is a mistake"


And you should see "This is a mistake"

