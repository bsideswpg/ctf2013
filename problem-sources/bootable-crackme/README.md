This is a chunk of real-mode MBR code.
It can be copied to the first 512 bytes of a hard disk, and then booted from.
It can also be run from QEMU.

It reads characters from the keyboard and stores them. It then does
some comparisons on the string in a way that makes reverse engineering
less easy.
There are no other obfuscations.

It then prints "Win!" or "Lose!" depending on the string entered.

The only string that will trigger a "Win!" message is: `L3ts_G3t_W3t`
