//
//  HTShopCarDataModel.m
//  ios-kuaihaitao
//
//  Created by pqh on 15/12/22.
//  Copyright © 2015年 pqh. All rights reserved.
//

#import "HTShopCarDataModel.h"

@implementation HTShopCarDataModel

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper *)keyMapper{
    JSONKeyMapper *keyMapper = [[JSONKeyMapper alloc] initWithDictionary:@{@"msg.user_cart":@"user_cart"}];
    return keyMapper;
}


@end
