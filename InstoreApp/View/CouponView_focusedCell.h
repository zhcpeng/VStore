//
//  CouponView_focusedCell.h
//  InstoreApp
//  我关注的品牌优惠
//  Created by evil on 14-6-12.
//  Copyright (c) 2014年 evil. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CouponModel;
@interface CouponView_focusedCell : UITableViewCell

@property (nonatomic, retain) CouponModel *cm1;
@property (nonatomic, retain) CouponModel *cm2;

@property (nonatomic, retain) UIView *leftView;
@property (nonatomic, retain) UIView *rightView;

@property (assign, nonatomic) BOOL addSecondView;  //为真时不添加第2个view！！！

@end
