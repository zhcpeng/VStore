//
//  IndoorMapViewController2.m
//  MBSMapSample
//
//  Created by sunyifei on 4/1/13.
//
//

#import "IndoorMapWithLeftPopBtnViewController.h"
#import "MBSMapKit.h"
#import "StoreOverViewController.h"

@interface IndoorMapWithLeftPopBtnViewController ()

@end

@implementation IndoorMapWithLeftPopBtnViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    MBSPopup *popup = [MBSPopup getInstance];
    [popup setCanSwitchToStoreDetail:YES];
    [popup setDelegate:self];
    [popup setFHasLeftAccessoryView:YES];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    MBSPopup *popup = [MBSPopup getInstance];
    if (popup) {
        [popup setDelegate:nil];
        [popup setFHasLeftAccessoryView:NO];
    }
    [super dealloc];
}

#pragma mark - MBSPopupDelegate

- (void)switchToStoreDetailViewWithStoreInfo:(BaseStoreInfo*)baseStoreInfo {
    StoreOverViewController *storeOverviewController = [[StoreOverViewController alloc] initWithNibFile];
    storeOverviewController.cityCodeUse = self.cityCodeUse;
    storeOverviewController.storeId = baseStoreInfo.storeId;
    
    storeOverviewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:storeOverviewController animated:YES];
    [storeOverviewController release];
}

-(UIView*)getLeftAccessoryView
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
    [imageView setFrame:CGRectMake(5, 10, imageView.frame.size.width/2, imageView.frame.size.height/2)];
    
    return imageView;
}

-(CGSize)getLeftBtnSize
{
    CGSize leftBtnSize = CGSizeMake(40, 20);
    
    return leftBtnSize;
}

-(void)onLeftButtonPressedWithStoreInfo:(StoreInfo*)storeInfo
{
//    UIAlertView *aAlertView = [[UIAlertView alloc] initWithTitle:@"点击事件"
//                                                         message:storeInfo.brandLogoUrl
//                                                        delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//    [aAlertView show];
//    [aAlertView release];
}

@end
