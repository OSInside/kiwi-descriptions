#!/bin/bash

# get rid of some locales
pushd /usr/share/locale
ls -1 | grep -v en_US | xargs rm -rf
popd

# no docs needed in final result
rm -rf /usr/share/man
rm -rf /usr/share/doc/*

# lot's of yum caches which we don't need
rm -rf /var/cache/yum

# maybe needed maybe not
rm -rf /usr/share/licenses
