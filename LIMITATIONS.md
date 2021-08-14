# vShell - functional & design limitations

There is a number of limitations implied by application objectives and design
choices which are expected to be final and would not be re-considered in future
application versions. Some of them may interfere with your usage expectations.

When requesting a new feature, ensure its absence reasons are not covered by
this list.

## The only supported operating system is Alpine Linux

*Small, fast & functional. Good choice for the guest OS of machine emulator.*

This does not mean it is not possible to use other operating systems like
Debian. You are free to install whatever you want inside the VM, but do not
ask me how to do this or report that new OS is very slow or does not work.

My personal choice for running software under other systems is Docker.

## Application user interface is very minimal

*Only important & easy to implement things: console, special keys row,
context menu for extra actions, application user guide. My occupation
is not related to Android development, sorry.*

If you need something that is more customizable, please use [Termux] instead.
It can run [Alpine Linux] in [QEMU] as well (recommending to try `proot` -
it's faster).

## Does not use root features

*Do not request KVM, TUN/TAP and other features requiring rooted devices.
I don't root my device and would not suggest rooting for others.*

If you need to use advanced functionality of QEMU, I'm suggesting to use
[Termux] instead. Its QEMU packages should have support of KVM and TUN/TAP.

## Requires a high-end device

*System emulation adds significant computational overhead and execution of
same task in QEMU uses much more energy than running it on host.*

Emulator performance is enough for performing most of tasks, assuming your
host CPU is fast enough. You can even perform fairly heavy tasks like
compiling software. However it is not recommended to perform really heavy
tasks like video processing, unless you have indefinite amount of time for
waiting and want to turn your device into portable hand heater.

See [sysbench](https://github.com/akopytov/sysbench) performance comparison
between [vShell] and Termux PRoot:

<p align="center"><img src="./images/sysbench_results.png" width="90%"/></p>

According to benchmark, vShell is 10 times slower than Linux distribution
inside `proot` (AArch64). However be prepared that actual performance in
certain cases could be lower and may depend on used software or host device.

## No access to host resources

*Don't even try to root your device or dump packets from your Wi-Fi dongle.
This is not possible with vShell.*

I would not leave comments for those who think can elevate privileges by
using [QEMU].

## No graphical output support

*vShell is a "virtual shell", isn't it?*

You can install a VNC server inside, but I do not guarantee that graphics
would be very useful for you due to low performance.

## Only one terminal session

*This limit arises from a fact that vShell doesn't use QEMU as external
program. Instead it is merged with terminal emulator code. It is possible
to implement multiple sessions but will require lot of work.*

Use `tmux` or other multiplexer instead.

## Terminal is attached to QEMU serial line

*Serial lines transfer raw data. They have nothing to do with terminals and
thus do not have fancy features like screen size handshaking.*

Utilities `reset` and `resize` are your best friends when it comes to fixing
console glitches.

## Requires skills in Linux systems administration

*What else you will expect from application providing a VM with Linux
distribution?*

In order to successfully operate a Linux-based system, you need to know how
to work with it. There are a lot of books, articles and blogs about this topic
on the Internet. Begin with basics, set goals and accomplish them. Try online
courses and challenges to keep your skills up.

You can use this application for practice, if you have learned some basics.

I do not provide mentorship. That's right up to you what software to install,
how to use it, etc.

[Alpine Linux]: <https://alpinelinux.org/>
[QEMU]: <https://qemu.org>
[Termux]: <https://termux.com>
[vShell]: <https://github.com/xeffyr/android-vshell>
