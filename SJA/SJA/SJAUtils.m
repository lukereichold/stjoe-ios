#import "SJAUtils.h"

@implementation SJAUtils

+ (BOOL)isIPAD {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? YES : NO;
}

+ (BOOL)is4InchScreen {
    return ([[UIScreen mainScreen] bounds].size.height == 568)? TRUE : FALSE;
}

+ (BOOL)isLandscape:(UIInterfaceOrientation)orientation {
    return (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight);
}

@end
