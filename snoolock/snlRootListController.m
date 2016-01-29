#include "snlRootListController.h"

@protocol PreferencesTableCustomView
- (id)initWithSpecifier:(id)arg1;

@optional
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1;
- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 inTableView:(id)arg2;
@end
@interface SNLCustomHeaderView : UITableViewCell <PreferencesTableCustomView> {
	UILabel *title;
	UILabel *subLabel;
}
@end

@implementation snlRootListController 

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}
-(void)respringDevice {
    UIAlertController *respringAlert=   [UIAlertController
                                    alertControllerWithTitle:@"Snoolock"
                                    message:@"Are you sure you want to respring?"
                                    preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okRespring = [UIAlertAction actionWithTitle:@"Yes"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action) {
                                        system("killall -9 SpringBoard");
                                    }];
    UIAlertAction *cancelRespring = [UIAlertAction actionWithTitle:@"No"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action) {
                                        nil;
                                    }];

        [respringAlert addAction:okRespring];
        [respringAlert addAction:cancelRespring];
        [self presentViewController:respringAlert animated:YES completion:nil];
}
-(void)openTwitter {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetbot:///user_profile/_rdrnt"]];
    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitterrific:///profile?screen_name=_rdrnt"]];
    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetings:///user?screen_name=_rdrnt"]];
    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=_rdrnt"]];
    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://mobile.twitter.com/_rdrnt"]];
}
-(void)sendMail {
    if ([MFMailComposeViewController canSendMail]) {
 
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setToRecipients:@[@"rileyduraant@gmail.com"]];
        [mailViewController setSubject:@"[Snoolock]"];
        [mailViewController setMessageBody:@"" isHTML:NO];
 
        [self presentModalViewController:mailViewController animated:YES];
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewSC {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/rdrnt/snoolock"]];
}

@end

@implementation SNLCustomHeaderView
- (id)initWithSpecifier:(PSSpecifier *)specifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    if (self) {
        int width = [[UIScreen mainScreen] bounds].size.width;
        CGRect titleRect = CGRectMake(0, -15, width, 60);
        CGRect subLabelRect = CGRectMake(0, 20, width, 60);
        
        title = [[UILabel alloc] initWithFrame:titleRect];
        [title setNumberOfLines:1];
        title.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:48];
        [title setText:@"Snoolock"];
        [title setBackgroundColor:[UIColor clearColor]];
        title.textColor = [UIColor colorWithRed:74/255.0f green:74/255.0f blue:74/255.0f alpha:1.0f];
        title.textAlignment = NSTextAlignmentCenter;
        
        subLabel = [[UILabel alloc] initWithFrame:subLabelRect];
        [subLabel setNumberOfLines:1];
        subLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        [subLabel setText:@"Bringing Reddit to your lockscreen."];
        [subLabel setBackgroundColor:[UIColor clearColor]];
        subLabel.textColor = [UIColor colorWithRed:74/255.0f green:74/255.0f blue:74/255.0f alpha:1.0f];
        subLabel.textAlignment = NSTextAlignmentCenter;

        
        [self addSubview:title];
        [self addSubview:subLabel];
        
    }
    return self;
}
@end
