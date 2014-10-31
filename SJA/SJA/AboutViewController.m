#import "AboutViewController.h"
#import "NSURL+SJA.h"

@interface AboutViewController ()

@property (nonatomic, retain) IBOutlet UILabel *nameAndVersionLabel;

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.title = @"About the App";
    self.view.backgroundColor = [UIColor SJALightGreen];
    self.nameAndVersionLabel.font = [UIFont fontWithName:@"CopperplateGothicStd-31BC" size:36];
    [super viewDidLoad];
}

- (IBAction)openPersonalSite {
    [[UIApplication sharedApplication] openURL:[NSURL sjaPersonalSite]];
}

- (IBAction)openSJAsite {
    [[UIApplication sharedApplication] openURL:[NSURL sjaWebsite]];
}

@end
