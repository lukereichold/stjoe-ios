#import <UIKit/UIKit.h>
#import "CalendarDetailPhone.h"
#import "MKTickerView.h"

@class KalViewController;

@interface MainScreen : UIViewController <UITableViewDelegate, MKTickerViewDataSource>  {
    KalViewController *kal;
    id dataSource;
}

@end
