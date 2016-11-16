DEFAULT_HOST := i686-pc-linux-gnu
HOST := $(DEFAULT_HOST)
HOSTARCH := i386

AR := $(HOST)-ar
AS := $(HOST)-as
CC := $(HOST)-gcc

PREFIX := /usr
EXEC_PREFIX := /usr
BOOTDIR := /boot
LIBDIR := $(EXEC_PREFIX)/lib
INCLUDEDIR := $(PREFIX)/include

CFLAGS := -O2 -g

ROOTDIR := $(shell pwd)
SYSROOT := $(ROOTDIR)/sysroot
DESTDIR := $(SYSROOT)

CC := $(CC) --sysroot=$(SYSROOT) -isystem=$(INCLUDEDIR)

PROJECTS := libc kernel
SYSTEM_HEADERS_PROJECRS := libc kernel

export

.PHONY: clean build install-headers qemu

qemu: LinOS.iso
	qemu-system-$(HOSTARCH) -cdrom LinOS.iso

build: install-headers
	$(MAKE) -C libc install
	$(MAKE) -C kernel install
	mkdir -p isodir
	mkdir -p isodir/boot
	mkdir -p isodir/boot/grub
	cp sysroot/boot/LinOS.kernel isodir/boot/LinOS.kernel
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o LinOS.iso isodir

install-headers:
	mkdir -p $(SYSROOT)
	$(MAKE) -C libc install-headers
	$(MAKE) -C kernel install-headers

clean:
	$(MAKE) -C libc clean
	$(MAKE) -C kernel clean
	rm -rf sysroot isodir LinOS.iso
