Just run it under QEMU or run it raw on an x86 computer. It switches to video
mode ("mode 13h") and displays scrolling arrows with the key overlaid.

Uses completely weird "font" rendering and stuff. Should be hard to reverse, easy
to solve.

Purpose: When all you have is IDA, everything looks statically reversible :)

![Screenshot of this problem in QEMU](/screenshot.png?raw=true "QEMU")
