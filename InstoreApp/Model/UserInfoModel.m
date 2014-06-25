//
//  UserInfoModel.m
//  InstoreApp
//
//  Created by hanchao on 14-5-9.
//  Copyright (c) 2014年 evil. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

-(id)initWithJsonDict:(NSDictionary *)jsonMap
{
    if (self = [super init]) {
        self.name = [jsonMap objectForKey:@"name"];
        self.gender = [jsonMap objectForKey:@"gender"];
        self.nickName = [jsonMap objectForKey:@"nickName"];
        self.mobile = [jsonMap objectForKey:@"mobile"];
        self.clubCard = [jsonMap objectForKey:@"clubCard"];
        
        self.headUrl = [jsonMap objectForKey:@"head"];
        self.points = [jsonMap objectForKey:@"points"] == nil?0:[[jsonMap objectForKey:@"points"] integerValue];
        self.promotionCount = [jsonMap objectForKey:@"promotionCount"] == nil?0:[[jsonMap objectForKey:@"promotionCount"] integerValue];
        self.isStoreFocusRecommend = [jsonMap objectForKey:@"store_focus_recommend"] == nil?NO:[[jsonMap objectForKey:@"store_focus_recommend"] boolValue];
        self.isAutoConnectWifi = [jsonMap objectForKey:@"auto_connect_wifi"] == nil?NO:[[jsonMap objectForKey:@"auto_connect_wifi"] boolValue];
        
    }
    
    return self;
}

-(void)dealloc
{
    self.name = nil;
    self.gender = nil;
    self.nickName = nil;
    self.mobile = nil;
    self.clubCard = nil;
    self.headUrl = nil;
    
    [super dealloc];
}

@end
