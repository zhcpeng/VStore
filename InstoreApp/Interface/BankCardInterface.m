//
//  BankCardInterface.m
//  InstoreApp
//
//  Created by Mac on 14-7-2.
//  Copyright (c) 2014年 evil. All rights reserved.
//

#import "BankCardInterface.h"
#import "JSONKit.h"

@implementation BankCardInterface

-(void)getBankCardByPage:(NSInteger)page amount:(NSInteger)amount{
    self.interfaceUrl = [NSString stringWithFormat:@"%@api/%@/myinfo/bank"
                         ,BASE_INTERFACE_DOMAIN, MALL_CODE];
    self.args = @{@"page":[NSString stringWithFormat:@"%d",page],
                  @"amount":[NSString stringWithFormat:@"%d",amount]};
    self.baseDelegate = self;
    [self connect];
}

#pragma mark - BaseInterfaceDelegate
//https://github.com/joyx-inc/vmall-app-ios/wiki/Mall-News
-(void)parseResult:(ASIHTTPRequest *)request{
    NSString *jsonStr = [[[NSString alloc] initWithData:[request responseData]
                                               encoding:NSUTF8StringEncoding] autorelease];
    id jsonObj = [jsonStr objectFromJSONString];
    
    if (jsonObj) {
        NSInteger totalCount = 0;
        NSInteger currentPage = 0;
        NSMutableArray *resultList = [NSMutableArray array];
        if (jsonObj && [[jsonObj objectForKey:@"totalCount"] integerValue] > 0) {
            totalCount = [[jsonObj objectForKey:@"totalCount"] integerValue];
            currentPage = [[jsonObj objectForKey:@"currentPage"] integerValue];
            
            NSArray *cardListArray = [jsonObj objectForKey:@"list"];
            if (cardListArray) {
                for (NSDictionary *cardList in cardListArray) {
                    NSMutableDictionary *cardListItem = [NSMutableDictionary dictionary];
                    [cardListItem setObject:[cardList objectForKey:@"id"] forKey:@"id"];
                    [cardListItem setObject:[cardList objectForKey:@"name"] forKey:@"name"];
                    [cardListItem setObject:[cardList objectForKey:@"logo"] forKey:@"logo"];
                    [cardListItem setObject:[cardList objectForKey:@"slogan"] forKey:@"slogan"];
                    [cardListItem setObject:[cardList objectForKey:@"promotionCount"] forKey:@"promotionCount"];
                    [resultList addObject:cardListItem];
                }
            }
        }
        if ([self.delegate respondsToSelector:@selector(getBankCardDidFinished:totalCount:currentPage:)]) {
            [self.delegate getBankCardDidFinished:resultList
                                       totalCount:totalCount
                                      currentPage:currentPage];
        }
        
    }else{
        if ([self.delegate respondsToSelector:@selector(getBankCardDidFailed:)]) {
            [self.delegate getBankCardDidFailed:@"获取失败！(response empty)"];
        }
    }
}

-(void)requestIsFailed:(NSError *)error{
    if (_delegate && [self.delegate respondsToSelector:@selector(getBankCardDidFailed:)]) {
        [self.delegate getBankCardDidFailed:@"获取失败！(response empty)"];
    }
}

-(void)dealloc{
    self.delegate = nil;
    
    [super dealloc];
}
@end
