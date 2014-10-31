#import <UIKit/UIKit.h>
#import "MKTickerView.h"

@class KalViewController;

@interface MainScreenIPAD : UIViewController <UITableViewDelegate, MKTickerViewDataSource>  {
    KalViewController *kal;
    id dataSource;
}

@end
