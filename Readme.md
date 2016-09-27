# ##########################################################
#
# VxWorks® 7 Client for AWS IoT Device SDK
# User Guide
#
# ##########################################################

## Overview

This README page provides a quick summary of how to build and run the Amazon Web Services (AWS) Internet of Things (IoT) device SDK for C that resides in VxWorks 7 on your device. The SDK is an embedded C client library for interacting with the AWS IoT platform. This client library is not provided in VxWorks 7 RPM packages or on the VxWorks 7 product DVDs. You need to manually install this library on VxWorks 7.

## Prerequisites

Before installing the SDK prepare the development environment.  
1. Install git and ensure it operates from a command line.  
2. Bash is required for Unix, for Windows use Git Bash.  
3. Ensure the VxWorks 7 DVD is installed.  
4. Ensure the AWS IoT device SDK for C source code is available from the following location:

        'https://github.com/aws/aws-iot-device-sdk-embedded-C.git'

## Installing the SDK

1. Download the VxWorks 7 AWS IoT SDK layer from the following location:

        'https://github.com/Wind-River/vxworks7-aws-iot-sdk.git'

2. Confirm the layer is present in your VxWorks 7 installation.
3. Download the AWS IoT device SDK for C and the the mbed TLS. 
4. Apply any patches required to make it suitable for building with VxWorks 7. 

  To download and patch the SDK you must run the setup.sh script found in the layer's src directory. 
  Note that setup.sh will download the AWS IoT devic SDK for C from the github site.

5. Download the AWS layer into VxWorks 7.  

        cd $WIND_BASE/pkgs/net/  
        mkdir cloud  
        cd cloud  
        git clone https://github.com/Wind-River/vxworks7-aws-iot-sdk aws

6. Run the setup script.

        cd $WIND_BASE/pkgs/net/cloud/aws/src 
        ./setup.sh 

## Creating the VSB and VIP Using WrTool

Create the VxWorks 7 VxWorks source build (VSB) and VxWorks image project (VIP) using either the Wind River Workbench environment or the command line tool WrTool. This procedure uses the fsl_imx6 board support package (BSP) as an example.  

1. Set the environment variable and change the directory.

        export WIND_WRTOOL_WORKSPACE=$HOME/WindRiver/workspace   
        cd $WIND_WRTOOL_WORKSPACE

2. Configure the connection parameters. 
    
  To create a connection to a registered Thing, set the parameters in the file samples/vxworks/subscribe_publish_s/aws_iot_config.h. For example, add the following sample code based on your account, Thing and new certificate:   

        #define AWS_IOT_MQTT_HOST              "" ///< Customer specific MQTT HOST. The same will be used for Thing Shadow
        #define AWS_IOT_MQTT_PORT              8883 ///< default port for MQTT/S
        #define AWS_IOT_MQTT_CLIENT_ID         "c-sdk-client-id" ///< MQTT client ID should be unique for every device
        #define AWS_IOT_MY_THING_NAME          "AWS-IoT-C-SDK" ///< Thing Name of the Shadow this device is associated with
        #define AWS_IOT_ROOT_CA_FILENAME       "rootCA.crt" ///< Root CA file name
        #define AWS_IOT_CERTIFICATE_FILENAME   "cert.pem" ///< device signed certificate file name
        #define AWS_IOT_PRIVATE_KEY_FILENAME   "privkey.pem" ///< Device private key filename

  NOTE: The values of the the parameters must be consistent with the information of the Thing registered in the AWS IoT platform. Refer to the SDK guide to create your Thing, key pair and certificate files. Put those certificate files in the directory iot-embeddedc/certs.

3. Create the VSB using the WrTool.

        wrtool prj vsb create -force -bsp fsl_imx6 myVsb -S      
        cd myVsb      
        wrtool prj vsb add AWS_IOT_SDK    
        make -j[jobs]  <-- set the number of parallel build jobs, typically 2, 4, 8     

