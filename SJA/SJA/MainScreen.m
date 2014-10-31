#import "MainScreen.h"
#import "AppDelegate.h"
#import "Resources.h"
#import "Alumnae.h"
#import "DidYouKnow.h"
#import "News.h"
#import "Kal.h"
#import "AngelPower.h"
#import "Events.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "MKTickerView.h"
#import "CalendarJSONDataSource.h"
#import "NSURL+SJA.h"
#import "NSMutableArray+Shuffling.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface MainScreen ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) CalendarDetailPhone *vc;
@property (strong, nonatomic) Reachability *reachability;

@property (strong, nonatomic) MKTickerView *tickerView;
@property (strong, nonatomic) NSArray *tickerItems;

- (IBAction)loadNews:(id)sender;
- (IBAction)loadResources:(id)sender;
- (IBAction)loadAlumnae:(id)sender;
- (IBAction)loadGame:(id)sender;
- (IBAction)loadAngelPower:(id)sender;
- (IBAction)loadEvents:(id)sender;
- (IBAction)loadCalendar:(id)sender;

@end

@implementation MainScreen


// The following 5 are delegate methods for MKTickerView:
- (UIColor*)backgroundColorForTickerView:(MKTickerView *)vertMenu
{
    return [UIColor SJAGreen];
}

- (int)numberOfItemsForTickerView:(MKTickerView *)tabView
{
    if (self.tickerItems != nil)
        return (int)[self.tickerItems count];
    else
        return 0;
}

- (NSString*)tickerView:(MKTickerView *)tickerView titleForItemAtIndex:(NSUInteger)index
{
    NSDictionary *thisDict = [self.tickerItems objectAtIndex:index];
    return [thisDict objectForKey:@"title"];
}

- (NSString*)tickerView:(MKTickerView *)tickerView valueForItemAtIndex:(NSUInteger)index
{
    return @"";
}

- (UIImage*)tickerView:(MKTickerView*) tickerView imageForItemAtIndex:(NSUInteger) index
{
    NSString *imageFileName = @"blah"; // we don't want an image
    return [UIImage imageNamed:imageFileName];
}

- (void)viewWillAppear:(BOOL)animated   {
    
    double tickerHeight = 30.0;
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
}

- (void)viewWillDisappear:(BOOL)animated {
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
 	kal = [[KalViewController alloc] init];
	kal.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStyleBordered target:self action:@selector(showAndSelectToday)];
	kal.delegate = self;
	dataSource = [[CalendarJSONDataSource alloc] init];
	kal.dataSource = dataSource;
    kal.title = @"Calendar";
	
    [self setBackButtonText:@""];
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
    
    CalendarDetailPhone *vciphone = [[CalendarDetailPhone alloc] initWithEvent:event];
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

    AngelPower *angelPower = [[AngelPower alloc]initWithNibName:@"AngelPower" bundle:nil];
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
    
    DidYouKnow *myGame = [[DidYouKnow alloc]initWithNibName:@"DidYouKnow" bundle:nil];
    [self setBackButtonText:@""];
    [self.navigationController pushViewController:myGame animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = self.contentView.frame.size;
}

- (void)viewDidLoad {
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"St. Joseph's Academy";
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setBackButtonText:(NSString *)text {
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:text style: UIBarButtonItemStyleBordered target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
}


@end
