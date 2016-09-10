#!/bin/bash

# Copyright (c) 2016, Wind River Systems, Inc.
#
# Redistribution and use in source and binary forms, with or without modification, are
# permitted provided that the following conditions are met:
#
# 1) Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
#
# 2) Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation and/or
# other materials provided with the distribution.
#
# 3) Neither the name of Wind River Systems nor the names of its contributors may be
# used to endorse or promote products derived from this software without specific
# prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
# USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

echo "Installing AWS IoT device SDK for C..."

INSTALLDIR=$WIND_BASE/pkgs/net/cloud/aws/src
cd $INSTALLDIR
if [ -d "$INSTALLDIR/iot-embeddedc" ];then
    rm iot-embeddedc/ -rf
fi

git clone -b master https://github.com/aws/aws-iot-device-sdk-embedded-C.git iot-embeddedc
sleep 0.5

cd iot-embeddedc/
git reset --hard 44feb4e86e5d72e212335fa8382c543368a474dd

echo "Download and install mbed TLS..."
cd external_libs
curl -O https://codeload.github.com/ARMmbed/mbedtls/zip/mbedtls-2.1.1
unzip -q mbedtls-2.1.1
rm mbedtls-2.1.1
rm -rf mbedTLS
mv mbedtls-mbedtls-2.1.1 mbedTLS

cd ..
echo "Applying patches to AWS IoT device SDK for C..."
git apply --whitespace=fix ../patch/aws-sdk-vxworks.patch

echo "All done..."
