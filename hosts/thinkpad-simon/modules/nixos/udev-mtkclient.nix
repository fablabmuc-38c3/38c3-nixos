# Android udev rules for NixOS
# Converted from https://github.com/M0Rf30/android-udev-rules

{
  config,
  lib,
  pkgs,
  ...
}:

{

  # Configure udev rules for Android devices
  services.udev.extraRules = ''
    # SPDX-FileCopyrightText: 2022 JoesCat, M0Rf30 and contributors
    #
    # SPDX-License-Identifier: GPL-3.0

    # Skip testing for android devices if device is not add, or usb
    ACTION!="add", ACTION!="bind", GOTO="android_usb_rules_end"
    SUBSYSTEM!="usb", GOTO="android_usb_rules_end"

    # Skip testing for unexpected devices like hubs or printers
    ATTR{bDeviceClass}=="09", GOTO="android_usb_rules_end"
    ENV{ID_USB_INTERFACES}=="*:0701??:*", ENV{adb_adb}="yes", GOTO="android_usb_rules_end"

    LABEL="android_usb_rules_begin"
    # Devices listed here in android_usb_rules_{begin...end} are connected by USB
    # Acer
    ATTR{idVendor}!="0502", GOTO="not_Acer"
    #   Iconia Tab A1-830
    ATTR{idProduct}=="3604", ENV{adb_adbfast}="yes"
    #   Iconia Tab A210 (33cc=normal,33cb=debug)
    ATTR{idProduct}=="33cb", ENV{adb_adb}="yes"
    #   Iconia Tab A500
    ATTR{idProduct}=="3325", ENV{adb_adbfast}="yes"
    #   Liquid (3202=normal,3203=debug)
    ATTR{idProduct}=="3203", ENV{adb_user}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_Acer"

    # Actions Semiconductor Co., Ltd
    #   Denver TAD 70111
    ATTR{idVendor}=="10d6", ATTR{idProduct}=="0c02", ENV{adb_adb}="yes"

    # ADVANCE (Need product specific rules)
    #   S5
    ATTR{idVendor}=="0a5c", ATTR{idProduct}=="e681", ENV{adb_adb}="yes"

    # Amazon Lab126
    #   Amazon Kindle Fire
    ATTR{idVendor}=="1949", ATTR{idProduct}=="0006", ENV{adb_adbfast}="yes"

    # Archos
    ATTR{idVendor}!="0e79", GOTO="not_Archos"
    #   43
    ATTR{idProduct}=="1417", ENV{adb_adbfast}="yes"
    #   101
    ATTR{idProduct}=="1411", ENV{adb_adbfast}="yes"
    #   101 xs
    ATTR{idProduct}=="1549", ENV{adb_adbfast}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_Archos"

    # Ascom
    ATTR{idVendor}!="1768", GOTO="not_Ascom"
    ATTR{idProduct}=="0007", ENV{adb_adb}="yes"
    ATTR{idProduct}=="000e", ENV{adb_adb}="yes"
    ATTR{idProduct}=="4ee7", ENV{adb_adb}="yes"
    ATTR{idProduct}=="0013", ENV{adb_adb}="yes"
    ATTR{idProduct}=="0011", ENV{adb_adb}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_Ascom"

    # ASUSTeK
    ATTR{idVendor}!="0b05", GOTO="not_Asus"
    #   False positive - accessory
    ATTR{idProduct}=="1???", GOTO="android_usb_rules_end"
    ENV{adb_user}="yes"
    #   Zenphone 2 (ZE500CL) (7770=adb 7773=mtp,adb 7777=ptp,adb   7775=rndis,adb,mass_storage 5F03=mtp,adb,pclink,mass_storage 5F07=ptp,adb,pclink 5F05=rndis,adb,pclink,mass_storage
    ATTR{idProduct}=="7770", SYMLINK+="android_adb"
    ATTR{idProduct}=="7773", SYMLINK+="android_adb"
    ATTR{idProduct}=="7777", SYMLINK+="android_adb"
    ATTR{idProduct}=="7775", SYMLINK+="android_adb"
    ATTR{idProduct}=="5F03", SYMLINK+="android_adb"
    ATTR{idProduct}=="5F07", SYMLINK+="android_adb"
    ATTR{idProduct}=="5F05", SYMLINK+="android_adb"
    #   Zenphone 4 (581f=mtp,adb 583f=rndis,adb)
    ATTR{idProduct}=="581f", SYMLINK+="android_adb"
    ATTR{idProduct}=="583f", SYMLINK+="android_adb"
    #   Zenphone 5 (4c90=normal,4c91=debug,4daf=Fastboot)
    ATTR{idProduct}=="4c91", SYMLINK+="android_adb"
    ATTR{idProduct}=="4daf", SYMLINK+="android_fastboot"
    #   Tegra APX
    ATTR{idProduct}=="7030", SYMLINK+="android_adb"
    GOTO="android_usb_rule_match"
    LABEL="not_Asus"

    # Azpen Onda
    ATTR{idVendor}=="1f3a", ENV{adb_user}="yes"

    # BQ
    ATTR{idVendor}!="2a47", GOTO="not_BQ"
    #   Aquaris 4.5
    ATTR{idProduct}=="0c02", ENV{adb_adbfast}="yes"
    ATTR{idProduct}=="2008", ENV{adb_adbfast}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_BQ"

    # Castles
    ATTR{idVendor}!="0ca6", GOTO="not_Castles"
    #   Saturn1000-E
    ATTR{idProduct}=="a051", ENV{adb_user}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_Castles"

    # Essential
    ATTR{idVendor}!="2e17", GOTO="not_Essential"
    #   Essential PH-1
    ATTR{idProduct}=="c009", ENV{adb_adb}="yes"
    ATTR{idProduct}=="c03[02]", ENV{adb_adb}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_Essential"

    # Fairphone 1 (see Hisense 109b)
    # Fairphone 2 (f005=tether, f00e=rndis, 90de=charge, 90dc=charge,adb f000=MTP, 9039=MTP,adb, 904d=PTP, 904e=PTP,adb, 9015=storage,adb, 9024=rndis,adb) 90bb=qualcom midi+adb
    ATTR{idVendor}!="2ae5", GOTO="not_Fairphone2"
    ATTR{idProduct}=="9015", ENV{adb_adb}="yes"
    ATTR{idProduct}=="9039", ENV{adb_adb}="yes"
    ATTR{idProduct}=="904e", ENV{adb_adb}="yes"
    ATTR{idProduct}=="90dc", ENV{adb_adb}="yes"
    ATTR{idProduct}=="90bb", ENV{adb_adb}="yes", ENV{midi_user}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_Fairphone2"

    # Foxconn
    #   Commtiva Z71, Geeksphone One
    ATTR{idVendor}=="0489", ATTR{idProduct}=="c001", ENV{adb_adb}="yes"

    # Fujitsu/Fujitsu Toshiba
    ATTR{idVendor}=="04c5", ENV{adb_user}="yes"

    # Fuzhou Rockchip Electronics
    #   Mediacom Smartpad 715i
    ATTR{idVendor}=="2207", ATTR{idProduct}=="0000", ENV{adb_adb}="yes"
    #   Ubislate 7Ci
    ATTR{idVendor}=="2207", ATTR{idProduct}=="0010", ENV{adb_adb}="yes"

    # Garmin-Asus
    ATTR{idVendor}=="091e", ENV{adb_user}="yes"

    # Google
    ATTR{idVendor}!="18d1", GOTO="not_Google"
    #   Nexus, Pixel, Pixel XL, Pixel 2, Pixel 2XL (4ee1=mtp, 4ee2=mtp,adb 4ee3=rndis, 4ee4=rndis,adb 4ee5=ptp, 4ee6=ptp,adb 4ee7=adb 4ee8=midi, 4ee9=midi,adb 2d00=accessory 2d01=accessory,adb 2d03=audio_source,adb 2d05=accessory,audio_source,adb)
    #   See https://android.googlesource.com/device/google/wahoo/+/master/init.hardware.usb.rc
    #   OnePlus 6, 4ee1=charging, 4ee2=MTP+debug, 4ee6=PTP+debug, 4ee7=charging+debug
    #   Pico i.MX7 Dual Development Board 4ee7=debug
    #   Yandex Phone 4ee7=debug
    ATTR{idProduct}=="4ee0", ENV{adb_adbfast}="yes"
    ATTR{idProduct}=="4ee2", ENV{adb_adb}="yes"
    ATTR{idProduct}=="4ee4", ENV{adb_adb}="yes"
    ATTR{idProduct}=="4ee6", ENV{adb_adb}="yes"
    ATTR{idProduct}=="4ee7", ENV{adb_adb}="yes"
    ATTR{idProduct}=="4ee9", ENV{adb_adb}="yes"

    #   Pixel C Tablet
    ATTR{idProduct}=="5201", ENV{adb_fast}="yes"
    ATTR{idProduct}=="5203", ENV{adb_adb}="yes"
    ATTR{idProduct}=="5208", ENV{adb_adb}="yes"

    ATTR{idProduct}=="2d00", ENV{adb_adb}="yes"
    ATTR{idProduct}=="2d01", ENV{adb_adb}="yes"
    ATTR{idProduct}=="2d03", ENV{adb_adb}="yes"
    ATTR{idProduct}=="2d05", ENV{adb_adb}="yes"
    #   Nexus 7
    ATTR{idProduct}=="4e42", ENV{adb_adb}="yes"
    ATTR{idProduct}=="4e40", ENV{adb_adbfast}="yes"
    #   Nexus 5, Nexus 10
    ATTR{idProduct}=="4ee1", ENV{adb_adbfast}="yes"
    #   Nexus S (4e22=mass_storage,adb 4e24=rndis,adb)
    #   See https://android.googlesource.com/device/samsung/crespo/+/android-4.1.2_r2.1/init.herring.usb.rc
    ATTR{idProduct}=="4e22", ENV{adb_adb}="yes"
    ATTR{idProduct}=="4e24", ENV{adb_adb}="yes"
    ATTR{idProduct}=="4e20", ENV{adb_adbfast}="yes"
    #   Galaxy Nexus, Galaxy Nexus (GSM)
    ATTR{idProduct}=="4e30", ENV{adb_adbfast}="yes"
    #   Nexus One (4e11=normal,4e12=debug,0fff=debug)
    ATTR{idProduct}=="4e12", ENV{adb_adb}="yes"
    ATTR{idProduct}=="0fff", ENV{adb_adbfast}="yes"
    #   Recovery adb entry for Nexus Family (orig d001, OP3 has 18d1:d002)
    ATTR{idProduct}=="d00?", ENV{adb_adb}="yes"
    #   Generic and unspecified debug interface (test after d00?)
    ATTR{idProduct}=="d00d", ENV{adb_adbfast}="yes"

    # Other vendors that also used duplicated Google's idVendor code follows:
    # IDEA XDS-1078 (debug=2c11)
    ATTR{idProduct}=="2c11", ENV{adb_adb}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_Google"

    # Haier
    ATTR{idVendor}=="201e", ENV{adb_user}="yes"

    # Hisense (includes Fairphone 1)
    ATTR{idVendor}=="109b", ENV{adb_user}="yes"

    # Honeywell/Foxconn
    ATTR{idVendor}!="0c2e", GOTO="not_Honeywell"
    #   D70e
    ATTR{idProduct}=="0ba3", ENV{adb_adb}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_Honeywell"

    # HTC
    ATTR{idVendor}!="0bb4", GOTO="not_HTC"
    ENV{adb_user}="yes"
    #   fastboot mode enabled
    ATTR{idProduct}=="0fff", ENV{adb_adbfast}="yes", GOTO="android_usb_rule_match"
    #   ADP1, Dream, G1, HD2, Magic, Tatoo (0c01=mass_storage)
    ATTR{idProduct}=="0c02", ENV{adb_adbfast}="yes"
    #   ChaCha
    ATTR{idProduct}=="0cb2", ENV{adb_adbfast}="yes"
    #   Desire (Bravo)
    ATTR{idProduct}=="0c87", SYMLINK+="android_adb"
    #   Desire HD
    ATTR{idProduct}=="0ca2", SYMLINK+="android_adb"
    #   Desire S (Saga)
    ATTR{idProduct}=="0cab", SYMLINK+="android_adb"
    #   Desire Z
    ATTR{idProduct}=="0c91", ENV{adb_adbfast}="yes"
    #   Evo Shift
    ATTR{idProduct}=="0ca5", SYMLINK+="android_adb"
    #   Hero H2000
    ATTR{idProduct}=="0001", ENV{adb_adbfast}="yes"
    #   Hero (GSM), Desire
    ATTR{idProduct}=="0c99", SYMLINK+="android_adb"
    #   Hero (CDMA)
    ATTR{idProduct}=="0c9a", SYMLINK+="android_adb"
    #   Incredible
    ATTR{idProduct}=="0c9e", SYMLINK+="android_adb"
    #   Incredible rev 0002
    ATTR{idProduct}=="0c8d", SYMLINK+="android_adb"
    #   MyTouch 4G
    ATTR{idProduct}=="0c96", SYMLINK+="android_adb"
    #   One (m7) && One (m8)
    ATTR{idProduct}=="0c93", SYMLINK+="android_adb"
    #   Sensation
    ATTR{idProduct}=="0f87", SYMLINK+="android_adb"
    ATTR{idProduct}=="0ff0", SYMLINK+="android_fastboot"
    #   One V
    ATTR{idProduct}=="0ce5", SYMLINK+="android_adb"
    #   One X
    ATTR{idProduct}=="0cd6", SYMLINK+="android_adb"
    #   Slide
    ATTR{idProduct}=="0e03", SYMLINK+="android_adb"
    #   Vision
    ATTR{idProduct}=="0c91", SYMLINK+="android_adb"
    #   Wildfire
    ATTR{idProduct}=="0c8b", ENV{adb_adbfast}="yes"
    #   Wildfire S
    ATTR{idProduct}=="0c86", ENV{adb_adbfast}="yes"
    #   Zopo ZP900, Fairphone
    ATTR{idProduct}=="0c03", ENV{adb_adbfast}="yes"
    #   Zopo C2
    ATTR{idProduct}=="2008", SYMLINK+="libmtp-%k", ENV{ID_MTP_DEVICE}="1", ENV{ID_MEDIA_PLAYER}="1"
    GOTO="android_usb_rule_match"
    LABEL="not_HTC"

    # Huawei
    ATTR{idVendor}!="12d1", GOTO="not_Huawei"
    ENV{adb_user}="yes"
    #   IDEOS
    ATTR{idProduct}=="1038", ENV{adb_adbfast}="yes"
    #   U8850 Vision
    ATTR{idProduct}=="1021", ENV{adb_adbfast}="yes"
    #   HiKey adb
    ATTR{idProduct}=="1057", SYMLINK+="android_adb"
    #   HiKey usbnet
    ATTR{idProduct}=="1050", SYMLINK+="android_adb"
    #   Honor 6
    ATTR{idProduct}=="103a", SYMLINK+="android_adb"
    ATTR{idProduct}=="1051", SYMLINK+="libmtp-%k", ENV{ID_MTP_DEVICE}="1", ENV{ID_MEDIA_PLAYER}="1"
    #   MediaPad M2-A01L
    ATTR{idProduct}=="1052", SYMLINK+="android_adb"
    #   MediaPad T3
    ATTR{idProduct}=="107d", SYMLINK+="android_adb"
    #   P10 Lite
    ATTR{idProduct}=="107e", SYMLINK+="android_adb"
    #   Watch
    ATTR{idProduct}=="1c2c", SYMLINK+="android_adb"
    #   Mate 9
    ATTR{idProduct}=="107e", SYMLINK+="android_adb"
    GOTO="android_usb_rule_match"
    LABEL="not_Huawei"

    # Intel
    ATTR{idVendor}!="8087", GOTO="not_Intel"
    #   Geeksphone Revolution
    ATTR{idProduct}=="0a16", ENV{adb_adb}="yes"
    #   Chuwi Hi 10 Pro (HQ64)
    ATTR{idProduct}=="2a65", ENV{adb_adb}="yes"
    ATTR{idProduct}=="07ef", ENV{adb_adb}="yes"
    #   Asus ZenFone 2 (ADB Sideload in TWRP Recovery)
    ATTR{idProduct}=="0a5d", ENV{adb_adb}="yes"
    #   Reference Boards using kernelflinger
    #   See https://github.com/intel/kernelflinger/blob/master/libefiusb/usb.c#L56
    ATTR{idProduct}=="09ef", ENV{adb_adbfast}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_Intel"

    # IUNI
    ATTR{idVendor}!="271d", GOTO="not_IUNI"
    #   U3
    ATTR{idProduct}=="bf39", ENV{adb_adb}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_IUNI"

    # K-Touch
    ATTR{idVendor}=="24e3", ENV{adb_user}="yes"

    # KT Tech
    ATTR{idVendor}=="2116", ENV{adb_user}="yes"

    # Lenovo
    ATTR{idVendor}=="17ef", ENV{adb_user}="yes"

    # LeTv (LeECo)
    ATTR{idVendor}!="2b0e", GOTO="not_letv"
    ENV{adb_user}="yes"
    #   LEX720 LeEco Pro3 6GB (610c=normal,610d=debug, 610b=camera)
    ATTR{idProduct}=="610d", ENV{adb_adbfast}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_letv"

    # LG
    ATTR{idVendor}!="1004", GOTO="not_LG"
    ENV{adb_user}="yes"
    #   Ally, Vortex, P500, P500h (618f=mass_storage)
    ATTR{idProduct}=="618e", SYMLINK+="android_adb"
    #   G2 D802
    ATTR{idProduct}=="61f1", SYMLINK+="android_adb"
    #   G2 D803
    ATTR{idProduct}=="618c", SYMLINK+="android_adb"
    #   G2 D803 rogers
    ATTR{idProduct}=="631f", SYMLINK+="android_adb"
    #   G2 mini D620r (PTP)
    ATTR{idProduct}=="631d", SYMLINK+="android_adb"
    #   G3 D855
    ATTR{idProduct}=="633e", SYMLINK+="android_adb"
    #   Optimus LTE
    ATTR{idProduct}=="6315", SYMLINK+="android_adb"
    ATTR{idProduct}=="61f9", SYMLINK+="libmtp-%k", ENV{ID_MTP_DEVICE}="1", ENV{ID_MEDIA_PLAYER}="1"
    #   Optimus One
    ATTR{idProduct}=="61c5", SYMLINK+="android_adb"
    #   Swift GT540
    ATTR{idProduct}=="61b4", SYMLINK+="android_adb"
    #   P500 CM10
    ATTR{idProduct}=="61a6", SYMLINK+="android_adb"
    #   4X HD P880
    ATTR{idProduct}=="61f9", SYMLINK+="android_adb"
    #   L90 D410
    ATTR{idProduct}=="6300", SYMLINK+="android_adb"
    GOTO="android_usb_rule_match"
    LABEL="not_LG"

    # Meizu
    ATTR{idVendor}!="2a45", GOTO="not_Meizu"
    #   MX6
    ATTR{idProduct}=="0c02", ENV{adb_adb}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_Meizu"

    # Micromax
    ATTR{idVendor}!="2a96", GOTO="not_Micromax"
    #   P702
    ATTR{idProduct}=="201d", ENV{adb_adbfast}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_Micromax"

    # Microsoft
    ATTR{idVendor}!="045e", GOTO="not_Microsoft"
    ENV{adb_user}="yes"
    #   Surface Duo
    ATTR{idProduct}=="0c26", ENV{adb_adbfast}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_Microsoft"

    # Motorola
    ATTR{idVendor}!="22b8", GOTO="not_Motorola"
    ENV{adb_user}="yes"
    #   CLIQ XT/Quench
    ATTR{idProduct}=="2d66", SYMLINK+="android_adb"
    #   Defy/MB525
    ATTR{idProduct}=="428c", SYMLINK+="android_adb"
    #   Droid
    ATTR{idProduct}=="41db", SYMLINK+="android_adb"
    #   Xoom ID 1
    ATTR{idProduct}=="70a8", ENV{adb_adbfast}="yes"
    #   Xoom ID 2
    ATTR{idProduct}=="70a9", ENV{adb_adbfast}="yes"
    #   Razr XT912
    ATTR{idProduct}=="4362", ENV{adb_adbfast}="yes"
    #   Moto XT1052
    ATTR{idProduct}=="2e83", ENV{adb_adbfast}="yes"
    #   Moto E/G
    ATTR{idProduct}=="2e76", ENV{adb_adbfast}="yes"
    #   Moto E/G (Dual SIM)
    ATTR{idProduct}=="2e80", ENV{adb_adbfast}="yes"
    #   Moto E/G (Global GSM)
    ATTR{idProduct}=="2e82", ENV{adb_adbfast}="yes"
    #   Moto x4
    ATTR{idProduct}=="2e81", ENV{adb_adbfast}="yes"
    #   Droid Turbo 2
    ATTR{idProduct}=="2ea4", ENV{adb_adbfast}="yes", SYMLINK+="android%n"
    GOTO="android_usb_rule_match"
    LABEL="not_Motorola"

    # MTK (MediaTek Inc)
    ATTR{idVendor}!="0e8d", GOTO="not_MTK"
    ENV{adb_user}="yes"
    #   Umidigi F1
    ATTR{idProduct}=="201c", ENV{adb_adbfast}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_MTK"

    # NEC
    ATTR{idVendor}=="0409", ENV{adb_user}="yes"

    # Nextbit
    ATTR{idVendor}=="2c3f", ENV{adb_user}="yes"

    # Nokia X
    ATTR{idVendor}=="0421", ENV{adb_user}="yes"

    # Nokia 3
    ATTR{idVendor}=="2e04", ENV{adb_user}="yes"

    # Nook (Barnes & Noble)
    ATTR{idVendor}=="2080", ENV{adb_user}="yes"

    # Nvidia
    ATTR{idVendor}!="0955", GOTO="not_Nvidia"
    ENV{adb_user}="yes"
    #   Audi SDIS Rear Seat Entertainment Tablet
    #   Folio
    ATTR{idProduct}=="7000", SYMLINK+="android_fastboot"
    ATTR{idProduct}=="7100", ENV{adb_user}="yes"
    #   SHIELD Tablet (debug)
    ATTR{idProduct}=="cf05", ENV{adb_adb}="yes"
    ATTR{idProduct}=="cf09", ENV{adb_adb}="yes"
    #   Shield TV
    ATTR{idProduct}=="b442", SYMLINK+="android_fastboot"
    GOTO="android_usb_rule_match"
    LABEL="not_Nvidia"

    # Oculus
    ATTR{idVendor}=="2833", ENV{adb_user}="yes"

    # OnePlus(Oreo)
    ATTR{idVendor}!="2a70", GOTO="not_OnePlus"
    #   OnePlus 6, 4ee1=charging, 4ee2=MTP+debug, 4ee6=PTP+debug, 4ee7=charging+debug
    ATTR{idProduct}=="4ee2", ENV{adb_adb}="yes"
    ATTR{idProduct}=="4ee6", ENV{adb_adb}="yes"
    ATTR{idProduct}=="4ee7", ENV{adb_adb}="yes"
    #   OnePlus 3T with Oreo MIDI mode 90bb=adb+midi, 9011=MTP, 904e=PTP
    ATTR{idProduct}=="90bb", ENV{adb_adb}="yes"
    ATTR{idProduct}=="9011", SYMLINK+="android_adb"
    ATTR{idProduct}=="904e", SYMLINK+="android_adb"
    GOTO="android_usb_rule_match"
    LABEL="not_OnePlus"

    # Oppo
    ATTR{idVendor}!="22d9", GOTO="not_Oppo"
    #   Find 5 (2767=debug)
    ATTR{idProduct}=="2767", ENV{adb_adb}="yes"
    #   Realme 8
    ATTR{idProduct}=="2769", ENV{adb_adb}="yes"
    ATTR{idProduct}=="2764", SYMLINK+="libmtp-%k", ENV{ID_MTP_DEVICE}="1", ENV{ID_MEDIA_PLAYER}="1"
    #   A94 5G
    ATTR{idProduct}=="2769", ENV{adb_adb}="yes"
    #   Oppo Watch, fastboot
    ATTR{idProduct}=="2024", ENV{adb_user}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_Oppo"

    # OTGV
    ATTR{idVendor}=="2257", ENV{adb_user}="yes"

    # Pantech (SK Teletech Co, Ltd.)
    ATTR{idVendor}=="10a9", ENV{adb_user}="yes"

    # Parrot SA (Car HUD)
    ATTR{idVendor}=="19cf", ENV{adb_user}="yes"

    # Pegatron
    ATTR{idVendor}=="1d4d", ENV{adb_user}="yes"

    # Philips (and NXP)
    ATTR{idVendor}=="0471", ENV{adb_user}="yes"

    # Pico
    ATTR{idVendor}=="2d40", ENV{adb_user}="yes"

    # PMC-Sierra, (Panasonic Mobile communications, Matsushita)
    ATTR{idVendor}=="04da", ENV{adb_user}="yes"

    # Point Mobile
    ATTR{idVendor}!="2a48", GOTO="not_Point_Mobile"
    #   PM90
    ATTR{idProduct}=="5101", ENV{adb_user}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_Point_Mobile"

    # Qualcomm (Wearners also 05c6)
    ATTR{idVendor}!="05c6", GOTO="not_Qualcomm"
    ENV{adb_user}="yes"
    #   Geeksphone Zero
    ATTR{idProduct}=="9025", SYMLINK+="android_adb"
    #   OnePlus One
    ATTR{idProduct}=="676?", SYMLINK+="android_adb"
    #   OnePlus Two
    ATTR{idProduct}=="9011", SYMLINK+="android_adb"
    #   OnePlus 3
    ATTR{idProduct}=="900e", SYMLINK+="android_adb"
    #   OnePlus 3T
    ATTR{idProduct}=="676c", SYMLINK+="android_adb"
    #   Snapdragon, OnePlus 3T w/ Oreo MIDI mode (90bb=adb,midi, 9011=MTP, 904e=PTP)
    #   Xiaomi A1 (90bb=midi+adb)
    ATTR{idProduct}=="90bb", ENV{adb_adb}="yes"
    #   OnePlus 5 / 6 / 6T
    ATTR{idProduct}=="9011", SYMLINK+="android_adb"
    #   OnePlus 6 / Asia
    ATTR{idProduct}=="f003", SYMLINK+="android_adb"
    #   Yongnuo YN450m (identified in lsusb as Intex Aqua Fish & Jolla C Diagnostic Mode)
    ATTR{idProduct}=="9091", SYMLINK+="android_adb"
    GOTO="android_usb_rule_match"
    LABEL="not_Qualcomm"

    # Razer USA, Ltd.
    ATTR{idVendor}!="1532", GOTO="not_Razer"
    #   Razer Phone 2
    ATTR{idProduct}=="9050", ENV{adb_adbfast}="yes"
    ATTR{idProduct}=="9051", ENV{adb_adb}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_Razer"

    # Research In Motion, Ltd.
    ATTR{idVendor}!="0fca", GOTO="not_RIM"
    #   BlackBerry DTEK60
    ATTR{idProduct}=="8042", ENV{adb_fastboot}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_RIM"

    # Samsung
    ATTR{idVendor}!="04e8", GOTO="not_Samsung"
    #   False positive printer
    ATTR{idProduct}=="3???", GOTO="android_usb_rules_end"
    ENV{adb_user}="yes"
    #   Galaxy i5700
    ATTR{idProduct}=="681c", ENV{adb_adbfast}="yes"
    #   Galaxy i5800 (681c=debug,6601=fastboot,68a0=mediaplayer)
    ATTR{idProduct}=="681c", SYMLINK+="android_adb"
    ATTR{idProduct}=="6601", SYMLINK+="android_fastboot"
    ATTR{idProduct}=="68a9", SYMLINK+="libmtp-%k", ENV{ID_MTP_DEVICE}="1", ENV{ID_MEDIA_PLAYER}="1"
    #   Galaxy i7500
    ATTR{idProduct}=="6640", ENV{adb_adbfast}="yes"
    #   Galaxy i9000 S, i9300 S3
    ATTR{idProduct}=="6601", SYMLINK+="android_adb"
    ATTR{idProduct}=="685d", MODE="0660"
    ATTR{idProduct}=="68c3", MODE="0660"
    #   Galaxy Ace (S5830) "Cooper"
    ATTR{idProduct}=="689e", ENV{adb_adbfast}="yes"
    #   Galaxy Tab
    ATTR{idProduct}=="6877", ENV{adb_adbfast}="yes"
    #   Galaxy Nexus (GSM) (6860=mtp,adb 6864=rndis,adb 6866=ptp,adb)
    ATTR{idProduct}=="6860", SYMLINK+="android_adb"
    ATTR{idProduct}=="6864", SYMLINK+="android_adb"
    ATTR{idProduct}=="6866", SYMLINK+="android_adb"
    #   Galaxy Core, Tab 10.1, i9100 S2, i9300 S3, N5100 Note (8.0), Galaxy S3 SHW-M440S 3G (Korea only)
    ATTR{idProduct}=="685e", ENV{adb_adbfast}="yes"
    #   Galaxy i9300 S3
    ATTR{idProduct}=="6866", SYMLINK+="libmtp-%k", ENV{ID_MTP_DEVICE}="1", ENV{ID_MEDIA_PLAYER}="1"
    #   Galaxy S4 GT-I9500
    ATTR{idProduct}=="685d", SYMLINK+="android_adb"
    GOTO="android_usb_rule_match"
    LABEL="not_Samsung"

    # Sharp
    ATTR{idVendor}=="04dd", ENV{adb_user}="yes"

    # SK Telesys
    ATTR{idVendor}=="1f53", ENV{adb_user}="yes"

    # Sonim
    ATTR{idVendor}=="1d9c", ENV{adb_user}="yes"

    # Sony
    ATTR{idVendor}=="054c", ENV{adb_user}="yes"

    # Sony Ericsson
    ATTR{idVendor}!="0fce", GOTO="not_Sony_Ericsson"
    ENV{adb_user}="yes"
    #   Xperia X10 mini (3137=mass_storage)
    ATTR{idProduct}=="2137", SYMLINK+="android_adb"
    #   Xperia X10 mini pro (3138=mass_storage)
    ATTR{idProduct}=="2138", SYMLINK+="android_adb"
    #   Xperia X8 (3149=mass_storage)
    ATTR{idProduct}=="2149", SYMLINK+="android_adb"
    #   Xperia X12 (e14f=mass_storage)
    ATTR{idProduct}=="614f", SYMLINK+="android_adb"
    #   Xperia Arc S
    ATTR{idProduct}=="414f", ENV{adb_adbfast}="yes"
    #   Xperia Neo V (6156=debug,0dde=fastboot)
    ATTR{idProduct}=="6156", SYMLINK+="android_adb"
    ATTR{idProduct}=="0dde", SYMLINK+="android_fastboot"
    #   Xperia S
    ATTR{idProduct}=="5169", ENV{adb_adbfast}="yes"
    #   Xperia SP
    ATTR{idProduct}=="6195", ENV{adb_adbfast}="yes"
    #   Xperia L
    ATTR{idProduct}=="5192", ENV{adb_adbfast}="yes"
    #   Xperia Mini Pro
    ATTR{idProduct}=="0166", ENV{adb_adbfast}="yes"
    #   Xperia V
    ATTR{idProduct}=="0186", ENV{adb_adbfast}="yes"
    #   Xperia Acro S
    ATTR{idProduct}=="5176", ENV{adb_adbfast}="yes"
    #   Xperia Z1 Compact
    ATTR{idProduct}=="51a7", ENV{adb_adbfast}="yes"
    #   Xperia Z2
    ATTR{idProduct}=="51ba", ENV{adb_adbfast}="yes"
    #   Xperia Z3
    ATTR{idProduct}=="01af", ENV{adb_adbfast}="yes"
    #   Xperia Z3 Compact
    ATTR{idProduct}=="01bb", ENV{adb_adbfast}="yes"
    #   Xperia Z3+ Dual
    ATTR{idProduct}=="51c9", ENV{adb_adbfast}="yes"
    #   Xperia XZ
    ATTR{idProduct}=="51e7", ENV{adb_adbfast}="yes"
    #   Xperia XZ1 Compact
    ATTR{idProduct}=="01f4", ENV{adb_adbfast}="yes"
    #   Xperia XZ2 Compact
    ATTR{idProduct}=="b00b", ENV{adb_adbfast}="yes"
    #   Xperia 5 II
    ATTR{idProduct}=="020d", ENV{adb_adbfast}="yes"
    #   Xperia Z Ultra
    ATTR{idProduct}=="519c", ENV{adb_adbfast}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_Sony_Ericsson"

    # Spectralink
    ATTR{idVendor}=="1973", ENV{adb_user}="yes"

    # Spreadtrum
    ATTR{idVendor}=="1782", ENV{adb_user}="yes"

    # T & A Mobile Phones
    ATTR{idVendor}!="1bbb", GOTO="not_T_A_Mobile"
    ENV{adb_user}="yes"
    #   Alcatel 1 2019 5033F
    ATTR{idProduct}=="0c01", ENV{adb_adb}="yes"
    #   Alcatel OT991D
    ATTR{idProduct}=="00f2", ENV{adb_adb}="yes"
    #   Alcatel OT6012A
    ATTR{idProduct}=="0167", ENV{adb_adb}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_T_A_Mobile"

    # Teleepoch
    ATTR{idVendor}=="2340", ENV{adb_user}="yes"

    # Texas Instruments UsbBoot
    ATTR{idVendor}=="0451", ATTR{idProduct}=="d00f", ENV{adb_user}="yes"
    ATTR{idVendor}=="0451", ATTR{idProduct}=="d010", ENV{adb_user}="yes"

    # Toshiba
    ATTR{idVendor}=="0930", ENV{adb_user}="yes"

    # Unitech Electronics
    ATTR{idVendor}!="2e8e", GOTO="not_Unitech_Electronics"
    ENV{adb_user}="yes"
    #   EA630 (96e1=normal,96e7=debug)
    ATTR{idProduct}=="96e7", ENV{adb_adb}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_Unitech_Electronics"

    # Wileyfox
    ATTR{idVendor}=="2970", ENV{adb_user}="yes"

    # XiaoMi
    ATTR{idVendor}!="2717", GOTO="not_XiaoMi"
    ENV{adb_user}="yes"
    #   Mi2A
    ATTR{idProduct}=="904e", SYMLINK+="android_adb"
    ATTR{idProduct}=="9039", SYMLINK+="android_adb"
    #   Mi3
    ATTR{idProduct}=="0368", SYMLINK+="android_adb"
    #   RedMi 1S WCDMA (MTP+Debug)
    ATTR{idProduct}=="1268", SYMLINK+="android_adb"
    #   RedMi / RedMi Note WCDMA (MTP+Debug)
    ATTR{idProduct}=="1248", SYMLINK+="android_adb"
    #   RedMi 1S / RedMi / RedMi Note WCDMA (PTP+Debug)
    ATTR{idProduct}=="1218", SYMLINK+="android_adb"
    #   RedMi 1S /RedMi / RedMi Note WCDMA (Usb+Debug)
    ATTR{idProduct}=="1228", SYMLINK+="android_adb"
    #   RedMi / RedMi Note 4G WCDMA (MTP+Debug)
    ATTR{idProduct}=="1368", SYMLINK+="android_adb"
    #   RedMi / RedMi Note 4G WCDMA (PTP+Debug)
    ATTR{idProduct}=="1318", SYMLINK+="android_adb"
    #   RedMi / RedMi Note 4G WCDMA (Usb+Debug)
    ATTR{idProduct}=="1328", SYMLINK+="android_adb"
    #   Mi Mix / A1 (ff88=rndis+adb, ff18=ptp+adb, ff48=mtp+adb, ff28=storage+adb)
    ATTR{idProduct}=="ff88", SYMLINK+="android_adb"
    ATTR{idProduct}=="ff18", SYMLINK+="android_adb"
    ATTR{idProduct}=="ff48", SYMLINK+="android_adb"
    ATTR{idProduct}=="ff28", SYMLINK+="android_adb"
    #   RedMi / RedMi Note 4G CDMA (Usb+Debug) / Mi4c / Mi5
    ATTR{idProduct}=="ff68", SYMLINK+="android_adb"
    #   RedMi 7
    ATTR{idProduct}=="ff40", SYMLINK+="android_adb"
    #   RedMi Note 8T
    ATTR{idProduct}=="ff08", SYMLINK+="android_adb"
    #   RedMi 8 Pro
    ATTR{idProduct}=="ff48", SYMLINK+="android_adb"
    GOTO="android_usb_rule_match"
    LABEL="not_XiaoMi"

    # Yota
    ATTR{idVendor}!="2916", GOTO="not_Yota"
    ENV{adb_user}="yes"
    #   YotaPhone2 (f003=normal,9139=debug)
    ATTR{idProduct}=="9139", ENV{adb_adb}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_Yota"

    # YU
    ATTR{idVendor}=="1ebf", ENV{adb_user}="yes"

    # Zebra
    ATTR{idVendor}!="05e0", GOTO="not_Zebra"
    #   TC55
    ATTR{idProduct}=="2101", ENV{adb_adb}="yes"
    #   TC72
    ATTR{idProduct}=="2106", ENV{adb_adb}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_Zebra"

    # ZTE
    ATTR{idVendor}!="19d2", GOTO="not_ZTE"
    #   ZTE Blade A5 2020
    #   mtp,adb
    ATTR{idProduct}=="0306", ENV{adb_adb}="yes"
    #   ptp,adb
    ATTR{idProduct}=="0310", ENV{adb_adb}="yes"
    #   cdrom,adb
    ATTR{idProduct}=="0501", ENV{adb_adb}="yes"
    #   charging,adb
    ATTR{idProduct}=="1352", ENV{adb_adb}="yes"
    #   rndis,adb
    ATTR{idProduct}=="1373", ENV{adb_adb}="yes"
    #   Blade (1353=normal,1351=debug)
    ATTR{idProduct}=="1351", ENV{adb_adb}="yes"
    #   Blade S (Crescent, Orange San Francisco 2) (1355=normal,1354=debug)
    ATTR{idProduct}=="1354", ENV{adb_adb}="yes"
    #   P685M LTE modem
    ATTR{idProduct}=="1275", ENV{adb_user}="yes"
    #   MF286[A] internal LTE modem
    ATTR{idProduct}=="1432", ENV{adb_user}="yes"
    #   MF286D internal LTE modem
    ATTR{idProduct}=="1485", ENV{adb_user}="yes"
    #   MF286R internal LTE modem
    ATTR{idProduct}=="1489", ENV{adb_user}="yes"
    #   Nubia / RedMagic Series (NX***)
    #   See https://github.com/TadiT7/nubia_nx619j_dump/blob/NX619J-user-9-PKQ1.180929.001-eng.nubia.20181220.181559-release-keys/vendor/etc/init/hw/init.nubia.usb.rc
    #   ptp,adb
    ATTR{idProduct}=="ffd1", ENV{adb_adb}="yes"
    #   mtp,adb
    ATTR{idProduct}=="ffcf", ENV{adb_adb}="yes"
    #   mass_storage,adb
    ATTR{idProduct}=="ffcd", ENV{adb_adb}="yes"
    #   rndis,adb
    ATTR{idProduct}=="ffcb", ENV{adb_adb}="yes"
    #   modem,service,nema,adb
    ATTR{idProduct}=="ffc9", ENV{adb_adb}="yes"
    #   modem,service,nema,mass_storage,adb
    ATTR{idProduct}=="ffc7", ENV{adb_adb}="yes"
    #   diag,modem,mass_storage,adb
    ATTR{idProduct}=="ffb0", ENV{adb_adb}="yes"
    #   diag,modem,service,mass_storage,adb
    ATTR{idProduct}=="ffb2", ENV{adb_adb}="yes"
    #   adb
    ATTR{idProduct}=="ffc1", ENV{adb_adb}="yes"
    #   diag,mass_storage,adb
    ATTR{idProduct}=="ffc0", ENV{adb_adb}="yes"
    GOTO="android_usb_rule_match"
    LABEL="not_ZTE"

    # ZUK
    ATTR{idVendor}=="2b4c", ENV{adb_user}="yes"

    # Verifone
    ATTR{idVendor}=="11ca", ENV{adb_user}="yes"

    # Skip other vendor tests
    LABEL="android_usb_rule_match"

    # Symlink shortcuts to reduce code in tests above
    ENV{adb_adbfast}=="yes", ENV{adb_adb}="yes", ENV{adb_fast}="yes"
    ENV{adb_adb}=="yes", ENV{adb_user}="yes", SYMLINK+="android_adb"
    ENV{adb_fast}=="yes", SYMLINK+="android_fastboot"

    # Enable device as a user device if found (add an "android" SYMLINK)
    ENV{adb_user}=="yes", MODE="0660", GROUP="adbusers", TAG+="uaccess", SYMLINK+="android", SYMLINK+="android%n"

    #Suzy-Q
    SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="d002", MODE="0660", GROUP="plugdev", SYMLINK+="android%n"

    # Devices listed here {begin...end} are connected by USB
    LABEL="android_usb_rules_end"
  '';

}
