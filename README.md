# vShell

[vShell] (Virtual Shell) — a successor of [Termux] project which provides an
alternate implementation of the Linux terminal emulator for Android OS.

Unlike the original, this application uses [QEMU] to emulate x86_64 hardware to
run [Alpine Linux] distribution. This approach allows to provide a sane
distribution independent of Android OS, with own kernel and full root access
giving full control over the system. Unlike Termux, vShell does not need to port
software packages to Android OS. As result, there are more packages and their
quality is much higher.

This application is compatible with any Android OS versions beginning from 7.0.
It is not affected by Android security hardening like Termux, see issue about
`execve()`: https://github.com/termux/termux-app/issues/1072.

<p align="center"><img src="./images/screenshot.gif" width="60%"/></p>

Closest alternatives:
- [iSH]: Linux shell terminal for IOS devices. User mode emulation.
- [UserLAnd]: Rootless Linux distribution chroot for Android OS. Uses `proot`.

*[vShell] is a private project even though it is Free and Open Source. It has
been developed specifically for my needs. Considering that Android development
is not my occupation and neither my hobby, do not expect the great UX, elegant
coding solutions and so on. vShell is not newbie friendly and never was
intended to be such. If you are not skilled in Linux systems, you will not have
much success with this application.*

*Remember that I do not provide any kind of mentorship on using the packaged
Linux distribution.*

## Where to download

You can [download] the latest version from the [GitHub Releases] page. There are
multiple APK variants specific to each device architecture. If unsure what to
download, use the `universal` variant.

Check the [LIMITATIONS.md](./LIMITATIONS.md) to learn about functional limits
of this software.

For instructions about building the own copy of application, please check
[BUILDING.md](./BUILDING.md).

*This application is not distributed via Play Store, F-Droid, alternate stores,
Facebook, YouTube and other social media.*

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

Depends on how much of **free** RAM is available on device.

If you want to maximize the available RAM for the VM, you will need to close
all heavy apps before starting vShell. Maximal amount of memory which VM can
allocate is 2 GiB.

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

Ports 22 and 80 are forwarded to random ports on host. Long tap on terminal
screen to see the current port forwardings in context menu.

## Issues and feature requests

Issues: https://github.com/xeffyr/android-vshell/issues

When submitting a request for missing feature, please ensure that it is not
covered by "Limitations" section of this README. I would not implement support
things like KVM, TUN/TAP, custom operating system, multiple console sessions.
Modifications of system configuration will be considered only for important
reasons.

Since [Alpine Linux] project is a third-party project, operating system issues
should be reported to its developers. I would not fix them.

Bundled application user guide can be accessed through "Show help" button in
the context menu (long tap \-\-\> more \-\-\> Show help). However it does not
cover usage of Alpine Linux. If you are seeking for such information, it is
better to visit https://wiki.alpinelinux.org/wiki/Main_Page.

**Don't ask me for mentorship.**

## Resources

- [Alpine Linux]: A lightweight Linux distribution built on Musl libc and
  Busybox.
- [Android Terminal Emulator]: One of the first terminal applications for
  Android OS. Now obsolete.
- [ConnectBot]: The first SSH client for Android OS.
- [Limbo Emulator]: A QEMU port to Android OS. Unlike vShell, this application
  is generic and doesn't come with OS preinstalled.
- [QEMU]: A generic machine emulator and virtualizer.
  *This is a core of the vShell app.*
- [Termux]: Android terminal emulator with package ecosystem.
  *vShell borrowed some UI parts and terminal library from Termux.*

[Alpine Linux]: <https://alpinelinux.org/>
[Android Terminal Emulator]: <https://github.com/jackpal/Android-Terminal-Emulator>
[ConnectBot]: <https://github.com/connectbot/connectbot>
[GitHub Releases]: <https://github.com/xeffyr/android-vshell/releases>
[Limbo Emulator]: <https://github.com/limboemu/limbo>
[QEMU]: <https://qemu.org>
[Termux]: <https://termux.com>
[UserLAnd]: <https://github.com/CypherpunkArmory/UserLAnd>
[author]: <https://github.com/xeffyr>
[download]: <https://github.com/xeffyr/android-vshell/releases/latest>
[iSH]: <https://github.com/ish-app/ish>
[vShell]: <https://github.com/xeffyr/android-vshell>
