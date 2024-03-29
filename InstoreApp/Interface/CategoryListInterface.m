//
//  CategoryListInterface.m
//  InstoreApp
//
//  Created by evil on 14-5-6.
//  Copyright (c) 2014年 evil. All rights reserved.
//

#import "CategoryListInterface.h"
#import "CategoryModel.h"
#import "JSONKit.h"

@implementation CategoryListInterface
-(void)getCategoryListByPage:(NSInteger) page amount:(NSInteger) amount
{
    self.interfaceUrl = [NSString stringWithFormat:@"%@api/%@/common/category",BASE_INTERFACE_DOMAIN, MALL_CODE];
    self.args = @{@"page":[NSString stringWithFormat:@"%d",page],
                  @"amount":[NSString stringWithFormat:@"%d",amount]};
    self.baseDelegate = self;
    [self connect];
}

#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(ASIHTTPRequest *)request{
    NSString *jsonStr = [[[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
    id jsonObj = [jsonStr objectFromJSONString];
    
    if (jsonObj) {
        NSMutableArray *resultList = [NSMutableArray array];
        NSInteger totalCount = 0;
        NSInteger currentPage = 0;
        if (jsonObj && [[jsonObj objectForKey:@"totalCount"] integerValue] > 0) {
            totalCount = [[jsonObj objectForKey:@"totalCount"] integerValue];
            currentPage = [[jsonObj objectForKey:@"currentPage"] integerValue];
            
            NSArray *categorysArray = [jsonObj objectForKey:@"list"];
            if (categorysArray) {
                for (NSDictionary *categoryDict in categorysArray) {
                    CategoryModel *category = [[[CategoryModel alloc] initWithJsonMap:categoryDict] autorelease];
                    [resultList addObject:category];
                }
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(getCategoryListDidFinished:totalAmount:currentPage:)]) {
            [self.delegate getCategoryListDidFinished:resultList
                                          totalAmount:totalCount
                                          currentPage:currentPage];
        }
    }
}

-(void)requestIsFailed:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(getCategoryListDidFailed:)]) {
        [self.delegate getCategoryListDidFailed:[NSString stringWithFormat:@"获取失败！(%@)",error]];
    }
}

-(void)dealloc
{
    self.delegate = nil;
    [super dealloc];
}
@end
