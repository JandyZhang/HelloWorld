//
//  HTMineShopCarController.h
//  ios-kuaihaitao
//
//  Created by pqh on 15/12/22.
//  Copyright © 2015年 pqh. All rights reserved.
//

#import "HTMineShopCarController.h"

#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

//屏幕宽
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
//屏幕高
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

#define COLOR(R,G,B,A)	[UIColor colorWithRed:(CGFloat)R/255.0 green:(CGFloat)G/255.0 blue:(CGFloat)B/255.0 alpha:A]
//获取购物车信息
#define SHOPCARURL [NSString stringWithFormat:@"%@user_cart/get",BASEURL]
//BaseUrl
#define BASEURL @"http://dev.kuaiht.com/appApi/"
//删除购物车商品
#define DELETEURL [NSString stringWithFormat:@"%@user_cart/delete",BASEURL]
@interface HTMineShopCarController : UIViewController

@end
