//
//  HTMineShopCarController.m
//  ios-kuaihaitao
//
//  Created by pqh on 15/12/22.
//  Copyright © 2015年 pqh. All rights reserved.
//

#import "HTMineShopCarController.h"

#import "HTMineShopCarCell.h"
#import "HTShopCarDataModel.h"

@interface HTMineShopCarController ()<UITableViewDataSource,UITableViewDelegate,HTMineShopCarCellDelegate,UIAlertViewDelegate>
{
    __weak IBOutlet UIView *bottomView;
    UITableView *carTable;
    __weak IBOutlet UILabel *totalPrice;
    __weak IBOutlet UILabel *goods_piece;
    NSMutableArray *dataArray;
    BOOL hasSelectedAll;
}
//选中的cell存入数组
@property(nonatomic,strong)NSMutableArray *selectArr;

@end

@implementation HTMineShopCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    dataArray = [NSMutableArray array];
    self.navigationItem.title = @"购物车";
    [self initUI];
    [self loadData];
}

-(NSMutableArray *)selectArr{
    if (_selectArr == nil) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}

-(void)initUI{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    carTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64-45) style:UITableViewStylePlain];
    carTable.dataSource = self;
    carTable.delegate   = self;
    carTable.tintColor = COLOR(242, 85, 80, 1);
    carTable.allowsMultipleSelectionDuringEditing = YES;
    carTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [carTable registerNib:[UINib nibWithNibName:@"HTMineShopCarCell" bundle:nil] forCellReuseIdentifier:@"HTMineShopCarCell"];
    bottomView.hidden = YES;
}
-(void)loadData{
    NSDictionary *shopCarDict = @{@"user_id":@"7"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:SHOPCARURL parameters:shopCarDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        if ([dict[@"error"] isEqualToString:@"0"]) {
            HTShopCarDataModel *model = [[HTShopCarDataModel alloc] initWithData:operation.responseData error:nil];
            if (model.user_cart.count) {
                for (HTShopCarInfoModel *info in model.user_cart) {
                    [dataArray addObject:info];
                }
                [carTable reloadData];
                [self.view addSubview:carTable];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

#pragma mark - 编辑状态
-(void)edit{
    if (carTable.editing) {
        self.navigationItem.rightBarButtonItem.title = @"编辑";
        carTable.tableHeaderView = [[UIView alloc] init];
    }else{
        self.navigationItem.rightBarButtonItem.title = @"完成";
        totalPrice.text = @"￥0.00";
        goods_piece.text = @"已选中商品0件";
    }
    [self.selectArr removeAllObjects];
    bottomView.hidden =  carTable.editing;
    hasSelectedAll    = !carTable.editing;
    carTable.editing  = !carTable.editing;
    [carTable reloadData];
}

#pragma mark - tableviewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTMineShopCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTMineShopCarCell"];
    if (dataArray.count>0) {
        [cell loadDataWithInfo:dataArray[indexPath.row] andIndex:indexPath.row];
        [cell setUIHiddenWithBOOL:carTable.editing];
        cell.delegate = self;
    }
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (carTable.editing) {
        return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleDelete;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (carTable.editing) {
        UIView *selectAllView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 35)];
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(10, 5, 25, 25);
        [selectBtn addTarget:self action:@selector(selectAll:) forControlEvents:UIControlEventTouchUpInside];
        [selectBtn setImage:[UIImage imageNamed:@"null"] forState:UIControlStateNormal];
        [selectAllView addSubview:selectBtn];
        UILabel *selectLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 5, 40, 25)];
        selectLabel.textColor = [UIColor lightGrayColor];
        selectLabel.text = @"全选";
        selectLabel.font = [UIFont systemFontOfSize:15];
        [selectAllView addSubview:selectLabel];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 34, SCREEN_W, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [selectAllView addSubview:line];
        return selectAllView;
    }
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (carTable.editing) {
        return 35;
    }
    return 0.001;
}
#pragma mark - tableviewDelegate
#pragma mark --- 单选删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.selectArr addObject:indexPath];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否删除该物品?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!carTable.editing) {
        NSLog(@"跳转");
    }else{
        HTShopCarInfoModel *info = dataArray[indexPath.row];
        [self.selectArr addObject:indexPath];
        [self loadUIWithInfo:info withTag:YES];
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    HTShopCarInfoModel *info = dataArray[indexPath.row];
    [self.selectArr removeObject:indexPath];
    [self loadUIWithInfo:info withTag:NO];
}

