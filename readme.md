```
___    _    _   _  ___    __    __  ___     _    _  __   _  _   _ __  __  
|   \  | |  | |_| ||   \  |  \  /  ||   \  | |  | ||  \ | || | | |\ \/ /  
|    \ | |_ |  _  ||    \ |   \/   ||    \ | |_ | ||   \| || |_| | /  \  
|_|\__\|___||_| |_||_|\__\|_/\__/|_||____/ |___||_||_/\___||_____|/_/\_\ 
Headstart of context to whoever wants to understand/build an OS.
```



## Prelude
This repository provides required scripts to build a very minimal OS.
```
  [+] build-rootfs.sh    - Create a chroot-able rootfs.
  [-] package-manager.py - Debian-based precompiled binaries
                         - With dependencies.
  [+] resources/         - Help you take off! Where do you proceed next.
                         - Things to try/learn next. Awesome-list.
  [+] toolchain          - musl-libc, gcc, make, ...
```



An operating system may be called "independent", if it is mature enough to 
host a development environment for itself. That requires 3 components:
  -  A Kernel
  -  A commandline
  -  A toolchain (a `libc` implementation, `gcc`, `make`, ...)

`alhamd-linux` tries a different approach to get far away from `systemd`-like 
higher-level abstraction softwares to achieve the simplest & most minimal build 
of an operating system.




## Roadmap
`alhamd-linux` will be considered mature if:
- `hamd` (alhamd-linux package manager) can resolve dependency conflicts. Using Debian prebuilt binaries is completely okay. We cannot use `apt` because it brings `systemd-*`.
- `Xorg` + `dwm`
- `Chromium`
- Be able to do `hamd install ~/Downloads/opera-stable-latest.deb`
