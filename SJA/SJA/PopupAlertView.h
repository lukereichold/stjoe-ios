#import <UIKit/UIKit.h>

@protocol MainScreenDelegate;

@interface PopupAlertView : UIViewController {
    
    IBOutlet UIImageView *imageView;
    IBOutlet UILabel *alertLabel;
    IBOutlet UITextView *messageTextView;
    IBOutlet UILabel *messageTitleLabel;
}

@property (assign, nonatomic) id <MainScreenDelegate>delegate;


- (void)setMessageText:(NSString *)message;
- (void)setTitleText:(NSString *)message;

@end

@protocol MainScreenDelegate<NSObject>
@optional
- (void)cancelButtonClicked:(PopupAlertView*)secondDetailViewController;
@end