4. Create the VIP using the WrTool.

        wrtool prj vip create -force -vsb myVsb -profile PROFILE_STANDALONE_DEVELOPMENT fsl_imx6 diab myVip
        cd myVip  
        wrtool prj vip component add INCLUDE_FSL_IMX6Q_SABRELITE INCLUDE_SHELL INCLUDE_NETWORK INCLUDE_IFCONFIG INCLUDE_PING INCLUDE_AWS_IOT
        wrtool prj vip parameter set DNSC_PRIMARY_NAME_SERVER   "\"128.224.160.11\""  
        wrtool prj vip parameter set DNSC_SECONDARY_NAME_SERVER "\"147.11.57.128\""  
    
  The test sample is provided in samples/vxworks/subscribe_publish_sample/subscribe_publish_sample.c. It can be used to connect your device to the AWS IoT cloud, publish events to the cloud and to subscribe to commands from the AWS IoT cloud. To enable this sample, you need to add the the file as shown below: 

        wrtool prj vip file add $WIND_BASE/pkgs/net/cloud/aws/src/iot-embeddedc/src/*.c
        wrtool prj vip file add $WIND_BASE/pkgs/net/cloud/aws/src/iot-embeddedc/samples/vxworks/subscribe_publish_sample/subscribe_publish_sample.c 

        wrtool prj vip buildmacro set EXTRA_INCLUDE "-I$WIND_BASE/pkgs/net/cloud/aws/src/iot-embeddedc/samples/vxworks/subscribe_publish_sample"

If you create the VIP project with GNU compiler, add the following:

        wrtool prj vip buildmacro set EXTRA_DEFINE "-DINET -DINET6 -std=c99 -Dinit_timer=init_timer_wr"
    
Or if you create the VIP project with Diab compiler, add the following:
    
        wrtool prj vip buildmacro set EXTRA_DEFINE "-DINET -DINET6 -Xdialect-c99 -Dinit_timer=init_timer_wr"
    
5. Copy the certificates file to the RomFS and compile the VIP project.
        
        cd $WIND_WRTOOL_WORKSPACE
        wrtool prj romfs create romfs
        wrtool prj romfs add -file $WIND_BASE/pkgs/net/cloud/aws/src/iot-embeddedc/certs/root-CA.crt romfs   
        wrtool prj romfs add -file $WIND_BASE/pkgs/net/cloud/aws/src/iot-embeddedc/certs/2cba22f801-certificate.pem.crt romfs 
        wrtool prj romfs add -file $WIND_BASE/pkgs/net/cloud/aws/src/iot-embeddedc/certs/2cba22f801-private.pem.key romfs
        wrtool prj subproject add romfs myVip
        cd myVip
        wrtool prj build

## Creating the VSB and VIP Using Workbench

### Create the VSB

1.  Open Workbench 4
2.  Select the target operating system.
3.  Click File > New > Wind River Workbench Project.
4.  Set the Build type to Source Build, click Next.
5.  Set up the project based on the BSP or CPU, click Finish.
6.  Couble-click Source Build Configuration in the Project Explorer of vsb_fsl_imx6 source build project.
7.  Right-click the AWS_IOT_SDK layer in the net option folder and select Add with Dependencies to add the AWS_IOT_SDK layer.
8.  Click File > Save.
9.  Right-click vsb_fsl_imx6 in the Project Explorer and then click Build Project.

### Create the VIP

1.  After you have built the VSB, click File > New > Wind River Workbench Project....
2.  Set Build type to VxWorks Image Project, click Next
3.  Set up the project based on the existing vsb_fsl_imx6, that was created previously, click Next.
4.  Set the profile to PROFILE_STANDALONE_DEVELOPMENT.
5.  Click Finish to create the VIP project.
  6.  After creating the VIP project, configure the components and parameters of the Kernel Configuration in the VIP Project ZZ
7.  Click File > Save to save the components configuration.
8.  To run the SDK demo, right-click the VIP project, choose Import > General > File System > Browse to add files in $WIND_BASE/pkgs/net/cloud/aws/src/iot-embeddedc/samples/vxworks/subscribe_publish_sample/ and $WIND_BASE/pkgs/net/cloud/aws/src/iot-embeddedc/.
9.  Click File > New > Project > VxWorks 7 > VxWorks ROMFS File System Project, named the project "romfs", set the Superproject to your VIP project. 
10. Click Add external to add the certificate files in $WIND_BASE/pkgs/net/cloud/aws/src/iot-embeddedc/certs/ to the ROMFS project 
11. Right-click vip_fsl_imx6 in the Project Explorer then click Build Project.

### Creating and Running the RTP 

The sample can also be run in VxWorks user space (for example, in a VxWorks RTP). The sample RTP file subscribe_publish_sample.vxe is generated in ${VSB_DIR}/usr/root/diab/bin or ${VSB_DIR}/usr/root/gnu/bin when building the VSB. Add the INCLUDE_RTP component in the VIP project, add the subscribe_publish_sample.vxe file to the RomFS project and build the VIP. When VxWorks is running, you can load and run the sample RTP in the VxWorks shell.
        
        rtpSp "/romfs/subscribe_publish_sample.vxe"

  Note: Before running the RTP sample to connect to the AWS cloud, you must set the correct VxWorks system time. You can use the on board RTC, configure the NTP or other methods to set the system time.

### View the device information at website

You can run your device image with the AWS IoT SDK and then view the device
information dashboard at the AWS IoT website.

* For information on what AWS IoT is, see the following information:

    'http://docs.aws.amazon.com/iot/latest/developerguide/what-is-aws-iot.html'

* For information on how to use the C SDK, see the following information:
    'http://docs.aws.amazon.com/iot/latest/developerguide/iot-device-sdk-c.html'

### Legal Notices

All product names, logos, and brands are property of their respective owners. All company, product and service names used in this software are for identification purposes only. Wind River and VxWorks are a registered trademarks of Wind River Systems. Amazon and AWS are registered trademarks of the Amazon Corporation.

Disclaimer of Warranty / No Support: Wind River does not provide support and maintenance services for this software, under Wind River’s standard Software Support and Maintenance Agreement or otherwise. Unless required by applicable law, Wind River provides the software (and each contributor provides its contribution) on an “AS IS” BASIS, WITHOUT WARRANTIES OF ANY KIND, either express or implied, including, without limitation, any warranties of TITLE, NONINFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A PARTICULAR PURPOSE. You are solely responsible for determining the appropriateness of using or redistributing the software and assume ay risks associated with your exercise of permissions under the license.
