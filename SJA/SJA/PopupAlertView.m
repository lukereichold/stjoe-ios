#import "PopupAlertView.h"

@interface PopupAlertView ()

@end

@implementation PopupAlertView

@synthesize delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)closePopup:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        [self.delegate cancelButtonClicked:self];
    }
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor SJALightGreen];
    
    self.view.layer.cornerRadius = 7.0;
    self.view.layer.masksToBounds = YES;
    self.view.alpha = 0.5f;
    
    [super viewDidLoad];
}

- (void)setTitleText:(NSString *)message {
    messageTitleLabel.text = message;
}

- (void)setMessageText:(NSString *)message   {
    messageTextView.text = message;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
