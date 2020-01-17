// SkittyColorPreviewView.h

#import "libskittycolor.h"

@interface SkittyColorPreviewView : UIView

@property (nonatomic, weak) id<SkittyColorPickerDelegate> delegate;
@property (nonatomic, retain) UIView *previousView;
@property (nonatomic, retain) UIView *currentView;
@property (nonatomic, retain) UIColor *previousColor;
@property (nonatomic, retain) UIColor *currentColor;
@property (nonatomic, retain) UITapGestureRecognizer *gesture;

@end