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

LIB_BASE_NAME = aws

DOC_FILES =

SHARED_PUBLIC_H_DIRS = src/iot-embeddedc/external_libs/mbedTLS/include
SHARED_PUBLIC_H_DIRS += src/iot-embeddedc/include

SHARED_PUBLIC_H_FILES = src/iot-embeddedc/external_libs/jsmn/*.h
SHARED_PUBLIC_H_FILES += src/iot-embeddedc/platform/vxworks/common/*.h
SHARED_PUBLIC_H_FILES += src/iot-embeddedc/platform/vxworks/mbedtls/*.h

KERNEL_PUBLIC_H_FILES += src/iot-embeddedc/platform/vxworks/libc/inttypes.h

BUILD_DIRS = src/iot-embeddedc/external_libs/mbedTLS/library
BUILD_DIRS += src/iot-embeddedc/external_libs/jsmn
BUILD_DIRS += src/iot-embeddedc/platform/vxworks/common
BUILD_DIRS += src/iot-embeddedc/platform/vxworks/mbedtls
 
BUILD_USER_DIRS = src/iot-embeddedc/external_libs/mbedTLS/library
BUILD_USER_DIRS += src/iot-embeddedc/external_libs/jsmn
BUILD_USER_DIRS += src/iot-embeddedc/platform/vxworks/common
BUILD_USER_DIRS += src/iot-embeddedc/platform/vxworks/mbedtls

POST_NOBUILD_CDFDIRS = cdf

POSTBUILD_RTP_DIRS = src/iot-embeddedc/samples/vxworks/subscribe_publish_sample
POSTBUILD_RTP_DIRS += src/iot-embeddedc/samples/vxworks/shadow_sample

ifeq ($(SPACE), user)
include $(WIND_USR_MK)/rules.layers.mk
else
include $(WIND_KRNL_MK)/rules.layers.mk
endif

