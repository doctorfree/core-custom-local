# core-custom-local

## Overview

When a package in the Debian packaging format is installed with some files
in `/usr/local` a subsequent removal of that package will attempt to remove
`/usr/local` if no other package has files installed there. This is because
the Debian packaging system does not include `/usr/local` as a valid standard
supported installation location for Debian packages.

In order to prevent the Debian package management system from attempting to
remove `/usr/local` I created this Meta Package, `core-custom-local`, to serve
as a package with installed files/folders in /usr/local. Install this package
and subsequent removals of packages with files or folders in `/usr/local` will
not attempt to remove `/usr/local`.

## Installation

Download the core-custom-local_&lt;version&gt;.deb from the Releases section
of this repository. Install by executing the command:
```bash
sudo apt install /path/to/core-custom-local_<version>.deb
```
