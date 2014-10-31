#import "Alumnae.h"
#import "PBWebViewController.h"
#import "NSURL+SJA.h"

@interface Alumnae ()

@property (nonatomic, strong) PBWebViewController *webController;
@property (nonatomic, strong) NSArray *rowTitles;

@end

@implementation Alumnae

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Alumnae";
    self.rowTitles = [NSArray arrayWithObjects:@"Alumnae Events", @"Online Event Registration", nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return ([SJAUtils isIPAD]) ? YES : UIInterfaceOrientationPortrait;
}

- (void)setBackButtonText:(NSString *)text {
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:text style: UIBarButtonItemStyleBordered target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.rowTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [self.rowTitles objectAtIndex:indexPath.section];

    BOOL evenRow = (indexPath.section % 2 == 0);
    cell.textLabel.textColor = evenRow ? [UIColor whiteColor] : [UIColor SJAGreen];
    cell.backgroundColor = evenRow ? [UIColor SJAGreen] : [UIColor whiteColor];
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0) {
        self.webController = [[PBWebViewController alloc] initWithURL:[NSURL sjaAlumnaeEvents] title:@"Alumnae Events"];
	} else {
        self.webController = [[PBWebViewController alloc] initWithURL:[NSURL sjaEventRegistration] title:@"Events"];
	}
    
    [self setBackButtonText:@""];
    [self.navigationController pushViewController:self.webController animated:YES];
}

@end
