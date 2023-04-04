# Creating a custom grub BOOTX64.EFI for the esp

This project should help creating a minimal efi grub executable as an initial bootloader.
After decrypting the actual partition to boot, grub will chainload the next grub efi executable from the now decrypted /boot.

Bonus: A typo in the password simply asks for it again, instead of showing the (more or less useless) grub shell.

## Dependencies

Aside from `bash`, `sudo`, `df`, `sed`, and `tar`, `./configure` checks for needed commands and files:

- `grub` for the commands `grub-probe` and `grub-mkimage`
- `gettext` for the `envsubst` command
- `qemu-system-x86` for the `qemu-system-x86_64` command for testing purposes
  - `qemu-desktop` to get proper visual output
- `edk2-ovmf` for uefi firmware to test in qemu

## Usage

```sh
# to check dependencies and configure the .env file
./configure > .env
# to check if everything looks fine
cat .env
# to set the environment for the following commands
source .env

# to build the grub.cfg and embedd it into a BOOTX64.EFI file
./build
```

To test if the resulting file actually works, run `./test`.
It should open a qemu window and showing the usual password prompt.
Check with `<enter>`, that it asks again for your password without throwing you into a prompt.
After entering your password, it should show you the actual grub menu.
If it does, I would assume this test to work.
You could check the terminal (press `C`) and then `TAB` if all relevant commands are there (e.g. linux).

**This uses your actual encrypted drive. I'm not sure if it is safe to boot from that, so make sure to cancel by going to the terminal that invoked `./test` and running `Ctrl+C`!**

You can now copy the BOOTX64.EFI file into your esp partition. Make sure to make a backup of your previous file. 

## Troubleshooting

The grub modules defined in `build` are suitable for my setup. They may not be enough on your machine.
E.g. if you have the encrypted /boot on a btrfs or zfs filesystem, add those modules to the grub-mkimage command in `build` as well.


## ToDo

- add an `install` command to mount esp, backup the old efi file, copy the new one, and set `efibootmgr` ?
- detect needed filesystem modules and only load the necessary ones
- is it possible to pack modules into the memdisk and compress them?
