#import "MainScreenIPAD.h"
#import "AppDelegate.h"
#import "Resources.h"
#import "Alumnae.h"
#import "DYKiPad.h"
#import "News.h"
#import "Kal.h"
#import "AngelPowerIPAD.h"
#import "Events.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "MKTickerView.h"
#import "NSURL+SJA.h"
#import "CalendarJSONDataSource.h"
#import "CalendarDetailPad.h"
#import "NSMutableArray+Shuffling.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface MainScreenIPAD ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonsCollection;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) Reachability *reachability;
@property (nonatomic, retain) CalendarDetailPad *vc;

@property (strong, nonatomic) MKTickerView *tickerView;
@property (strong, nonatomic) NSArray *tickerItems;

@property (strong, nonatomic) NSArray *bkgImagesLandscape;
@property (strong, nonatomic) NSArray *bkgImagesPortrait;

- (IBAction)loadNews:(id)sender;
- (IBAction)loadResources:(id)sender;
- (IBAction)loadAlumnae:(id)sender;
- (IBAction)loadGame:(id)sender;
- (IBAction)loadAngelPower:(id)sender;
- (IBAction)loadEvents:(id)sender;
- (IBAction)loadCalendar:(id)sender;

@end

@implementation MainScreenIPAD


// The following 5 are delegate methods for MKTickerView:
// Note: to get this Ticker to refresh every new time I open up the view, I'm removing the current MKTickerView, killing it, and adding a new one (with new data) in viewWillAppear.

- (UIColor*) backgroundColorForTickerView:(MKTickerView *)vertMenu
{
    return [UIColor SJAGreen];
}

- (int) numberOfItemsForTickerView:(MKTickerView *)tabView
{
    if (self.tickerItems != nil)
        return (int)[self.tickerItems count];
    else
        return 0;
}

- (NSString*) tickerView:(MKTickerView *)tickerView titleForItemAtIndex:(NSUInteger)index
{
    NSDictionary *thisDict = [self.tickerItems objectAtIndex:index];
    return [thisDict objectForKey:@"title"];
}

- (NSString*) tickerView:(MKTickerView *)tickerView valueForItemAtIndex:(NSUInteger)index
{
    return @"";
}

- (UIImage*) tickerView:(MKTickerView*) tickerView imageForItemAtIndex:(NSUInteger) index
{
    NSString *imageFileName = @"blah";  //send BS link, we don't want an image
    return [UIImage imageNamed:imageFileName];
}

- (void)viewWillAppear:(BOOL)animated   {
    
    double tickerHeight = 35.0;
    self.tickerView = [[MKTickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - tickerHeight, self.view.frame.size.width, tickerHeight)];
    self.tickerView.backgroundColor = [UIColor SJAGreen];
    
    self.tickerView.dataSource = self;
    self.tickerView.delegate = self;
    
    [self.view addSubview:self.tickerView];
    
    self.tickerView.userInteractionEnabled = NO;
    self.tickerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus networkStatus = [self.reachability currentReachabilityStatus];
    if (networkStatus != NotReachable) {
        
        dispatch_async(kBgQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL:[NSURL sjaTickerItems]];
            
            if (data) {
                [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
            }
        });
    }
    
    [self layoutPanelsGenericForDesiredOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void)viewWillDisappear:(BOOL)animated    {
    
    [self.tickerView removeFromSuperview];
    self.tickerView = nil;
    self.tickerItems = nil;
}

- (void)fetchedData:(NSData *)responseData {
    
    NSError* e = nil;
    NSMutableArray* data = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&e];
    [data shuffle];
    
    if (data.count > 0) {
        self.tickerItems = data;
        [self.tickerView reloadData];
    }
}

- (IBAction)loadCalendar:(id)sender
{
 	kal = [[KalViewController alloc]init];
	kal.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStyleBordered target:self action:@selector(showAndSelectToday)];
	kal.delegate = self;
	dataSource = [[CalendarJSONDataSource alloc]init];
	kal.dataSource = dataSource;
    kal.title = @"Calendar";

	UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style: UIBarButtonItemStyleBordered target: nil action:nil];
	[[self navigationItem] setBackBarButtonItem:newBackButton];

	[self.navigationController pushViewController:kal animated:YES];
}

// Action handler for the navigation bar's right bar button item.
- (void)showAndSelectToday
{
	[kal showAndSelectDate:[NSDate date]];
}