#pragma mark - 全选
-(void)selectAll:(UIButton *)btn{
    [self.selectArr removeAllObjects];
    float priceNum = 0;
    int goods_num = 0;
    if (hasSelectedAll) {
        [btn setImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
        for (NSInteger i = 0; i < dataArray.count; i ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [carTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            HTShopCarInfoModel *info = dataArray[i];
            [self.selectArr addObject:indexPath];
            priceNum = priceNum + [info.buy_num floatValue]*[info.price floatValue] ;
            goods_num = goods_num + [info.buy_num intValue];
        }
    }else{
        [btn setImage:[UIImage imageNamed:@"null"] forState:UIControlStateNormal];
        for (NSInteger i=0; i<dataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [carTable deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    goods_piece.text   = [NSString stringWithFormat:@"已选中商品%d件",goods_num];
    totalPrice.text = [NSString stringWithFormat:@"￥%.2f",priceNum];
    hasSelectedAll = !hasSelectedAll;
}
#pragma mark - EditDelegate
#pragma mark - 修改数量
-(void)change_itWithSegment:(UISegmentedControl *)segment andIndex:(NSInteger)index{
    HTShopCarInfoModel *info = dataArray[index];
    NSString *priceStr = [totalPrice.text substringFromIndex:1];
    float priceNum     = [priceStr floatValue];
    
    NSString *midStr   = [goods_piece.text substringToIndex:goods_piece.text.length-1];
    NSString *pieceStr = [midStr substringFromIndex:5];
    int goods_num      = [pieceStr intValue];
    
    if (segment.selectedSegmentIndex == 0) {
        if ([info.buy_num intValue] > 1) {
            info.buy_num = [NSNumber numberWithInt:[info.buy_num intValue]-1];
            if ([self.selectArr indexOfObject:[NSIndexPath indexPathForItem:index inSection:0]] != NSNotFound) {
                priceNum  = priceNum - [info.price floatValue] ;
                goods_num = goods_num - 1;
            }
        }
    }else if (segment.selectedSegmentIndex == 2){
        info.buy_num = [NSNumber numberWithInt:[info.buy_num intValue]+1];
        if ([self.selectArr indexOfObject:[NSIndexPath indexPathForItem:index inSection:0]] != NSNotFound) {
            priceNum  = priceNum + [info.price floatValue] ;
            goods_num = goods_num + 1;
        }
    }
    goods_piece.text   = [NSString stringWithFormat:@"已选中商品%d件",goods_num];
    totalPrice.text = [NSString stringWithFormat:@"￥%.2f",priceNum];
    [segment setTitle:[NSString stringWithFormat:@"%@",info.buy_num] forSegmentAtIndex:1];
    
    [dataArray replaceObjectAtIndex:index withObject:info];
}

#pragma mark - 删除
- (IBAction)deleteAny:(id)sender {
    if (self.selectArr.count) {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确认删除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertV show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未选中任何商品" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - 提示删除按钮
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSMutableString *allCart_id = [NSMutableString string];
        for (NSIndexPath *indexPath in self.selectArr) {
            HTShopCarInfoModel *info = dataArray[indexPath.row];
            [allCart_id appendFormat:@"|%@",info.cart_id];
        }
        NSString *cart_ids = [allCart_id substringFromIndex:1];
        
        NSDictionary *cartDict = @{@"cart_id":cart_ids,@"user_id":@"7"};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:DELETEURL parameters:cartDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
            if ([dic[@"error"] isEqualToString:@"0"]) {
                NSArray *tempArr = [[self.selectArr copy] sortedArrayUsingSelector:@selector(compare:)];
                for (int i = (int)tempArr.count; i>0; i--) {
                    [dataArray removeObjectAtIndex:[[tempArr objectAtIndex:i-1] row]];
                }
                [self.selectArr removeAllObjects];
                [carTable reloadData];
            }
            [self edit];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络故障,删除失败" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alert show];
        }];
    }
}
#pragma mark - 选中
-(void)loadUIWithInfo:(HTShopCarInfoModel *)info withTag:(BOOL)plus{
    NSString *priceStr = [totalPrice.text substringFromIndex:1];
    float priceNum = [priceStr floatValue];
    
    NSString *midStr   = [goods_piece.text substringToIndex:goods_piece.text.length-1];
    NSString *pieceStr = [midStr substringFromIndex:5];
    NSInteger pieceNum = [pieceStr integerValue];
    
    if (plus) {
        priceNum = priceNum + [info.buy_num floatValue]*[info.price floatValue] ;
        pieceNum = pieceNum + [info.buy_num integerValue];
    }else{
        priceNum = priceNum - [info.buy_num floatValue]*[info.price floatValue] ;
        pieceNum = pieceNum - [info.buy_num integerValue];
    }
    
    totalPrice.text    = [NSString stringWithFormat:@"￥%.2f",priceNum];
    goods_piece.text   = [NSString stringWithFormat:@"已选中商品%ld件",(long)pieceNum];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
