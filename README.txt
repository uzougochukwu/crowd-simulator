For Linux only.

Download the 'game' file to use.

Make sure that the framebuffer (/dev/fb0) is enabled. If it isn't, follow these instructions to build linux kernel from scratch: https://phoenixnap.com/kb/build-linux-kernel. Then follow these instructions to enable the framebuffer in the kernel config menu: https://www.kernel.org/doc/html/latest/fb/fbcon.html.

When you run the game file, you may get an error saying 'bash: ./game: Permission denied'. To fix this add executable permission to the file owner (which is now you) using the command chmod +x game

You may need to switch to TTY mode by pressing Ctrl + Alt + F3 to run this program. To switch back press Ctrl + Alt + F2.
