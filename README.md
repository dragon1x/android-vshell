# vShell

vShell (Virtual Shell) — a successor of [Termux](https://termux.com) project
which provides an alternate implementation of the Linux environment. Unlike
the original, this application uses [QEMU](https://www.qemu.org/) to emulate
x86_64 hardware to run [Alpine Linux](https://alpinelinux.org/) distribution.
This approach allows to provide a sane distribution independent of Android OS,
with own kernel and full root access (within VM only!) to manipulate the
system. There much more packages available with higher quality because there
no need to maintain custom package ports.

This application is expected to be compatible with any Android OS beginning
from version 7.0 and is not affected by SELinux `execve()` issue like Termux:
https://github.com/termux/termux-app/issues/1072.

Prebuilt APK files you can find attached in the "Releases" section on
[GitHub](https://github.com/xeffyr/android-vshell/releases). I do not publish
them on any of application stores. If you want to build application yourself,
please check [BUILDING.md](./BUILDING.md).

**Disclaimer**: neither vShell application nor its author is affiliated with
the [Alpine Linux](https://alpinelinux.org/) project. Operating system is provided
as-is and vShell author is not responsible about bugs in the software packages.

<p align="center"><img src="./images/screenshot.gif" width="50%"/></p>

Closest alternatives to this application:
- [iSH](https://github.com/ish-app/ish): for IOS only. User-mode emulation.
- [Termux](https://github.com/termux/termux-app): Android terminal emulator
  with packages.
- [UserLAnd](https://github.com/CypherpunkArmory/UserLAnd): Android OS only.
  Emulates a Linux chroot environment by using `proot`.

## Limitations

There some absolute limits implied by application design. Some of them you may
not like and they will not be re-considered.

- Application user interface is very minimal.

  *Only important & easy to implement things: console, special keys row, 
  context menu for extra actions, application user guide.*

  If you need more, please use [Termux](https://termux.com) instead. It can
  run Alpine Linux under QEMU as well.

- Application is brought by a non-root user to non-root users.

  *Do not request KVM, TUN/TAP and other features requiring rooted devices.
  I don't root my device and would not suggest rooting for others.*

- Requires a high-end device with good CPU, amount of RAM and battery.

  *Because this is a system emulator, there is a big performance difference
  between host and emulated VM.*

  See [sysbench](https://github.com/akopytov/sysbench) performance comparison
  between vShell and Termux PRoot:

  <p align="center"><img src="./images/sysbench_results.png" width="90%"/></p>

  Apparently vShell is 10 times slower than Linux distribution inside `proot`.
  Likely that in certain cases performance penalty could be bigger.

- Runtime environment is isolated from host OS and hardware.

  *Don't even try to root your device or dump packets from your Wi-Fi dongle.
  This is not possible with vShell.*

  This also means you cannot control application state from the VM.

- No graphics.

  *vShell is a "virtual shell", isn't it?*

  You can install a VNC server inside, but I do not guarantee that graphics
  would be very useful for you due to low performance.

- Only one terminal session.

  *This limit arises from a fact that vShell doesn't use QEMU as external
  program. Instead it is merged with terminal emulator code. It is possible
  to implement multiple sessions but will require lot of work.*

  Use `tmux` or other multiplexer instead.

- Requires skills in shell scripting and Linux system administering.

  *What else you will expect from application providing a VM with Linux
  distribution?*

  If you want use vShell, then you will want to learn how to use Linux
  distributions. There lots of books and articles about this on the Internet,
  do not ask me for mentorship — I will ignore such requests.

  Also: do not ask me how to install Kali or Parrot OS into vShell.
  Remembering that you need to learn shell scripting and Linux system
  administeration first, right?

## Properties of emulated VM

Overview of used QEMU configuration.

Note that you cannot change configuration from the application itself. If you
want to adjust QEMU settings, you will need to create your own vShell build.

**CPU:**

1-core x86 64-bit, with all features enabled.

Having multiple emulated cores there is pointless. They will be executed within
the same QEMU thread and as result there would not be any performance benefits.
Though if this will be implemented, e.g. unstable MTTCG will be enabled, this
will have serious impact on battery drain. So 1 core is the optimal value.

**RAM:**

32% of host memory. Additionally there will be allocated 8% for the TCG buffers.

So vShell will use up to 40% of memory available on your device which should be
a safe value in nearly all cases. If you decide to run something heavy in a
parallel, you may want to save your data and shutdown vShell.

**HDD:**

64 GB dynamic QCOW2 image.

Default operating system installation is diskless, i.e. everything is stored in
RAM except data from HDD partitions. There is a 4 GB partition for user data,
like /home and /root user directories and package cache. When made some changes
to system, do not forget to use `lbu` to save them on disk.

Since partition is bootable, you can re-install Alpine Linux or other operating
system on it, if do not want to use diskless distribution variant.

**Host storage:**

Device shared storage is mounted as `/media/host` via 9P file system mounted
with tag `host_storage`.

This is handled by `/etc/fstab`.

**Network:**

Only user-mode networking via SLiRP is supported.

Default DNS in `/etc/resolv.conf`:
```
# Google DNS which should work for everyone.
nameserver 8.8.8.8

# Fallback QEMU DNS resolver. Uses 1.1.1.1 CloudFlare DNS as upstream.
nameserver 10.0.2.3
```

## Issues and feature requests

Issues: https://github.com/xeffyr/android-vshell/issues

Questions and discussions: https://github.com/xeffyr/android-vshell/discussions

When submitting a request for missing feature, please ensure that it is not
covered by "Limits" section of this README. So don't request KVM, TUN/TAP,
multiple application sessions, custom operating systems, etc.

## Resources

- [Termux](https://github.com/termux): Android terminal emulator with package ecosystem. *vShell borrowed some UI parts and terminal library from Termux.*
- [Android Terminal Emulator](https://github.com/jackpal/Android-Terminal-Emulator):
  The first terminal app for Android OS. Deprecated.
- [QEMU](https://qemu.org): A generic machine emulator and virtualizer.
- [Alpine Linux](https://alpinelinux.org/): A lightweight Linux distribution built
  on Musl libc and Busybox.
