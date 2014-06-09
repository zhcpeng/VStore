//
//  CouponModel.h
//  InstoreApp
//
//  Created by evil on 14-4-29.
//  Copyright (c) 2014年 evil. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StoreModel;
@interface CouponModel : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, assign) NSInteger itemType;//对象类型 固定为1 代表优惠
@property (nonatomic, assign) NSInteger cid;//itemId对象id
@property (nonatomic, assign) NSInteger promotionType;//优惠类型 (1, '优惠活动'), (2, '优惠券'), (3, '团购')
@property (nonatomic, retain) NSString *oldPrice;//原价
@property (nonatomic, retain) NSString *price;//现价

@property (nonatomic, assign) NSInteger collectCount;//参与人数

//团购
@property (nonatomic, retain) NSString *source;//团购来源


@property (nonatomic,strong) NSDate *startTime;
@property (nonatomic,strong) NSDate *endTime;
////@property (nonatomic,assign) NSInteger cid;
//
//@property (nonatomic,assign) NSInteger collectCount;//下载数
////@property (nonatomic,strong) NSString *title;
////@property (nonatomic,strong) NSString *imageUrl;
//@property (nonatomic,assign) CGFloat imageWidth;
//@property (nonatomic,assign) CGFloat imageHeight;
//@property (nonatomic,assign) NSInteger commentCount;//评论数
//@property (nonatomic,assign) NSInteger type;
//
//@property (nonatomic,retain) NSDate *date;
@property (nonatomic,retain) NSString *descriptionStr;
@property (nonatomic,retain) NSMutableArray *images;
//
//@property (nonatomic,assign) NSInteger collectType;//下载方式
//@property (nonatomic,assign) NSInteger collectLimit;//限量
//@property (nonatomic,assign) NSInteger collectRole;
//@property (nonatomic,assign) NSInteger userCollectCount;//我的下载次数
//
//@property (nonatomic,strong) NSString *hotTag;
//@property (nonatomic,strong) NSString *instruction;//优惠券使用说明
////@property (nonatomic,assign) NSInteger collectRole;//下载规则
//@property (nonatomic,assign) NSInteger focusCount;//关注数
//
//@property (nonatomic,strong) NSString *couponCode;//优惠券代码   // ('-1', '未知'),('0', '未消费'), ('1', '已消费')
//@property (nonatomic,assign) NSInteger couponStatus;//优惠券状态
//
@property (nonatomic,strong) StoreModel *store;

-(id)initWithJsonMap:(NSDictionary *)jsonMap;

@end
