//
//  AddBankCardViewController.m
//  InstoreApp
//
//  Created by Mac on 14-7-2.
//  Copyright (c) 2014年 evil. All rights reserved.
//

#import "AddBankCardViewController.h"
#import "EGOImageView.h"
#import "AddBankCardCell.h"
#import "AddBankCardModel.h"
#import "SaveAddBankCardInterface.h"


@interface AddBankCardViewController ()

@end

@implementation AddBankCardViewController

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
    // Do any additional setup after loading the view from its nib.
    
    self.itemList = [NSMutableArray array];
    self.chooeseBankCard = [NSMutableDictionary dictionary];
    
    self.addBankCardInterface = [[[AddBandCardInterface alloc]init]autorelease];
    _addBankCardInterface.delegate = self;
    [_addBankCardInterface getAddBankCardByPage:self.currentPage amount:20];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 35)];
    label.text = @"  请选择银行";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1];
    self.myTableView.tableHeaderView = label;
    
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 35;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemList.count;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 35)];
//    label.text = @"  请选择银行";
//    label.font = [UIFont systemFontOfSize:12];
//    label.textColor = [UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1];
//    UITableViewHeaderFooterView *view = [self.myTableView headerViewForSection:0];
//    [view addSubview:label];
////    view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
//    return label;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifer = @"Cell";
        AddBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
        if (!cell) {
            //        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AddBankCardCell"
                                                  owner:self
                                                options:nil] objectAtIndex:0];
        }
        if (self.itemList.count > 0) {
            AddBankCardModel *addBankModel = [self.itemList objectAtIndex:indexPath.row];
            cell.egoImageView.imageURL = [NSURL URLWithString:addBankModel.logo];
            cell.labBankName.text = addBankModel.name;
        }
        
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    AddBankCardModel *addBankModel = [self.itemList objectAtIndex:indexPath.row];
    BOOL chooesed = addBankModel.choosed;
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        if (chooesed == NO) {
            NSInteger bankId = addBankModel.bankId;
            [self.chooeseBankCard setObject:[NSNumber numberWithInteger:bankId] forKey:[NSString stringWithFormat:@"%d",bankId]];
        }
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if ([self.chooeseBankCard objectForKey:[NSString stringWithFormat:@"%d",addBankModel.bankId]]) {
            [self.chooeseBankCard removeObjectForKey:[NSString stringWithFormat:@"%d",addBankModel.bankId]];
        }
    }
    
}
-(void)getAddBankCardDidFinished:(NSArray *)itemList totalCount:(NSInteger)totalCount currentPage:(NSInteger)currentPage{
    [self.itemList addObjectsFromArray:itemList];
    self.totalAmount = totalCount;
    self.currentPage = currentPage;
    self.currentPage++;
    
    [self.myTableView reloadData];
}
-(void)getAddBankCardDidFailed:(NSString *)errorMsg{
    NSLog(@"%s:%@",__FUNCTION__,errorMsg);
}
-(void)dealloc{
    self.addBankCardInterface = nil;
    self.itemList = nil;
    self.chooeseBankCard = nil;
    
    [_myTableView release];
    [_labChooeseCount release];
    [_labText release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnFinishedAction:(UIButton *)sender {
    NSLog(@"%s:%@",__FUNCTION__,self.chooeseBankCard);
    //id=1&id=2&id=3
    SaveAddBankCardInterface *saveVC = [[SaveAddBankCardInterface alloc]init];
    
    [saveVC SaveAddBankCardWithDictionary:self.chooeseBankCard];
    [saveVC release];
}
@end
