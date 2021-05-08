// SkittyColorCell.m

#import "SkittyColorCell.h"
#import "SkittyColorViewController.h"

@implementation SkittyColorCell

- (id)target {
	return self;
}

- (id)cellTarget {
	return self;
}

- (SEL)action {
	return @selector(openColorPicker);
}

- (SEL)cellAction {
	return @selector(openColorPicker);
}

- (void)openColorPicker {
	// do it
	UIViewController *viewController = [self _viewControllerForAncestor];
	if (@available(iOS 14, *)) {
		UIColorPickerViewController *colorController = [[UIColorPickerViewController alloc] init];
		NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", self.specifier.properties[@"defaults"]]];
		colorController.selectedColor = colorFromHexString([settings objectForKey:self.specifier.properties[@"key"]] ?: self.specifier.properties[@"default"]);
		colorController.delegate = (id)self;
		[viewController presentViewController:colorController animated:YES completion:nil];
	} else {
		SkittyColorViewController *colorController = [[SkittyColorViewController alloc] initWithProperties:self.specifier.properties];
		[viewController presentViewController:colorController animated:YES completion:nil];
	}
}

- (void)colorPickerViewControllerDidSelectColor:(UIViewController *)vc {
	UIColorPickerViewController *viewController = (UIColorPickerViewController*)vc;
	NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", self.specifier.properties[@"defaults"]]];
	[settings setObject:stringFromColor(viewController.selectedColor) forKey:self.specifier.properties[@"key"]];
	[settings writeToURL:[NSURL URLWithString:[NSString stringWithFormat:@"file:///var/mobile/Library/Preferences/%@.plist", self.specifier.properties[@"defaults"]]] error:nil];

	// UIView *colorPreview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
	// colorPreview.layer.cornerRadius = colorPreview.frame.size.width / 2;
	// colorPreview.layer.borderWidth = 1;
	// colorPreview.layer.borderColor = [UIColor lightGrayColor].CGColor;
	// colorPreview.backgroundColor = viewController.selectedColor;
	// [self setAccessoryView:colorPreview];
	[self updatePreview];

	CFPreferencesSetAppValue((CFStringRef)self.specifier.properties[@"key"], (CFStringRef)stringFromColor(viewController.selectedColor), (CFStringRef)self.specifier.properties[@"defaults"]);
}

- (void)updatePreview {
	UIView *colorPreviewColoredBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
	colorPreviewColoredBorder.layer.cornerRadius = colorPreviewColoredBorder.frame.size.width / 2;
	colorPreviewColoredBorder.layer.borderWidth = 3;
	UIView *colorPreview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
	colorPreview.layer.cornerRadius = colorPreview.frame.size.width / 2;
	// colorPreview.layer.borderWidth = 1;
	// colorPreview.layer.borderColor = [UIColor labelColor].CGColor;
	[colorPreviewColoredBorder addSubview:colorPreview];
	colorPreview.center = colorPreviewColoredBorder.center;

	NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", self.specifier.properties[@"defaults"]]];
	NSString *hex = [settings objectForKey:self.specifier.properties[@"key"]] ?: self.specifier.properties[@"default"];

	//CFStringRef ref = CFPreferencesCopyAppValue((CFStringRef)self.specifier.properties[@"key"], (CFStringRef)self.specifier.properties[@"defaults"]);
	//NSString *hex = (__bridge NSString *)ref ?: self.specifier.properties[@"default"];

	UIColor *color = colorFromHexString(hex);

	colorPreviewColoredBorder.backgroundColor = [UIColor clearColor];
	colorPreviewColoredBorder.layer.borderColor = color.CGColor;
	colorPreview.backgroundColor = color;

	[self setAccessoryView:colorPreviewColoredBorder];
}

- (void)didMoveToSuperview {
	[super didMoveToSuperview];

	[self updatePreview];

	[self.specifier setTarget:self];
	[self.specifier setButtonAction:@selector(openColorPicker)];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePreview) name:@"xyz.skitty.spectrum.colorupdate" object:nil];
}

@end
