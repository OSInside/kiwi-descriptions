#!/bin/bash

set -ex

systemctl enable add_device@vdb
systemctl enable resize_volume@LVRoot
