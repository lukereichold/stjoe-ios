#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kEventsJSONURL [NSURL URLWithString: @"http://luke.gs/sjaangels"]

#import "AngelPower.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#import "Reachability.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface AngelPower ()

@property (nonatomic, strong) NSString *photoURL;
@property (nonatomic, strong) NSString *angelName;
@property (nonatomic, strong) NSString *angelDescription;

@property (nonatomic, assign) CGRect imageViewFrame;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *angelNameLabel;
@property (nonatomic, strong) IBOutlet UITextView *angelDescriptionView;

@property (strong, nonatomic) Reachability *reachability;

@end

@implementation AngelPower

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.imageViewFrame = CGRectMake(105, 21, 110, 110);
        self.angelName = @"";
        self.angelDescription = @"";
        [self.angelNameLabel setText:self.angelName];
        [self.angelDescriptionView setText:self.angelDescription];
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
        self.angelDescriptionView.text = self.angelDescription;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Angel Power";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor SJADarkBackgroundGreen];
    
    [self.angelNameLabel setFont:[UIFont fontWithName:@"Gotham" size:24]];
    self.angelNameLabel.adjustsFontSizeToFitWidth = YES;
    self.angelNameLabel.numberOfLines = 1;
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = self.imageViewFrame;
    [self.view addSubview:self.imageView];
}

- (void)viewDidLayoutSubviews {
    CGFloat bottomPadding = 10.0;
    CGRect currFrame = self.angelDescriptionView.frame;
    currFrame.size.height = self.view.frame.size.height - currFrame.origin.y - bottomPadding;
    self.angelDescriptionView.frame = currFrame;
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
