include /opt/theos/makefiles/common.mk

TWEAK_NAME = LPTheos
LPTheos_CFLAGS = -fobjc-arc
LPTheos_FILES = LPTheos.xm LPView.m LPViewController.m
LPTheos_FRAMEWORKS = Foundation UIKit QuartzCore
LPTheos_LDFLAGS = -llockpages

include /opt/theos/makefiles/tweak.mk

after-install::
	install.exec "killall -9 backboardd"
SUBPROJECTS += snoolock
include $(THEOS_MAKE_PATH)/aggregate.mk
