//
//  HBViewController.m
//  登录
//
//  Created by 刘洪宝 on 14-4-24.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "HBViewController.h"

@interface HBViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPwd;
@property (weak, nonatomic) IBOutlet UITextView *demandInfo;



@property (nonatomic,copy) NSString *time;

@property (nonatomic,copy) NSString *content;



@end

@implementation HBViewController

- (IBAction)logonBtn {
    [self getLogon];
    
}



- (void)getLogon
{
    //加载一个NSURL对象
    self.demandInfo.text = @"";
    NSString *urlStr = [NSString stringWithFormat:@"http://www.kuaidiapi.cn/rest/?uid=11950&key=0e93ffd5048940bca9d53ce2e19584d6&order=%@&id=%@&show=json",self.userName.text, self.userPwd.text];
    
    NSURL *url  = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
   
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError ==nil) {
            
            NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",str);
            NSError *error;
            NSDictionary *kuaidiDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves  error:&error];
            
            NSArray *dataArray = [kuaidiDic objectForKey:@"data"];
            
            NSMutableArray *data = [NSMutableArray array];
            
            for (NSDictionary *dataInfo in dataArray) {
                self.time = dataInfo[@"time"];
                self.content = dataInfo[@"content"];
                
                [data addObject:[NSString stringWithFormat:@"%@\n%@\n\n\n",self.time,self.content]];
            }
            
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                for (int i = 0; i<data.count; i++) {
                    self.demandInfo.text = [self.demandInfo.text stringByAppendingString:data[i]];
                }
            }];
        }
    }];
    [self.view endEditing:YES];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    return NO;
}

@end
