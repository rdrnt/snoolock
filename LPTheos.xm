#import "GlobalImports.h"

%hook SBLockScreenViewController
- (BOOL)isBounceEnabledForPresentingController:(id)fp8 locationInWindow:(struct CGPoint)fp12 {
    return NO;
}
%end

%ctor {
	@autoreleasepool {
		LPViewController *_mainPage = [[LPViewController alloc] init];

		[[LPPageController sharedInstance] addPage:_mainPage];
	}
}
