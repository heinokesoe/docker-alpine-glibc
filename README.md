Alpine GNU C library (glibc) Docker image
=========================================

This image is based on Alpine Linux image, which is only a 5MB image, and contains glibc to enable
proprietary projects compiled against glibc (e.g. OracleJDK, Anaconda) work on Alpine.

This image includes some quirks to make [glibc](https://www.gnu.org/software/libc/) work side by
side with musl libc (default in Alpine Linux). glibc packages for Alpine Linux are prepared by
[Sasha Gerrand](https://github.com/sgerrand) and the releases are published in
[sgerrand/alpine-pkg-glibc](https://github.com/sgerrand/alpine-pkg-glibc) github repo.

If you need to update your libc library cache, use `/usr/glibc-compat/sbin/ldconfig` instead of the usual `/sbin/ldconfig`. You can also use the `LD_LIBRARY_PATH` as on standard libc-based distributions.

Usage Example
-------------

This image is intended to be a base image for your projects, so you may use it like this:

```Dockerfile
FROM heinokesoe/alpine-glibc

COPY ./my_app /usr/local/bin/my_app
```

```sh
$ docker build -t my_app .
```

> **_NOTE:_** In glibc version 2.35-r0, some app will show errors like this as it is missing lib64 symlink.

```sh
# nvim
Error relocating /lib/ld-linux-x86-64.so.2: unsupported relocation type 37
Error relocating /root/bin/nvim: backtrace: symbol not found
Error relocating /root/bin/nvim: gnu_get_libc_version: symbol not found
Error relocating /root/bin/nvim: __strncpy_chk: symbol not found
Error relocating /root/bin/nvim: __fprintf_chk: symbol not found
Error relocating /root/bin/nvim: __pread_chk: symbol not found
Error relocating /root/bin/nvim: __register_atfork: symbol not found
Error relocating /root/bin/nvim: __memcpy_chk: symbol not found
Error relocating /root/bin/nvim: __vsnprintf_chk: symbol not found
Error relocating /root/bin/nvim: __strcat_chk: symbol not found
Error relocating /root/bin/nvim: __read_chk: symbol not found
Error relocating /root/bin/nvim: __strcpy_chk: symbol not found
Error relocating /root/bin/nvim: __memset_chk: symbol not found
Error relocating /root/bin/nvim: __fread_chk: symbol not found
Error relocating /root/bin/nvim: __sprintf_chk: symbol not found
Error relocating /root/bin/nvim: __realpath_chk: symbol not found
Error relocating /root/bin/nvim: __snprintf_chk: symbol not found
Error relocating /root/bin/nvim: __memmove_chk: symbol not found
Error relocating /root/bin/nvim: __open_2: symbol not found
Error relocating /root/bin/nvim: _nl_msg_cat_cntr: symbol not found
```

If it happens, you will need to run this.
```sh
# rm /lib64/ld-linux-x86-64.so.2
# ln -s /usr/glibc-compat/lib/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
```
