//
//  SVProgressHUD.m
//
//  Created by Sam Vermette on 27.03.11.
//  Copyright 2011 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVProgressHUD
//

#import "SVProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

@interface SVProgressHUD ()

@property (nonatomic, readwrite) SVProgressHUDMaskType maskType;
@property (nonatomic, retain) NSTimer *fadeOutTimer;
@property (nonatomic, retain) UILabel *stringLabel;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIActivityIndicatorView *spinnerView;
@property (nonatomic, readonly) CGFloat visibleKeyboardHeight;

- (void)showInView:(UIView*)view status:(NSString*)string networkIndicator:(BOOL)show posY:(CGFloat)posY maskType:(SVProgressHUDMaskType)hudMaskType;
- (void)setStatus:(NSString*)string;
- (void)dismiss;
- (void)showInforInViewAfterDelay;
- (void)dismissafterDelay:(NSTimeInterval)delaySeconds;
- (void)dismissWithStatus:(NSString*)string error:(BOOL)error;
- (void)dismissWithStatus:(NSString*)string error:(BOOL)error afterDelay:(NSTimeInterval)seconds;
- (void)memoryWarning:(NSNotification*)notification;
- (void)showInforInView:(UIView*)view withMaskType:(SVProgressHUDMaskType)maskType withIconName:(NSString *)iconName status:(NSString*)inforString withSpinner:(BOOL)withSpinner dismissAfterDelay:(NSTimeInterval)seconds switchToInforAfterDelay:(NSTimeInterval)switchDelaySeconds;
@end


@implementation SVProgressHUD

@synthesize maskType, fadeOutTimer, stringLabel, imageView, spinnerView, visibleKeyboardHeight;

static SVProgressHUD *sharedView = nil;

+ (SVProgressHUD*)sharedView {
	
	if(sharedView == nil)
		sharedView = [[SVProgressHUD alloc] initWithFrame:CGRectZero];
	
	return sharedView;
}

+ (void)setStatus:(NSString *)string {
	[[SVProgressHUD sharedView] setStatus:string];
}


#pragma mark - Show Methods

+ (void)show {
	[SVProgressHUD showInView:nil status:nil];
}

+ (void)showInView:(UIView*)view {
	[SVProgressHUD showInView:view status:nil];
}

+ (void)showInView:(UIView*)view status:(NSString*)string {
	[SVProgressHUD showInView:view status:string networkIndicator:SVProgressHUDShowNetworkIndicator];
}

+ (void)showInView:(UIView*)view status:(NSString*)string networkIndicator:(BOOL)show {
	[SVProgressHUD showInView:view status:string networkIndicator:show posY:-1];
}

+ (void)showInView:(UIView*)view status:(NSString*)string networkIndicator:(BOOL)show posY:(CGFloat)posY {
    [SVProgressHUD showInView:view status:string networkIndicator:show posY:posY maskType:SVProgressHUDMaskTypeNone];
}

+ (void)showWithStatus:(NSString *)status {
    [SVProgressHUD showInView:nil status:status];
}

+ (void)showWithMaskType:(SVProgressHUDMaskType)maskType {
    [SVProgressHUD showInView:nil status:nil networkIndicator:SVProgressHUDShowNetworkIndicator posY:-1 maskType:maskType];
}

+ (void)showWithStatus:(NSString*)status maskType:(SVProgressHUDMaskType)maskType {
    [SVProgressHUD showInView:nil status:status networkIndicator:SVProgressHUDShowNetworkIndicator posY:-1 maskType:maskType];
}

+ (void)showWithStatus:(NSString *)status networkIndicator:(BOOL)show {
    [SVProgressHUD showInView:nil status:status networkIndicator:show];
}

+ (void)showWithMaskType:(SVProgressHUDMaskType)maskType networkIndicator:(BOOL)show {
    [SVProgressHUD showInView:nil status:nil networkIndicator:show posY:-1 maskType:maskType];
}

+ (void)showWithStatus:(NSString*)status maskType:(SVProgressHUDMaskType)maskType networkIndicator:(BOOL)show {
    [SVProgressHUD showInView:nil status:status networkIndicator:show posY:-1 maskType:maskType];
}

+ (void)showSuccessWithStatus:(NSString *)string {
    [SVProgressHUD show];
    [SVProgressHUD dismissWithSuccess:string afterDelay:1];
}


+ (BOOL)isDescendantOfView:(UIView *)view
{
    return [[SVProgressHUD sharedView] isDescendantOfView:view];
}

