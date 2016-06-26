//
//  TableViewController.m
//  changemaker
//
//  Created by qianfeng on 16/6/17.
//  Copyright © 2016年 罗建树. All rights reserved.
//

#import "TableViewController.h"
#import <StoreKit/StoreKit.h>

@interface TableViewController ()<SKProductsRequestDelegate,SKPaymentTransactionObserver>

{
    NSMutableArray * dataSource;
}
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataSource = [[NSMutableArray alloc]init];
    
    //注册paymaentQueue观察者来监听买次交易的结果
    [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
    
}

//按钮触发事件
- (IBAction)productsInfo:(UIBarButtonItem *)sender {
    [self getProductsInfo];
    
}
#pragma 发起购买支付获取支付结果

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions
{
    //每当支付对列中有交易，有交易状态发生变化的时候这个方法会调用
    for (SKPaymentTransaction * tranction in transactions) {
        switch (tranction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"交易正在进行中...");
                break;
            case SKPaymentTransactionStatePurchased:
                NSLog(@"交易完成!");
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"交易失败!");
                break;
    
            default: NSLog(@"其他：");
                break;
        }
    }
}

#pragma mark --功能一： 从苹果服务器获取商品信息详情

-(void)getProductsInfo
{
    SKProductsRequest * productsRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:[NSSet setWithObjects:@"com.1000phone.1000goldcoin",@"com.1000phone.2000goldcoin",nil]];
    //通过商品请求对象发起对商品详情信息的请求
    //该构造方法中有哪些product的ID就能获取哪些商品的详情
    //设置代理接收返回的商品详情
    productsRequest.delegate = self;
    
    [productsRequest start];
    
    
}

#pragma mark --功能--： 从苹果实际获取详细信息
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray * arr = response.products;
    for (SKProduct * oneproduct in arr) {
        NSLog(@"%@\n %@\n %@\n",oneproduct.localizedTitle,oneproduct.localizedDescription,oneproduct.price);
    }
    [dataSource removeAllObjects];
    //保存商品数组
    [dataSource addObjectsFromArray:arr];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buyWithPruductID:(NSString *)pruductId
{
    //创建一个SKpayment对象
    SKMutablePayment * payment = [[SKMutablePayment alloc]init];
    //设置商品ID
    payment.productIdentifier = pruductId;
    //加入支付队列执行付款操作
    [[SKPaymentQueue defaultQueue]addPayment:payment];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    //获取商品对象
//    if(!cell)
//    {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
//    }
    SKProduct * pruduct = dataSource[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ 价格：%@",pruduct.localizedTitle,pruduct.localizedDescription];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //商品对象
    SKProduct * product = dataSource[indexPath.row];
    //发起购买
    [self buyWithPruductID:product.productIdentifier];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