#pragma mark UITableViewDelegate protocol conformance

// Display a details screen for the selected event/row.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	Calendar *event = [dataSource eventAtIndexPath:indexPath];

    CalendarDetailPad *vciphone = [[CalendarDetailPad alloc]initWithEvent:event];
    [self setBackButtonText:@""];
    [self.navigationController pushViewController:vciphone animated:YES];
}

- (IBAction)loadNews:(id)sender {
    
    [self setBackButtonText:@""];
    News *newsTable = [[News alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:newsTable animated:YES];
}

- (IBAction)loadEvents:(id)sender {
    
    Events *events = [[Events alloc] initWithStyle:UITableViewStyleGrouped];
    [self setBackButtonText:@""];
    [self.navigationController pushViewController:events animated:YES];
}

- (IBAction)loadAngelPower:(id)sender {
    
    AngelPowerIPAD *angelPower = [[AngelPowerIPAD alloc]initWithNibName:@"AngelPowerIPAD" bundle:nil];
    [self setBackButtonText:@""];
    [self.navigationController pushViewController:angelPower animated:YES];
}

- (IBAction)loadResources:(id)sender {
    
    Resources *myResources = [[Resources alloc]initWithNibName:@"Resources" bundle:nil];
    [self setBackButtonText:@""];
    [self.navigationController pushViewController:myResources animated:YES];
}

- (IBAction)loadAlumnae:(id)sender {
    
    Alumnae *myAlumnae = [[Alumnae alloc]initWithNibName:@"Alumnae" bundle:nil];
    [self setBackButtonText:@""];
    [self.navigationController pushViewController:myAlumnae animated:YES];
}

- (IBAction)loadGame:(id)sender {
    
    DYKiPad *myGame = [[DYKiPad alloc]initWithNibName:@"DYKiPad" bundle:nil];
    [self setBackButtonText:@""];
    [self.navigationController pushViewController:myGame animated:YES];
}

- (void)layoutPanelsGenericForDesiredOrientation:(UIInterfaceOrientation)orientation {
    
    CGFloat scrollViewWidth;
    CGFloat scrollViewHeight;
    CGFloat contentViewHeight;
    CGFloat buttonHeight;
    NSArray *imageArray = ([SJAUtils isLandscape:orientation]) ? self.bkgImagesLandscape : self.bkgImagesPortrait;

    if ([SJAUtils isLandscape:orientation]) {
        scrollViewWidth = 1024;
        scrollViewHeight = 674;
        contentViewHeight = 1050;
        buttonHeight = 150;
    } else {
        scrollViewWidth = 768;
        scrollViewHeight = 930;
        contentViewHeight = scrollViewHeight;
        buttonHeight = 132;
    }
    
    self.scrollView.frame = CGRectMake(0, 0, scrollViewWidth, scrollViewHeight);
    self.contentView.frame = CGRectMake(0, 0, scrollViewWidth, contentViewHeight);
    self.scrollView.contentSize = self.contentView.frame.size;
    
    for (UIButton *button in self.buttonsCollection) {
        
        CGRect tempFrame = button.frame;
        tempFrame.origin.y = button.tag * buttonHeight;
        tempFrame.size.width = scrollViewWidth;
        tempFrame.size.height = buttonHeight;
        button.frame = tempFrame;
        
        [button setBackgroundImage:[UIImage imageNamed:[imageArray objectAtIndex:button.tag]] forState:UIControlStateNormal];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    UIInterfaceOrientation newOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self layoutPanelsGenericForDesiredOrientation:newOrientation];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"St. Joseph's Academy";
    
    self.bkgImagesLandscape = [NSArray arrayWithObjects: @"Events_iPad_L.png", @"Angel-Power_iPad_L.png", @"Calendar_iPad_L.png", @"Alumnae_iPad_L.png", @"In-the-Know_iPad_L.png", @"News_iPad_L.png", @"Resources_iPad_L.png", nil];
    
    self.bkgImagesPortrait = [NSArray arrayWithObjects: @"Events_iPad_P.png", @"Angel-Power_iPad_P.png", @"Calendar_iPad_P.png", @"Alumnae_iPad_P.png", @"In-the-Know_iPad_P.png", @"News_iPad_P.png", @"Resources_iPad_P.png", nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)setBackButtonText:(NSString *)text {
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:text style: UIBarButtonItemStyleBordered target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
}


@end
