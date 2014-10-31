#import "Map.h"
#import "PBWebViewController.h"

@interface Map ()

@property (nonatomic, strong) PBWebViewController *webController;
@property (nonatomic, strong) IBOutlet MKMapView *myMapView;

@end

@implementation Map

@synthesize coordinate;

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation {
	
    MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    customPinView.canShowCallout = YES;
    
    customPinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    customPinView.pinColor = (annotation == sja) ? MKPinAnnotationColorRed : MKPinAnnotationColorGreen;
	
    customPinView.animatesDrop = YES;
    customPinView.canShowCallout = YES;
	
    return customPinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control  {
    
    NSString* address = view.annotation.subtitle;
    NSString* url = [NSString stringWithFormat: @"http://maps.apple.com/maps?daddr=%@",
                     [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    NSLog(@"callout annotation.title = %@", view.annotation.title);
}

- (void)viewDidLoad {
	self.navigationItem.title = @"Local Schools";
	
	// CLLocationCoordinate2D coordinate;
	coordinate.latitude = 38.628056;
	coordinate.longitude = -90.4002212;
    
    if ([SJAUtils isIPAD])  {
        self.myMapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 4000, 14000);
    } else {
        self.myMapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 16000, 24000);
	}
    
    self.myMapView.delegate = self;
	self.myMapView.mapType = MKMapTypeHybrid;
	
	[self.view addSubview:self.myMapView];
    
	[self addAnnotations];
	[super viewDidLoad];
}

- (void)addAnnotations	{
	
	//Add SJA to map
	CLLocationCoordinate2D sjaCoordinate = {38.625135, -90.40688};
	sja = [[AdoptAnnotation alloc]initWithCoordinates:sjaCoordinate placeName:@"St. Joseph's Academy" description:@"2307 South Lindbergh Blvd 63131"];
    [self.myMapView addAnnotation:sja];
    
	//Add Ursuline to map
	CLLocationCoordinate2D myCoordinate = {38.5775529, -90.3878955};
	AdoptAnnotation *ursuline = [[AdoptAnnotation alloc]initWithCoordinates:myCoordinate placeName:@"Ursuline Academy" description:@"341 South Sappington Rd 63122"];
	[self.myMapView addAnnotation:ursuline];
    
    //Add Nerinx to map
	myCoordinate.latitude = 38.590896;
	myCoordinate.longitude = -90.339975;
	AdoptAnnotation *nerinx = [[AdoptAnnotation alloc]initWithCoordinates:myCoordinate placeName:@"Nerinx Hall High School" description:@"530 E Lockwood Ave 63119"];
    [self.myMapView addAnnotation:nerinx];

	//Add Cor Jesu to map
	myCoordinate.latitude = 38.547817;
	myCoordinate.longitude = -90.345537;
	AdoptAnnotation *corjesu = [[AdoptAnnotation alloc]initWithCoordinates:myCoordinate placeName:@"Cor Jesu Academy" description:@"10230 Gravois Rd 63123"];
	[self.myMapView addAnnotation:corjesu];
	
	//Add Rosati-Kain to map
	myCoordinate.latitude = 38.6416669;
	myCoordinate.longitude = -90.2539871;
	AdoptAnnotation *rosati = [[AdoptAnnotation alloc]initWithCoordinates:myCoordinate placeName:@"Rosati-Kain High School" description:@"4389 Lindell Blvd 63108"];
	[self.myMapView addAnnotation:rosati];
    
	//Add John Burroughs to map
	myCoordinate.latitude = 38.643336;
	myCoordinate.longitude = -90.366823;
	AdoptAnnotation *jburroughs = [[AdoptAnnotation alloc]initWithCoordinates:myCoordinate placeName:@"John Burroughs School" description:@"755 South Price Rd 63124"];
	[self.myMapView addAnnotation:jburroughs];
    
	//Add MICDS to map
	myCoordinate.latitude = 38.658253;
	myCoordinate.longitude = -90.396141;
	AdoptAnnotation *micds = [[AdoptAnnotation alloc]initWithCoordinates:myCoordinate placeName:@"MICDS School" description:@"101 North Warson Rd 63124"];
	[self.myMapView addAnnotation:micds];
    
	//Add Oakville to map
	myCoordinate.latitude = 38.470731;
	myCoordinate.longitude = -90.321906;
	AdoptAnnotation *oakville = [[AdoptAnnotation alloc]initWithCoordinates:myCoordinate placeName:@"Oakville High School" description:@"5557 Milburn Rd 63129"];
	[self.myMapView addAnnotation:oakville];
    
	//Add Webster to map
	myCoordinate.latitude = 38.590022;
	myCoordinate.longitude = -90.348742;
	AdoptAnnotation *webster = [[AdoptAnnotation alloc]initWithCoordinates:myCoordinate placeName:@"Webster Groves High School" description:@"100 Selma Ave 63119"];
	[self.myMapView addAnnotation:webster];
	
	//Add Parkway North to map
	myCoordinate.latitude = 38.690356;
	myCoordinate.longitude = -90.470697;
	AdoptAnnotation *pnorth = [[AdoptAnnotation alloc]initWithCoordinates:myCoordinate placeName:@"Parkway North High School" description:@"12860 Fee Fee Rd 63146"];
	[self.myMapView addAnnotation:pnorth];
    
	//Add Eureka to map
	myCoordinate.latitude = 38.514736;
	myCoordinate.longitude = -90.625925;
	AdoptAnnotation *eureka = [[AdoptAnnotation alloc]initWithCoordinates:myCoordinate placeName:@"Eureka High School" description:@"4525 Missouri 109 63025"];
	[self.myMapView addAnnotation:eureka];
	
	//Add Kirkwood to map
	myCoordinate.latitude = 38.591472;
	myCoordinate.longitude = -90.424222;
	AdoptAnnotation *kirkwood = [[AdoptAnnotation alloc]initWithCoordinates:myCoordinate placeName:@"Kirkwood High School" description:@"801 W Essex Ave 63122"];
	[self.myMapView addAnnotation:kirkwood];
	
	//Add Villa to map
	myCoordinate.latitude = 38.640506;
	myCoordinate.longitude = -90.415911;
	AdoptAnnotation *villa = [[AdoptAnnotation alloc]initWithCoordinates:myCoordinate placeName:@"Villa Duchesne Oak Hill School" description:@"801 South Spoede Rd 63131"];
	[self.myMapView addAnnotation:villa];
	
	//Add Parkway West to map
	myCoordinate.latitude = 38.620647;
	myCoordinate.longitude = -90.533922;
	AdoptAnnotation *pwest = [[AdoptAnnotation alloc]initWithCoordinates:myCoordinate placeName:@"Parkway West High School" description:@"14653 Clayton Rd 63011"];
	[self.myMapView addAnnotation:pwest];
	
	//Add Ladue to map
	myCoordinate.latitude = 38.639142;
	myCoordinate.longitude = -90.396081;
	AdoptAnnotation *ladue = [[AdoptAnnotation alloc]initWithCoordinates:myCoordinate placeName:@"Ladue Horton Watkins High" description:@"1201 South Warson Rd 63124"];
	[self.myMapView addAnnotation:ladue];
    
	//Add Parkway South to map
	myCoordinate.latitude = 38.576689;
	myCoordinate.longitude = -90.510867;
	AdoptAnnotation *psouth = [[AdoptAnnotation alloc]initWithCoordinates:myCoordinate placeName:@"Parkway South High School" description:@"801 Hanna Rd 63021"];
	[self.myMapView addAnnotation:psouth];
    
	//Add Mehlville to map
	myCoordinate.latitude = 38.514458;
	myCoordinate.longitude = -90.313267;
	AdoptAnnotation *mehlville = [[AdoptAnnotation alloc]initWithCoordinates:myCoordinate placeName:@"Mehlville High School" description:@"3200 Lemay Ferry Rd 63125"];
	[self.myMapView addAnnotation:mehlville];
	
	//Add Affton to map
	myCoordinate.latitude = 38.559603;
	myCoordinate.longitude = -90.324242;
	AdoptAnnotation *affton = [[AdoptAnnotation alloc]initWithCoordinates:myCoordinate placeName:@"Affton High School" description:@"8309 Mackenzie Rd 63123"];
	[self.myMapView addAnnotation:affton];
    
	//Add Lindbergh to map
	myCoordinate.latitude = 38.528583;
	myCoordinate.longitude = -90.374389;
	AdoptAnnotation *lind = [[AdoptAnnotation alloc]initWithCoordinates:myCoordinate placeName:@"Lindbergh High School" description:@"4900 S Lindbergh Blvd 63126"];
	[self.myMapView addAnnotation:lind];
	
	//Add Bishop Dubourg to map
	myCoordinate.latitude = 38.581347;
	myCoordinate.longitude = -90.295233;
	AdoptAnnotation *bishop = [[AdoptAnnotation alloc]initWithCoordinates:myCoordinate placeName:@"Bishop Dubourg High School" description:@"5850 Eichelberger St 63109"];
	[self.myMapView addAnnotation:bishop];
    
    //Add Viz to map
	myCoordinate.latitude = 38.6367193;
	myCoordinate.longitude = -90.4417857;
	AdoptAnnotation *viz = [[AdoptAnnotation alloc]initWithCoordinates:myCoordinate placeName:@"Visitation Academy" description:@"3020 N Ballas Rd 63131"];
	[self.myMapView addAnnotation:viz];
	
    //Add Notre Dame to map
	myCoordinate.latitude = 38.522379;
	myCoordinate.longitude = -90.271907;
	AdoptAnnotation *notredame = [[AdoptAnnotation alloc]initWithCoordinates:myCoordinate placeName:@"Notre Dame High School" description:@"320 East Ripa Ave 63125"];
	[self.myMapView addAnnotation:notredame];
    
    //Add Incarnate Word to map
	myCoordinate.latitude = 38.7000062;
	myCoordinate.longitude = -90.3132096;
	AdoptAnnotation *incarnate = [[AdoptAnnotation alloc]initWithCoordinates:myCoordinate placeName:@"Incarnate Word Academy" description:@"2788 Normandy Dr 63121"];
	[self.myMapView addAnnotation:incarnate];
    
    //Add St. Elizabeth Academy to map
	myCoordinate.latitude = 38.603385;
	myCoordinate.longitude = -90.2384461;
	AdoptAnnotation *seahs = [[AdoptAnnotation alloc]initWithCoordinates:myCoordinate placeName:@"St. Elizabeth Academy" description:@"3401 Arsenal St 63118"];
	[self.myMapView addAnnotation:seahs];
}

- (void)setBackButtonText:(NSString *)text {
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:text style: UIBarButtonItemStyleBordered target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
}

@end
