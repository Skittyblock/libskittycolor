// SkittyColorAlphaView.h

#import <UIKit/UIKit.h>
#import "SkittyColorIndicatorView.h"
#import "libskittycolor.h"

@interface SkittyColorAlphaView : UIView

@property (nonatomic, weak) id<SkittyColorPickerDelegate> delegate;
@property (nonatomic, retain) SkittyColorIndicatorView *indicator;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, assign) float alphaValue;
@property (nonatomic, retain) UIPanGestureRecognizer *gesture;

@end