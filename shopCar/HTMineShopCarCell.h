//
//  HTMineShopCarCell.h
//  ios-kuaihaitao
//
//  Created by pqh on 15/12/22.
//  Copyright © 2015年 pqh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTShopCarInfoModel.h"

@protocol HTMineShopCarCellDelegate <NSObject>

-(void)change_itWithSegment:(UISegmentedControl *)segment andIndex:(NSInteger)index;

@end

@interface HTMineShopCarCell : UITableViewCell

-(void)loadDataWithInfo:(HTShopCarInfoModel *)info andIndex:(NSInteger)index;

-(void)setUIHiddenWithBOOL:(BOOL)isEditing;



@property(nonatomic,assign)id<HTMineShopCarCellDelegate>delegate;

@end
