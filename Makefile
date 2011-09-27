THEOS_DEVICE_IP = 192.168.1.106
include theos/makefiles/common.mk

TWEAK_NAME = QuickGoogle
QuickGoogle_FILES = Tweak.xm
QuickGoogle_FRAMEWORKS = UIKit
QuickGoogle_LDFLAGS = -lactivator

include $(THEOS_MAKE_PATH)/tweak.mk
