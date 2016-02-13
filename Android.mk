LOCAL_PATH := $(call my-dir)

# Setup bdroid local make variables for handling configuration
ifneq ($(BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR),)
  bdroid_C_INCLUDES := $(BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR)
  bdroid_CFLAGS += -DHAS_BDROID_BUILDCFG
else
  bdroid_C_INCLUDES :=
  bdroid_CFLAGS += -DHAS_NO_BDROID_BUILDCFG
endif

ifeq ($(TARGET_BUILD_VARIANT),userdebug)
ifneq ($(BOARD_HAS_QCA_BT_ROME),true)
bdroid_CFLAGS += -DQLOGKIT_USERDEBUG
endif
endif

ifneq ($(BOARD_BLUETOOTH_BDROID_HCILP_INCLUDED),)
  bdroid_CFLAGS += -DHCILP_INCLUDED=$(BOARD_BLUETOOTH_BDROID_HCILP_INCLUDED)
endif

ifeq ($(TARGET_BUILD_VARIANT),eng)
bdroid_CFLAGS += -DBLUEDROID_DEBUG
bdroid_CFLAGS += -DUSE_AUDIO_TRACK
endif

ifeq ($(BOARD_USES_WIPOWER), true)
bdroid_CFLAGS  += -DWIPOWER_SUPPORTED
endif

#
# Common C/C++ compiler flags.
#
# -Wno-constant-logical-operand is needed for code in l2c_utils.c that is
#  intentional.
# -Wno-gnu-variable-sized-type-not-at-end is needed, because struct BT_HDR
#  is defined as a variable-size header in a struct.
# -Wno-typedef-redefinition is needed because of the way the struct typedef
#  is done in osi/include header files. This issue can be obsoleted by
#  switching to C11 or C++.
# -Wno-unused-parameter is needed, because there are too many unused
#  parameters in all the code.
#
bluetooth_CFLAGS += \
  -fvisibility=hidden \
  -Wall \
  -Wextra \
  -Werror \
  -Wno-constant-logical-operand \
  -Wno-gnu-variable-sized-type-not-at-end \
  -Wno-typedef-redefinition \
  -Wno-unused-parameter \
  -UNDEBUG \
  -DLOG_NDEBUG=1 \
  -Os

include $(call all-subdir-makefiles)

# Cleanup our locals
bdroid_C_INCLUDES :=
bdroid_CFLAGS :=
