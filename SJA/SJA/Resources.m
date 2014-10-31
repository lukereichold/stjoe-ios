#import "Resources.h"
#import "Map.h"
#import "PBWebViewController.h"
#import "NSURL+SJA.h"
#import "AboutViewController.h"
#import "AboutViewControllerIPAD.h"

@interface Resources ()

@property (strong, nonatomic) PBWebViewController *webController;
@property (strong, nonatomic) NSArray *studentResourceRowTitles;
@property (strong, nonatomic) NSArray *sectionTitles;

- (IBAction)sendFeedback:(id)sender;

@end

@implementation Resources

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = @"Resources";
    self.studentResourceRowTitles = [NSArray arrayWithObjects:@"NetClassroom", @"Blackboard", @"Faculty Access", @"SJA Twitter Feed", nil];
    self.sectionTitles = [NSArray arrayWithObjects:@"Map", @"Students & Faculty", @"", @"", nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return ([SJAUtils isIPAD]) ? YES : UIInterfaceOrientationPortrait;
}

- (void)setBackButtonText:(NSString *)text {
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:text style: UIBarButtonItemStyleBordered target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [self.sectionTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numRows;
    
    if (section == 1) {
        numRows = [self.studentResourceRowTitles count];
    } else if (section == 3) {
        numRows = 2;
    } else {
        numRows = 1;
    }
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    BOOL evenRow = (indexPath.section % 2 == 0);
    cell.textLabel.textColor = evenRow ? [UIColor whiteColor] : [UIColor SJAGreen];
    cell.backgroundColor = evenRow ? [UIColor SJAGreen] : [UIColor whiteColor];
	
    
	switch (indexPath.section) {
		case 0: {
			cell.textLabel.text = @"Local Schools";
			break;}
		case 1: {
            cell.textLabel.text = [self.studentResourceRowTitles objectAtIndex:indexPath.row];
			break;}
        case 2: {
			cell.textLabel.text = @"Daily Bulletin";
			break;}
        case 3: {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"About App";
            } else {
                cell.textLabel.text = @"Send App Feedback";
            }
            break;}
		default:
			return 0;
			break;
	}
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0) {

		Map *myMap = [[Map alloc]initWithNibName:@"Map" bundle:nil];
        [self setBackButtonText:@""];
		[self.navigationController pushViewController:myMap animated:YES];
		
	}
	else if (indexPath.section == 1) {

        switch (indexPath.row) {
            case 0: {
                self.webController = [[PBWebViewController alloc] initWithURL:[NSURL sjaNetClassroom] title:@"NetClassroom"];
                break;}
            case 1: {
                self.webController = [[PBWebViewController alloc] initWithURL:[NSURL sjaBlackboard] title:@"Blackboard"];
                break;}
            case 2: {
                self.webController = [[PBWebViewController alloc] initWithURL:[NSURL sjaFAWeb] title:@"Faculty Access"];
                break;}
            case 3: {
                self.webController = [[PBWebViewController alloc] initWithURL:[NSURL sjaTwitter] title:@"SJA Twitter"];
                break;}
            default:
                break;
        }
        
        [self setBackButtonText:@""];
        [self.navigationController pushViewController:self.webController animated:YES];
	}
    else if (indexPath.section == 2) {
        
        self.webController = [[PBWebViewController alloc] initWithURL:[NSURL sjaBulletin] title:@"Daily Bulletin"];
        [self setBackButtonText:@""];
        [self.navigationController pushViewController:self.webController animated:YES];
	}
    else if (indexPath.section == 3) {
        
        if (indexPath.row == 0) {
            
            if ([SJAUtils isIPAD]) {
                AboutViewControllerIPAD *about = [[AboutViewControllerIPAD alloc] initWithNibName:@"AboutViewControllerIPAD" bundle:nil];
                [self setBackButtonText:@""];
                [self.navigationController pushViewController:about animated:YES];
            }
            else {
                AboutViewController *about = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
                [self setBackButtonText:@""];
                [self.navigationController pushViewController:about animated:YES];
            }
        
        }
        else if (indexPath.row == 1) {
            [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                                    NSForegroundColorAttributeName: [UIColor blackColor],
                                                                    NSFontAttributeName: [UIFont systemFontOfSize:18.0]}];
            [self sendFeedback:self];
        }
	}
    
}

- (IBAction)sendFeedback:(id)sender {
    
    if ([MFMailComposeViewController canSendMail] == YES) {

		MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        [[mailer navigationBar] setTintColor:[UIColor SJAGreen]];
		mailer.mailComposeDelegate = self;
		
		[mailer setSubject:@"St. Joe Feedback"];
		[mailer setMessageBody:@"<p>I have some feedback on the SJA app:</p><br><br><p></p>" isHTML: YES];
		
		[mailer setToRecipients: [NSArray arrayWithObject:@"stjosephsapp@gmail.com"]];
		
		if (mailer !=nil)	{
            [self presentViewController:mailer animated:YES completion:nil];
		}
	}
	else {
		UIAlertView *cannotSendMail = [[UIAlertView alloc]initWithTitle:@"Send Feedback" message:@"You need to have a Mail account set up to use this feature." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[cannotSendMail show];
	}
}

# pragma mark -
# pragma mark MFMailComposeViewControllerDelegate


-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    // Set navigation bar appearance back when closing out mailer
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"CopperplateGothicStd-31BC" size:28]}];
	if (result == MFMailComposeResultSent)	{
		NSLog(@"Message sent!");
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
