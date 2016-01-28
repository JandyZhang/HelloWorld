//
//  HTMineShopCarCell.m
//  ios-kuaihaitao
//
//  Created by pqh on 15/12/22.
//  Copyright © 2015年 pqh. All rights reserved.
//

#import "HTMineShopCarCell.h"
#import "UIImageView+WebCache.h"
@interface HTMineShopCarCell ()
{
    __weak IBOutlet UIImageView *headImage;
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UILabel *sizeColor;
    __weak IBOutlet UILabel *price;
    __weak IBOutlet UILabel *bonded_area_name;
    __weak IBOutlet UISegmentedControl *addSegment;
    __weak IBOutlet UILabel *piece;
    NSInteger cellID;
}

@end

@implementation HTMineShopCarCell

- (void)awakeFromNib {
    // Initialization code
    [addSegment addTarget:self action:@selector(change_it) forControlEvents:UIControlEventValueChanged];
    [addSegment setImage:[[UIImage imageNamed:@"plus"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:2];
}

-(void)loadDataWithInfo:(HTShopCarInfoModel *)info andIndex:(NSInteger)index{
    cellID = index;
    [headImage sd_setImageWithURL:[NSURL URLWithString:info.goods_img]];
    bonded_area_name.text=info.bonded_area_name;
    name.text = info.name;
    sizeColor.text = [NSString stringWithFormat:@"颜色:%@ 尺码:%@",info.buy_color,info.buy_type];
    price.text = [NSString stringWithFormat:@"￥%@",info.price];
    piece.text = [NSString stringWithFormat:@"X%@",info.buy_num];
    [addSegment setTitle:[NSString stringWithFormat:@"%@",info.buy_num] forSegmentAtIndex:1];
    
}

-(void)change_it{
    if (self.delegate && [self.delegate respondsToSelector:@selector(change_itWithSegment:andIndex:)]) {
        [self.delegate change_itWithSegment:addSegment andIndex:cellID];
    }
}

-(void)setUIHiddenWithBOOL:(BOOL)isEditing{
    addSegment.hidden = !isEditing;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
