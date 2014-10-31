#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kEventsJSONURL [NSURL URLWithString: @"http://luke.gs/intheknowfacts"]

#import "DidYouKnow.h"
#import <stdlib.h>
#import <time.h>
#import "Reachability.h"

@interface DidYouKnow ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *funFactLabel;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *facts;

@property (strong, nonatomic) Reachability *reachability;

@end

@implementation DidYouKnow

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.facts = [[NSMutableArray alloc] init];
        
        self.reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [self.reachability currentReachabilityStatus];
        
        if (networkStatus != NotReachable) {
            
            dispatch_async(kBgQueue, ^{
                NSData *data = [NSData dataWithContentsOfURL:kEventsJSONURL];
                
                if (data) {
                    [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
                }
            });
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
    
    if (json) {
        NSArray* webFacts = [json objectForKey:@"facts"];
        self.facts = [webFacts mutableCopy];
    }
}

- (void)viewDidLoad {
	
	self.navigationItem.title = @"In the Know";
    [self createBackgroundGradientWithTopColor:[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1] bottomColor:[UIColor SJALightGreen]];
    
    [self.titleLabel setFont:[UIFont fontWithName:@"CopperplateGothicStd-31BC" size:24]];
	
	[self.imageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
	[self.imageView.layer setBorderWidth: .5];
    
    self.facts =  [NSMutableArray arrayWithObjects: @"St. Joseph’s Academy is sponsored by the Sisters of St. Joseph of Carondelet and was founded in 1840.", @"October 15 is known as Founders Day because Father Jean Pierre Medaille, a Jesuit, and Bishop Henry de Maupas founded the Sisters of St. Joseph of Carondelet in Le Puy, France.", @"In 1836 Mother St. John Fontbonne, superior of the Sisters of St. Joseph in France, sent six young women to the New World to teach. They journeyed to the Diocese of St. Louis and established a log cabin school in the village of Carondelet named \"Mother Celestine’s School.\"", @"In 1840 Mother Celestine’s School was renamed St. Joseph’s Academy. Mother Celestine Pommerel was the first principal.", @"In 1840 the sisters had six deaf-mutes, 19 orphan girls and seven boarders in their care. The seven boarders are the nucleus of what would become the modern day St. Joseph’s Academy.", @"From 1841 to 1925 the first wing of the academy was built on the original site at 6400 Minnesota Avenue, St. Louis, MO, and a combined boarding and day school was opened.", @"In 1925 St. Joseph’s Academy was transferred to the Fontbonne College Campus at Wydown and Big Bend. Enrollment was up to 100 students.", @"In 1945 the Sisters of St. Joseph purchased 37 acres of ground in Frontenac, MO on Lindbergh Blvd at Litzsinger Rd. Enrollment jumped from 100 students to more than 380 students.", @"In 1955 the first classes were held at the new St. Joseph’s Academy campus in Frontenac.", @"St. Joseph’s Academy is one of the largest all-girl schools in Missouri, serving more than 600 students.", @"In 2005 St. Joseph’s Academy was named Best High School Athletic Program in the State of Missouri by Sports Illustrated magazine.", @"A lamp of knowledge above the seal lights your pathway in the quest for truth. The lily represents the sisters of St. Joseph of Carondelet who have sponsored SJA since 1840.  And an ancient legend relates that Saint Joseph’s staff blossomed into a sheaf of lilies as a sign that he was the chosen spouse of the Blessed Virgin Mary.", @"The school colors are green and white. White is the symbol of purity and green is the standard of fidelity to truth and knowledge.", @"The school motto is \"Not I, But We.\"", @"In 1974, Sister Mary de Paul Berra, president and principal of the Academy coined this phrase and soon after it became the school motto.", @"In 2011, St. Joseph’s Academy students raised $50,000 during Mission Week.", @"Mission Week at SJA has been a tradition for over 50 years. Students work diligently for one week in November to raise funds for the Sisters of St. Joseph’s missions in Peru and Uganda as well as raising funds for mission projects close to home.", @"Students at St. Joseph’s Academy come from 73 parishes and 50 zip codes.", @"Anita Reznicek, President of St. Joseph’s Academy, is the first lay president at SJA since it was founded in 1840.", @"100% of St. Joseph’s Academy students attend a college or university.", @"SJA offers world language classes in Spanish, Latin, French and Mandarin Chinese.", @"Each student at SJA has a laptop to optimize her academic experience at the academy.", @"Anita Reznicek, President of St. Joseph’s Academy is a published author and expert on single-sex education.  The title of her book is Educating our Daughters: 15 Considerations of Selecting the Best School Environment.", @"St. Joseph’s Academy develops values-driven women leaders.", @"St. Joseph's Academy is a college preparatory high school sponsored by the Sisters of St. Joseph of Carondelet. Our mission at the Academy is to provide quality Catholic education for young women in an environment that challenges them to grow in faith, knowledge, and respect for self and others.", @"In 2004, new facilities on campus opened, which include a state of the art gym and physical training center, a 700 seat fine arts theater, a new guidance department complex, four additional classrooms, and a student commons.", @"The St. Joseph’s Academy Faculty includes 58 certified professionals, 39 teachers have master’s degrees and 2 hold a doctorate.", @"St. Joseph’s Academy physical education teacher Maureen McVey will be the first woman inducted into the St. Louis Soccer Hall of Fame on September 27, 2012 at the Millennium Hotel in St. Louis. Maureen has been a teacher and coach at SJA from 1994 to present. Her career record is 485-112-41.", @"In 2011 Karen Davis, Assistant Principal and Volleyball Coach at SJA, was inducted into the Missouri Valley High School Volleyball Coaches Association.", @"In an effort to \"serve the dear neighbor without distinction\", the Sisters of St. Joseph of Carondelet offered in-need women from the community of Le Puy, France an opportunity to work as lace-makers.  It offered a source of livelihood for our sisters and the women that they helped.", @"248 Students at St. Joseph’s Academy take Advanced Placement and College Credit Courses in English, History, Science, Technology, World Languages and Math.", @"The average ACT score at SJA is 26.", @"In the 2011-2012 school year, St. Joe students and faculty completed over 8,000 hours of service to the dear neighbor.", @"The Class of 2012 received 349 scholarships for a 1 year total of $2,712,265.  For four years this total comes to $10,849,060.", @"During the 2011-2012 school year the SJA community prepared and served 2,700 meals for the Soup Kitchen and the Homeless Shelter of St. Peter and St. Paul Parish.", nil];
    
	[self shuffleFacts];
    [super viewDidLoad];
}

- (IBAction)shuffleFacts {
	NSLog(@"Shuffling..");
    
	int random = arc4random() % [self.facts count];
	
	//Formatting the label based on the length of the fact
	self.funFactLabel.text = [self.facts objectAtIndex:random];
    self.funFactLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.funFactLabel setTextColor:[UIColor blackColor]];
	
    CGSize expectedLabelSize = [[self.facts objectAtIndex:random] sizeWithFont:self.funFactLabel.font
                                                             constrainedToSize:self.funFactLabel.frame.size
                                                                 lineBreakMode:NSLineBreakByWordWrapping];
	
    CGRect newFrame = self.funFactLabel.frame;
    newFrame.size.height = expectedLabelSize.height;
	newFrame.size.width = 300;
    self.funFactLabel.frame = newFrame;
    self.funFactLabel.numberOfLines = 0;
    [self.funFactLabel sizeToFit];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
	if (event.subtype == UIEventSubtypeMotionShake) {
		[self shuffleFacts];
	}
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self becomeFirstResponder];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown);
}

- (void)createBackgroundGradientWithTopColor:(UIColor*)topColor bottomColor:(UIColor*)bottomColor {
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.frame;
    gradient.colors = [NSArray arrayWithObjects:(id)[topColor CGColor], (id)[bottomColor CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

@end