# rufil
### Simple Ruby file manager for UNIX-Like systems.
***
# How to use
## Basics
You can start the program using the ``rufil`` command, if you want to open a specific directory you can use ``rufil /path``.

To get a list of all commands, you can run the ``h`` command.
```
Command (h for help): h
```
## Installation
***This guide is designed with GNU/Linux in mind.***

You can easily install & set up rufil using make.

#### Installing Make
##### On Debian / Debian based distros you run:
```
apt-get install make
```
##### On Arch / Arch based distros you run:
```
pacman -S make
```
#### Installing rufil
Now that make is installed, you need to run one of these commands according to your linux distribution to install dependencies:
```
make install-deps-apt # Debian
make install-deps-pac # Arch
make install-deps-emrg # Gentoo
```
Then you run this to install rufil:
```
make install
```
