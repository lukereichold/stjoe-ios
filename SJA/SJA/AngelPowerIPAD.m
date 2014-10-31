#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kEventsJSONURL [NSURL URLWithString: @"http://luke.gs/sjaangels"]

#import "AngelPowerIPAD.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#import "Reachability.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface AngelPowerIPAD ()

@property (nonatomic, strong) NSString *photoURL;
@property (nonatomic, strong) NSString *angelName;
@property (nonatomic, strong) NSString *angelDescription;

@property (nonatomic, strong) IBOutlet UITextView *angelDescriptionViewPortrait;
@property (nonatomic, strong) IBOutlet UITextView *angelDescriptionViewLandscape;
@property (nonatomic, strong) IBOutlet UILabel *angelNameLabel;
@property (nonatomic, assign) CGRect portraitNameFrame;
@property (nonatomic, assign) CGRect landscapeNameFrame;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGRect portraitImageFrame;
@property (nonatomic, assign) CGRect landscapeImageFrame;

@property (nonatomic) Reachability *reachability;

@end

@implementation AngelPowerIPAD

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.portraitImageFrame = CGRectMake(256, 47, 255, 255);
        self.landscapeImageFrame = CGRectMake(109, 62, 198, 198);
        self.portraitNameFrame = CGRectMake(0, 306, 768, 118);
        self.landscapeNameFrame = CGRectMake(340, 120, 650, 85);
        
        self.angelName = @"";
        self.angelDescription = @"";
        [self.angelNameLabel setText:self.angelName];
        [self.angelDescriptionViewLandscape setText:self.angelDescription];
        [self.angelDescriptionViewPortrait setText:self.angelDescription];
        self.photoURL = @"";
        
        [SVProgressHUD showWithStatus:@"Loading.."];
        
        self.reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [self.reachability currentReachabilityStatus];

        if (networkStatus != NotReachable) {
            
            dispatch_async(kBgQueue, ^{
                NSData* data = [NSData dataWithContentsOfURL:kEventsJSONURL];
                
                if (data) {
                    [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
                } else {
                    [SVProgressHUD dismiss];
                }
            });
        } else {
            [SVProgressHUD dismiss];
            [self networkConnectionUnsuccessful];
        }
    }
    return self;
}

- (void)fetchedData:(NSData *)responseData {
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    if (!json) {
        NSLog(@"Error parsing JSON: %@ %@", error, [error userInfo]);
        [self serverConnectionUnsuccessful];
    } else {
        
        self.angelName = [json objectForKey:@"name"];
        self.angelDescription = [json objectForKey:@"description"];
        self.photoURL = [json objectForKey:@"photoURL"];
        
        // Now set these!
        self.angelNameLabel.text = self.angelName;
        self.angelDescriptionViewLandscape.text = self.angelDescription;
        self.angelDescriptionViewPortrait.text = self.angelDescription;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.photoURL] placeholderImage:nil];
    }
    
    [SVProgressHUD dismiss];
}

- (void)serverConnectionUnsuccessful {
    [SVProgressHUD dismiss];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Load Angel Power" message:@"Unable to connect to the Angel Power data source at this time. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)networkConnectionUnsuccessful {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Load Angel Power" message:@"Unable to connect to the Angel Power data source at this time. Please check your network connection and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    self.title = @"Angel Power";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor SJADarkBackgroundGreen];
    
    [self.angelNameLabel setFont:[UIFont fontWithName:@"Gotham" size:24]];
    self.angelNameLabel.adjustsFontSizeToFitWidth = YES;
    self.angelNameLabel.numberOfLines = 1;

    self.imageView = [[UIImageView alloc] init];
    [self.view addSubview:self.imageView];
}

-(void)viewWillAppear:(BOOL)animated {
    
    if ([SJAUtils isLandscape:self.interfaceOrientation]) {
        [self layoutViewsForLandscape];
    } else {
        [self layoutViewsForPortrait];
    }
}

- (void)layoutViewsForLandscape {
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"angelPadLandscape.png"]];
    self.imageView.frame = self.landscapeImageFrame;
    self.angelNameLabel.frame = self.landscapeNameFrame;
    self.angelNameLabel.textColor = [UIColor SJAGreen];
    
    [self.angelDescriptionViewLandscape setHidden:NO];
    [self.angelDescriptionViewPortrait setHidden:YES];
}

- (void)layoutViewsForPortrait {
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"angelPadPortrait.png"]];
    self.imageView.frame = self.portraitImageFrame;
    self.angelNameLabel.frame = self.portraitNameFrame;
    self.angelNameLabel.textColor = [UIColor SJAGold];
    
    [self.angelDescriptionViewLandscape setHidden:YES];
    [self.angelDescriptionViewPortrait setHidden:NO];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

    if ([SJAUtils isLandscape:toInterfaceOrientation]) {
        [self layoutViewsForLandscape];
    } else {
        [self layoutViewsForPortrait];
    }
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {   // OK/cancel buttons
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [SVProgressHUD dismiss];
}

@end
