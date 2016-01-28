//
//  HTShopCarInfoModel.h
//  ios-kuaihaitao
//
//  Created by pqh on 15/12/22.
//  Copyright © 2015年 pqh. All rights reserved.
//

#import "JSONModel.h"

@protocol HTShopCarInfoModel

@end

@interface HTShopCarInfoModel : JSONModel

@property(nonatomic,strong)NSNumber *product_id;
@property(nonatomic,copy  )NSString *name;
@property(nonatomic,strong)NSNumber *cart_id;
@property(nonatomic,strong)NSNumber *customer_id;
@property(nonatomic,strong)NSNumber *compare_id;
@property(nonatomic,strong)NSNumber *buy_num;
@property(nonatomic,copy  )NSString *buy_type;
@property(nonatomic,copy  )NSString *buy_color;
@property(nonatomic,strong)NSNumber *category_id;
@property(nonatomic,copy  )NSString *goods_img;
@property(nonatomic,copy  )NSString *bonded_area_price;
@property(nonatomic,copy  )NSString *bonded_area_name;
@property(nonatomic,copy  )NSString *price;
@property(nonatomic,copy  )NSString *reference_price;
@property(nonatomic,copy  )NSString *type_name;

@end
