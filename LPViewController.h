#import "GlobalImports.h"

@interface LPViewController : UIViewController <LPPage, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
}	 // Remember to set LPPage protocol here.
@property (nonatomic, retain) LPView *_mainView; 		 // Create and istance of LPView.
@end