#pragma mark - All convenience Show methods get forwarded to this one

+ (void)showInView:(UIView*)view status:(NSString*)string networkIndicator:(BOOL)show posY:(CGFloat)posY maskType:(SVProgressHUDMaskType)hudMaskType {
    [[SVProgressHUD sharedView] showInView:view status:string networkIndicator:show posY:posY maskType:hudMaskType];
}


#pragma mark - Dismiss Methods

+ (void)dismiss {
	[[SVProgressHUD sharedView] dismissafterDelay:0];
}

+ (void)dismissAfterDelay:(NSTimeInterval)delaySeconds {
    [[SVProgressHUD sharedView] dismissafterDelay:delaySeconds];
}

+ (void)dismissWithSuccess:(NSString*)successString {
	[[SVProgressHUD sharedView] dismissWithStatus:successString error:NO];
}

+ (void)dismissWithSuccess:(NSString *)successString afterDelay:(NSTimeInterval)seconds {
    [[SVProgressHUD sharedView] dismissWithStatus:successString error:NO afterDelay:seconds];
}

+ (void)dismissWithError:(NSString*)errorString {
	[[SVProgressHUD sharedView] dismissWithStatus:errorString error:YES];
}

+ (void)dismissWithError:(NSString *)errorString afterDelay:(NSTimeInterval)seconds {
    [[SVProgressHUD sharedView] dismissWithStatus:errorString error:YES afterDelay:seconds];
}

+ (void)showErrorinView:(UIView*)view withStatus:(NSString*)errorString {
    [[SVProgressHUD sharedView] showInforInView:view withMaskType:SVProgressHUDMaskTypeNone withIconName:@"error.png" status:errorString withSpinner:NO dismissAfterDelay:-1 switchToInforAfterDelay:-1];
}

+ (void)showErrorinView:(UIView *)view WithMaskType:(SVProgressHUDMaskType)maskType WithStatus:(NSString *)errorString dismissAfterDelay:(NSTimeInterval)delay {
    [[SVProgressHUD sharedView] showInforInView:view withMaskType:maskType withIconName:@"error.png" status:errorString withSpinner:NO dismissAfterDelay:delay switchToInforAfterDelay:-1];
}

+ (void)showErrorinView:(UIView*)view withStatus:(NSString*)errorString switchToNormalInforAfterDelay:(NSTimeInterval) delay {
    [[SVProgressHUD sharedView] showInforInView:view withMaskType:SVProgressHUDMaskTypeNone withIconName:@"error.png" status:errorString withSpinner:NO dismissAfterDelay:-1 switchToInforAfterDelay:delay];
}

+ (void)showErrorinView:(UIView*)view WithMaskType:(SVProgressHUDMaskType)maskType WithStatus:(NSString*)errorString {
	[[SVProgressHUD sharedView] showInforInView:view withMaskType:maskType withIconName:@"error.png" status:errorString withSpinner:NO dismissAfterDelay:-1 switchToInforAfterDelay:-1];
}

+ (void)showSuccess:(NSString *)information dismissAfterDelay:(NSTimeInterval)seconds {
    [[SVProgressHUD sharedView] showInforInView:nil withMaskType:SVProgressHUDMaskTypeNone withIconName:@"success.png" status:information withSpinner:NO dismissAfterDelay:seconds switchToInforAfterDelay:-1];
}

+ (void)showInformation:(NSString *)information dismissAfterDelay:(NSTimeInterval)seconds {
    [[SVProgressHUD sharedView] showInforInView:nil withMaskType:SVProgressHUDMaskTypeNone withIconName:nil status:information withSpinner:NO dismissAfterDelay:seconds switchToInforAfterDelay:-1];
}

#pragma mark - Instance Methods

- (void)dealloc {
	
	if(fadeOutTimer != nil)
		[fadeOutTimer invalidate], [fadeOutTimer release], fadeOutTimer = nil;
	
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
	
    if ((self = [super initWithFrame:frame])) {
    
		self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
		self.alpha = 0;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(memoryWarning:) 
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
        
        _hudView = [[UIView alloc] initWithFrame:CGRectZero];
        _hudView.layer.cornerRadius = 10;
		_hudView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        _hudView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
                                 UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);
        
        [self addSubview:_hudView];
        [_hudView release];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification *notification) {
            NSDictionary* keyboardInfo = [notification userInfo];
            CGRect keyboardFrame = [[keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
            double animationDuration = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                _hudView.frame = CGRectOffset(_hudView.frame, 0, floor(keyboardFrame.size.height/2));
            } completion:NULL];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification *notification) {
            NSDictionary* keyboardInfo = [notification userInfo];
            CGRect keyboardFrame = [[keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
            double animationDuration = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                _hudView.frame = CGRectOffset(_hudView.frame, 0, 0-floor(keyboardFrame.size.height/2));
            } completion:NULL];
        }];
    }
	
    return self;
}

- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    switch (self.maskType) {
            
        case SVProgressHUDMaskTypeBlack: {
            [[UIColor colorWithWhite:0 alpha:0.5] set];
            CGContextFillRect(context, self.bounds);
            break;
        }
            
        case SVProgressHUDMaskTypeGradient: {

            size_t locationsCount = 2;
            CGFloat locations[2] = {0.0f, 1.0f};
            CGFloat colors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f}; 
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
            CGColorSpaceRelease(colorSpace);
            
            CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
            float radius = MIN(self.bounds.size.width , self.bounds.size.height) ;
            CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
            
            break;
        }
    }
}

- (void)setStatus:(NSString *)string {
	
    CGFloat hudWidth = 100;
    CGFloat hudHeight = 100;
    CGFloat stringWidth = 0;
    CGFloat stringHeight = 0;
    CGRect labelRect = CGRectZero;
    
    if(string) {
        CGSize stringSize = [string sizeWithFont:self.stringLabel.font constrainedToSize:CGSizeMake(200, 300)];
        stringWidth = stringSize.width;
        stringHeight = stringSize.height;
        float strTopEdge = 10;
        
        if ((!self.imageView.isHidden) || (!self.spinnerView.isHidden)) {
            hudHeight = 80+stringHeight;
            strTopEdge = 66;
        } else {
            strTopEdge = (hudHeight - stringHeight) / 2;
        }
	
        if(stringWidth > hudWidth)
            hudWidth = ceil(stringWidth/2)*2;

        if(hudHeight > 100) {
            labelRect = CGRectMake(12, strTopEdge, hudWidth, stringHeight);
            hudWidth+=24;
        } else {
            hudWidth+=24;  
            labelRect = CGRectMake(0, strTopEdge, hudWidth, stringHeight);   
        }
    }
	
	_hudView.bounds = CGRectMake(0, 0, hudWidth, hudHeight);
	
	self.imageView.center = CGPointMake(CGRectGetWidth(_hudView.bounds)/2, 36);
	
	self.stringLabel.hidden = NO;
	self.stringLabel.text = string;
	self.stringLabel.frame = labelRect;
	
	if(string)
		self.spinnerView.center = CGPointMake(ceil(CGRectGetWidth(_hudView.bounds)/2)+0.5, 40.5);
	else
		self.spinnerView.center = CGPointMake(ceil(CGRectGetWidth(_hudView.bounds)/2)+0.5, ceil(_hudView.bounds.size.height/2)+0.5);
}

