//
//  GroupBuyDetailPriceCell.h
//  InstoreApp
//
//  Created by evil on 14-6-15.
//  Copyright (c) 2014年 evil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabelStrikeThrough.h"

@interface GroupBuyDetailPriceCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *priceLabel;
@property (nonatomic, retain) IBOutlet UILabelStrikeThrough *oldPriceLabel;
@property (nonatomic, retain) IBOutlet UILabel *amountLabel;

@end
