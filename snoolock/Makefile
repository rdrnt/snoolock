include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = snoolock
snoolock_FILES = snlRootListController.m
snoolock_INSTALL_PATH = /Library/PreferenceBundles
snoolock_FRAMEWORKS = UIKit
snoolock_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/snoolock.plist$(ECHO_END)