- (void)showInforInView:(UIView*)view withMaskType:(SVProgressHUDMaskType)maskType withIconName:(NSString *)iconName status:(NSString*)inforString withSpinner:(BOOL)withSpinner dismissAfterDelay:(NSTimeInterval)seconds switchToInforAfterDelay:(NSTimeInterval)switchDelaySeconds {
    
    if(fadeOutTimer != nil)
        [fadeOutTimer invalidate], [fadeOutTimer release], fadeOutTimer = nil;
    
    BOOL addingToWindow = NO;
    if(!view) { // if view isn't specified
        NSArray *keyWindows = [UIApplication sharedApplication].windows;
        UIWindow *keyWindow = [keyWindows lastObject];
        addingToWindow = YES;
        
        if([keyWindow respondsToSelector:@selector(rootViewController)])
            view = keyWindow.rootViewController.view;
        
        if(view == nil)
            view = keyWindow;
    }
    
    
    CGFloat activeHeight = CGRectGetHeight(view.bounds);
    
    if(addingToWindow) {
        
        if(self.visibleKeyboardHeight > 0)
            activeHeight += [UIApplication sharedApplication].statusBarFrame.size.height*2;
        
        activeHeight -= self.visibleKeyboardHeight;
        activeHeight -= view.frame.origin.y;
    }
    
    CGFloat posY = floor(activeHeight*0.45);
    if ((!iconName) || ([iconName isEqualToString:@""])) {
        self.imageView.hidden = YES;
    } else {
        //e.g. iconName = error.png
        NSString *nameString = [NSString stringWithFormat:@"SVProgressHUD.bundle/%@", iconName];
        self.imageView.image = [UIImage imageNamed:nameString];
        self.imageView.hidden = NO;
    }
	
    if (spinnerView) {
        if (withSpinner) {
            spinnerView.hidden = NO;
        } else {
            [spinnerView stopAnimating];
            spinnerView.hidden = YES;
        }
    }
    
	[self setStatus:inforString];
    if(self.maskType != SVProgressHUDMaskTypeNone)
        self.userInteractionEnabled = YES;
    else
        self.userInteractionEnabled = NO;
    
	if(![sharedView isDescendantOfView:view]) {
		self.alpha = 0;
		[view addSubview:sharedView];
        [view bringSubviewToFront:sharedView];
	}
    
    self.frame = [UIApplication sharedApplication].keyWindow.frame;
	
	if(sharedView.layer.opacity != 1) {
		
        _hudView.center = CGPointMake(CGRectGetWidth(self.superview.bounds)/2, posY);
		_hudView.layer.transform = CATransform3DScale(CATransform3DMakeTranslation(0, 0, 0), 1.3, 1.3, 1);
		
		[UIView animateWithDuration:0.15
							  delay:0
							options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut
						 animations:^{	
							 _hudView.layer.transform = CATransform3DScale(CATransform3DMakeTranslation(0, 0, 0), 1, 1, 1);
                             self.alpha = 1;
						 }
						 completion:NULL];
	}
    
    if (seconds > 0) {
        
        fadeOutTimer = [[NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(dismiss) userInfo:nil repeats:NO] retain];
    } else if (switchDelaySeconds > 0) {
        fadeOutTimer = [[NSTimer scheduledTimerWithTimeInterval:switchDelaySeconds target:self selector:@selector(showInforInViewAfterDelay) userInfo:nil repeats:NO] retain];
    }
    
    [self setNeedsDisplay];

}

- (void)showInView:(UIView*)view status:(NSString*)string networkIndicator:(BOOL)show posY:(CGFloat)posY maskType:(SVProgressHUDMaskType)hudMaskType {
    BOOL addingToWindow = NO;
    
	if(fadeOutTimer != nil)
		[fadeOutTimer invalidate], [fadeOutTimer release], fadeOutTimer = nil;
    
    if(!view) { // if view isn't specified
        NSArray *keyWindows = [UIApplication sharedApplication].windows;
        UIWindow *keyWindow = [keyWindows lastObject];
        addingToWindow = YES;
        
        if([keyWindow respondsToSelector:@selector(rootViewController)])
            view = keyWindow.rootViewController.view;
        
        if(view == nil)
            view = keyWindow;
    }
    
    CGFloat activeHeight = CGRectGetHeight(view.bounds);
    
    if(addingToWindow) {
        
        if(self.visibleKeyboardHeight > 0)
            activeHeight += [UIApplication sharedApplication].statusBarFrame.size.height*2;
        
        activeHeight -= self.visibleKeyboardHeight;
        activeHeight -= view.frame.origin.y;
    }
    
	if(posY == -1) { // if position isn't specified
        posY = floor(activeHeight*0.45);
    }
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = show;
	
	self.imageView.hidden = YES;
    self.maskType = hudMaskType;
	
    [self.spinnerView setHidden:NO];
	[self.spinnerView startAnimating];
    
	[self setStatus:string];
    
    if(self.maskType != SVProgressHUDMaskTypeNone)
        self.userInteractionEnabled = YES;
    else
        self.userInteractionEnabled = NO;

	if(![sharedView isDescendantOfView:view]) {
		self.alpha = 0;
		[view addSubview:sharedView];
        [view bringSubviewToFront:sharedView];
	}
    
    self.frame = [UIApplication sharedApplication].keyWindow.frame;
	
	if(sharedView.layer.opacity != 1) {
		
        _hudView.center = CGPointMake(CGRectGetWidth(self.superview.bounds)/2, posY);
		_hudView.layer.transform = CATransform3DScale(CATransform3DMakeTranslation(0, 0, 0), 1.3, 1.3, 1);
		
		[UIView animateWithDuration:0.15
							  delay:0
							options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut
						 animations:^{	
							 _hudView.layer.transform = CATransform3DScale(CATransform3DMakeTranslation(0, 0, 0), 1, 1, 1);
                             self.alpha = 1;
						 }
						 completion:NULL];
	}
    
    [self setNeedsDisplay];
}


