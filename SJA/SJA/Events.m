#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kEventsJSONURL [NSURL URLWithString: @"http://luke.gs/sjajsonevents"]

#import "Events.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "PopupAlertView.h"
#import "UIViewController+MJPopupViewController.h"

@interface Events () <MainScreenDelegate>

@property (nonatomic, retain) NSMutableArray *eventTitles;
@property (nonatomic, retain) NSMutableArray *eventDescriptions;
@property (nonatomic, retain) PopupAlertView *popup;

@property (strong, nonatomic) Reachability *reachability;

@end

@implementation Events

- (id)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    if (self) {
        
        self.eventTitles = [[NSMutableArray alloc] init];
        self.eventDescriptions = [[NSMutableArray alloc] init];
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

- (void)networkConnectionUnsuccessful {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Load Events" message:@"Unable to connect to the events source at this time. Please check your network connection and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)serverConnectionUnsuccessful {
    [SVProgressHUD dismiss];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Load Events" message:@"Unable to connect to the events source at this time. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
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
        
        NSArray* events = [json objectForKey:@"events"];
        
        for (NSDictionary *event in events) {
            [self.eventTitles addObject: [event objectForKey:@"title"]];
            [self.eventDescriptions addObject: [event objectForKey:@"description"]];
        }
    }
    
    [SVProgressHUD dismiss];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Upcoming Events";
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {   // OK/cancel buttons
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)cancelButtonClicked:(PopupAlertView *)aSecondDetailViewController {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    self.popup = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return ([SJAUtils isIPAD]) ? YES : (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.eventTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.eventTitles objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];

    if ([self.eventDescriptions objectAtIndex:indexPath.row] == [NSNull null]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.userInteractionEnabled = NO;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0) ? @"Events At a Glance" : nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.eventDescriptions objectAtIndex:indexPath.row] != [NSNull null]) {

        self.popup = nil;
        
        NSString *nibName = ([SJAUtils isIPAD]) ? @"PopupAlertViewIPAD" : @"PopupAlertView";
        self.popup = [[PopupAlertView alloc]initWithNibName:nibName bundle:nil];
        self.popup.delegate = self;
        
        [self presentPopupViewController:self.popup animationType:MJPopupViewAnimationSlideBottomBottom];
        [self.popup setMessageText:[self.eventDescriptions objectAtIndex:indexPath.row]];
        [self.popup setTitleText:[self.eventTitles objectAtIndex:indexPath.row]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [SVProgressHUD dismiss];
}

@end
