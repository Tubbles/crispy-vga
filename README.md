# crispy-vga
Small VGA implementation on Lattice MachXO3 Starter Kit

## Note
Sometimes the IDE does not want to recognize the target dev kit, but we can use the commandline utility instead

Edit ```/usr/local/diamond/3.11_x64/bin/lin64/pgrcmd``` to instead say ```bindir="$(realpath "$(dirname $0)")"``` on line 33 and then run it

Use the bitstream file to program to the SRAM directly, and the JEDEC file to program to flash
