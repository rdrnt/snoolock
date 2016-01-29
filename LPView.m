#import "GlobalImports.h"

@implementation LPView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void)setDelegate:(id<LPPage>)_delegate {
	self->_page = _delegate;
}

@end