- (void)dismissWithStatus:(NSString*)string error:(BOOL)error {
	[self dismissWithStatus:string error:error afterDelay:0.9];
}


- (void)dismissWithStatus:(NSString *)string error:(BOOL)error afterDelay:(NSTimeInterval)seconds {
    
    if(self.alpha != 1)
        return;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	if(error)
		self.imageView.image = [UIImage imageNamed:@"SVProgressHUD.bundle/error.png"];
	else
		self.imageView.image = [UIImage imageNamed:@"SVProgressHUD.bundle/success.png"];
	
	self.imageView.hidden = NO;
	
	[self setStatus:string];
	
	[self.spinnerView stopAnimating];
    
	if(fadeOutTimer != nil)
		[fadeOutTimer invalidate], [fadeOutTimer release], fadeOutTimer = nil;
	
	fadeOutTimer = [[NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(dismiss) userInfo:nil repeats:NO] retain];
}

- (void)dismiss {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	[UIView animateWithDuration:0.15
						  delay:0
						options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
					 animations:^{	
						 _hudView.layer.transform = CATransform3DScale(CATransform3DMakeTranslation(0, 0, 0), 0.8, 0.8, 1.0);
						 self.alpha = 0;
					 }
					 completion:^(BOOL finished){ 
                         if(self.alpha == 0) {
                             [self removeFromSuperview]; 
                         }
                     }];
}

- (void)showInforInViewAfterDelay {
    
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
	self.imageView.hidden = YES;
    [self.imageView setHidden:YES];
	[spinnerView stopAnimating];
    [spinnerView setHidden:YES];
    
    [self setStatus:self.stringLabel.text];
    [self setNeedsDisplay];
}

- (void)dismissafterDelay:(NSTimeInterval)delaySeconds {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	[UIView animateWithDuration:0.15
						  delay:delaySeconds
						options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
					 animations:^{	
						 _hudView.layer.transform = CATransform3DScale(CATransform3DMakeTranslation(0, 0, 0), 0.8, 0.8, 1.0);
						 self.alpha = 0;
					 }
					 completion:^(BOOL finished){ 
                         if(self.alpha == 0) {
                             [self removeFromSuperview]; 
                         }
                     }];
}

#pragma mark - Getters

- (UILabel *)stringLabel {
    
    if (stringLabel == nil) {
        stringLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		stringLabel.textColor = [UIColor whiteColor];
		stringLabel.backgroundColor = [UIColor clearColor];
		stringLabel.adjustsFontSizeToFitWidth = YES;
		stringLabel.textAlignment = NSTextAlignmentCenter;
		stringLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		stringLabel.font = [UIFont boldSystemFontOfSize:16];
		stringLabel.shadowColor = [UIColor blackColor];
		stringLabel.shadowOffset = CGSizeMake(0, -1);
        stringLabel.numberOfLines = 0;
		[_hudView addSubview:stringLabel];
		[stringLabel release];
    }
    
    return stringLabel;
}

- (UIImageView *)imageView {
    
    if (imageView == nil) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
		[_hudView addSubview:imageView];
		[imageView release];
    }
    
    return imageView;
}

- (UIActivityIndicatorView *)spinnerView {
    
    if (spinnerView == nil) {
        spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		spinnerView.hidesWhenStopped = YES;
		spinnerView.bounds = CGRectMake(0, 0, 37, 37);
		[_hudView addSubview:spinnerView];
		[spinnerView release];
    }
    
    return spinnerView;
}

- (CGFloat)visibleKeyboardHeight {
    // Locate non-UIWindow.
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if (![[testWindow class] isEqual:[UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }
    
    // Locate UIKeyboard.  
    UIView *foundKeyboard = nil;
    for (UIView *possibleKeyboard in [keyboardWindow subviews]) {
        
        // iOS 4 sticks the UIKeyboard inside a UIPeripheralHostView.
        if ([[possibleKeyboard description] hasPrefix:@"<UIPeripheralHostView"]) {
            possibleKeyboard = [[possibleKeyboard subviews] objectAtIndex:0];
        }                                                                                
        
        if ([[possibleKeyboard description] hasPrefix:@"<UIKeyboard"]) {
            foundKeyboard = possibleKeyboard;
            break;
        }
    }
    
    if(foundKeyboard)
        return foundKeyboard.bounds.size.height;
    
    return 0;
}

#pragma mark - MemoryWarning

- (void)memoryWarning:(NSNotification *)notification {
	
    if (sharedView.superview == nil) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [sharedView release];
        sharedView = nil;
    }
}

@end
