//
//  HTShopCarDataModel.h
//  ios-kuaihaitao
//
//  Created by pqh on 15/12/22.
//  Copyright © 2015年 pqh. All rights reserved.
//

#import "JSONModel.h"

#import "HTShopCarInfoModel.h"
@interface HTShopCarDataModel : JSONModel

@property(nonatomic,strong)NSArray<HTShopCarInfoModel>*user_cart;

@end
