#import "GlobalImports.h"


//global variables
NSMutableArray *jsonTitleData, *jsonDataID, *jsonScoreData, *jsonUsernameData;
NSString *settingsPath = @"/var/mobile/Library/Preferences/com.rdrnt.snoolock.plist";
@implementation LPViewController
-(id)init{
    self = [super init];
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
     if ([[prefs objectForKey:@"enabled"] boolValue] == NO || [prefs objectForKey:@"enabled"] == nil) {
        nil;
    }
    if ([[prefs objectForKey:@"enabled"] boolValue] == YES || [prefs objectForKey:@"enabled"] == nil) {

    if (self) {
        HBLogInfo(@"Loaded!");

        //getting how many cells are enabled
        int cellCount = [prefs objectForKey:@"cellNums"] ? [[prefs objectForKey:@"cellNums"] intValue] : 10;
        HBLogInfo(@"User has %i cells desired.", cellCount);
        int newWidth = [UIScreen mainScreen].bounds.size.width - 10;
        int newHeight = [UIScreen mainScreen].bounds.size.height-10;

        CGRect viewFrame = CGRectMake(([UIScreen mainScreen].bounds.size.width - newWidth) /2 ,([UIScreen mainScreen].bounds.size.height - newHeight) /2,newWidth,newHeight -20 );
        __mainView = [[LPView alloc] initWithFrame:viewFrame];
        [__mainView setDelegate:self];
        [__mainView.layer setCornerRadius:25.0f];
        [__mainView.layer setMasksToBounds:YES];
        __mainView.backgroundColor = [UIColor clearColor];
        __mainView.center = CGPointMake([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
        [self setView:__mainView];

        CGRect tableViewFrame = CGRectMake(0,70 ,newWidth,newHeight);
        UITableView *tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
        [tableView setContentInset:UIEdgeInsetsMake(0, 0, 100, 0)];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        if ([[prefs objectForKey:@"blurEnabled"] boolValue] == YES || [prefs objectForKey:@"blurEnabled"] == nil) {
            UIBlurEffect *blur  = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
            effectView.frame = viewFrame;
            [__mainView addSubview:effectView];
        }
        if ([[prefs objectForKey:@"blurEnabled"] boolValue] == NO || [prefs objectForKey:@"blurEnabled"] == nil) {
        }

        if (prefs[@"subredditTitle"] == nil || [prefs[@"subredditTitle"] isEqual:@""]) {
            UIAlertController *noSubAlert=   [UIAlertController
                                    alertControllerWithTitle:@"My Title"
                                    message:@"Enter User Credentials"
                                    preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *noSubAlertButton = [UIAlertAction actionWithTitle:@"Got it"
                style:UIAlertActionStyleDefault
                handler:^(UIAlertAction *action) {
                    nil;
                }];

            [noSubAlert addAction:noSubAlertButton];
            [self presentViewController:noSubAlert animated:YES completion:nil];
          }

        NSString *currentSubreddit = [NSString stringWithFormat:@"%@", prefs[@"subredditTitle"]];

        CGRect labelFrame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 200) /2 ,10, 200, 50);
        UILabel *subredditLabel = [[UILabel alloc] initWithFrame:labelFrame];
        if (currentSubreddit == nil || [currentSubreddit isEqual:@""]) {
        currentSubreddit = [NSString stringWithFormat:@"All"];
        }
        [subredditLabel setText:currentSubreddit];
        subredditLabel.textColor = [UIColor whiteColor];
        subredditLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:30];
        subredditLabel.textAlignment = NSTextAlignmentCenter;


        [__mainView addSubview:subredditLabel];
        [__mainView addSubview:tableView];

        [tableView reloadData];
        [self getJSONData];
        
        }
    }

    return self;
}

- (NSInteger)priority {
	return 10; 
}
-(void) getJSONData {
    jsonTitleData = [[NSMutableArray alloc] init];
    jsonScoreData = [[NSMutableArray alloc] init];
    jsonUsernameData = [[NSMutableArray alloc] init];
    jsonDataID = [[NSMutableArray alloc] init];

    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    int cellCount = [prefs objectForKey:@"cellNums"] ? [[prefs objectForKey:@"cellNums"] intValue] : 10;

    NSString *subDesired = [NSString stringWithFormat:@"%@", prefs[@"subredditTitle"]];
    if (subDesired == nil || [subDesired isEqual:@""]) {
        subDesired = [NSString stringWithFormat:@"all"];
    }
    HBLogInfo(@"The subreddit is %@", subDesired);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.reddit.com/r/%@.json", subDesired]];
    NSData *jsonerData = [NSData dataWithContentsOfURL:url];
    NSError *jsonDataError = nil;
    if (jsonDataError){
        HBLogInfo(@"Error parsing json....");
    }
    NSError *jsonError = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonerData options:0 error:&jsonError];
    for (int x = 1; x <= cellCount; x++) {
        [jsonTitleData addObject:json[@"data"][@"children"][x][@"data"][@"title"]]; 
        [jsonDataID addObject:json[@"data"][@"children"][x][@"data"][@"id"]]; 
        [jsonScoreData addObject:json[@"data"][@"children"][x][@"data"][@"score"]]; 
        [jsonUsernameData addObject:json[@"data"][@"children"][x][@"data"][@"author"]]; 
        }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    int cellCount = [prefs objectForKey:@"cellNums"] ? [[prefs objectForKey:@"cellNums"] intValue] : 10;

    return cellCount;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIden = @"CellIdentifier";

    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIden];
    }

    //Cell appearence
    cell.backgroundColor = [UIColor clearColor];
    UIView *cellBG = [[UIView alloc] init];
    cellBG.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView =cellBG;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];

    //cell text
    cell.textLabel.text = [jsonTitleData objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Posted by %@, with %@ score.", [jsonUsernameData objectAtIndex:indexPath.row],  [jsonScoreData objectAtIndex:indexPath.row]];


    if ([[prefs objectForKey:@"blackText"] boolValue] == YES || [prefs objectForKey:@"blackText"] == nil) {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    else if ([[prefs objectForKey:@"blackText"] boolValue] == NO || [prefs objectForKey:@"blackText"] == nil) {
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }




    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    NSString *subDesired = [NSString stringWithFormat:@"%@", prefs[@"subredditTitle"]];
    if (subDesired == nil || [subDesired isEqual:@""]) {
        subDesired = [NSString stringWithFormat:@"all"];
    }
    NSString *url = [NSString stringWithFormat:@"https://www.reddit.com/r/%@/%@", subDesired, [jsonDataID objectAtIndex:indexPath.row]];
    SFSafariViewController *sfVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url] entersReaderIfAvailable:NO];
    [self presentViewController:sfVC animated:YES completion:nil];
}

@end


