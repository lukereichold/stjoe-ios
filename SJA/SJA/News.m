#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kEventsJSONURL [NSURL URLWithString: @"http://luke.gs/sjanews"]

#import "News.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "PBWebViewController.h"

@interface News ()

@property (nonatomic, retain) NSMutableArray *newsTitles;
@property (nonatomic, retain) NSMutableArray *newsLinks;
@property (nonatomic, retain) NSMutableArray *newsDates;

@property (strong, nonatomic) PBWebViewController *webController;
@property (strong, nonatomic) Reachability *reachability;

@end

@implementation News

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        self.newsTitles = [[NSMutableArray alloc] init];
        self.newsLinks = [[NSMutableArray alloc] init];
        self.newsDates = [[NSMutableArray alloc] init];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Load News" message:@"Unable to connect to the news source at this time. Please check your network connection and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)serverConnectionUnsuccessful {
    [SVProgressHUD dismiss];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Load News" message:@"Unable to connect to the news source at this time. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
        for (NSDictionary *event in json) {
            [self.newsTitles addObject: [event objectForKey:@"title"]];
            [self.newsLinks addObject: [event objectForKey:@"url"]];
            [self.newsDates addObject: [event objectForKey:@"date"]];
        }
    }
    
    [SVProgressHUD dismiss];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"SJA News";
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {   // OK/cancel buttons
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return ([SJAUtils isIPAD]) ? YES : (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.newsTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.newsTitles objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
    
    cell.detailTextLabel.text = [self.newsDates objectAtIndex:indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
    
    if ([self.newsLinks objectAtIndex:indexPath.row] == [NSNull null]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.userInteractionEnabled = NO;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.newsLinks objectAtIndex:indexPath.row] != [NSNull null]) {
        
        [self setBackButtonText:@""];
        
        NSString *baseURL = @"http://luke.gs/sja-mobilize-news";
        NSString *specificURL = [self.newsLinks objectAtIndex:indexPath.row];
        NSString *fullURL = [NSString stringWithFormat:@"%@?link=%@", baseURL, specificURL];
        
        self.webController = [[PBWebViewController alloc] initWithURL:[NSURL URLWithString:fullURL] title:@"SJA News"];
        [self.navigationController pushViewController:self.webController animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setBackButtonText:(NSString *)text {
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:text style: UIBarButtonItemStyleBordered target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    [SVProgressHUD dismiss];
}

@end
