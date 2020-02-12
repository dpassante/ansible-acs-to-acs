#!/bin/bash

ansible_path=$(ansible --version |sed -n "s@.*ansible python module location = \(/usr/[a-z/]*lib/python[23].[0-9]/dist-packages/ansible\)@\1@p")
patch_file=$(readlink -f patch/ansible_cs_network_tags.patch)

pushd ${ansible_path}
patch -i ${patch_file} -p1
popd
