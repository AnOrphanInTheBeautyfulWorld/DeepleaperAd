//
//  LandPageViewController.m
//  DeepleaperAdExample
//
//  Created by 刘畅 on 2017/6/22.
//  Copyright © 2017年 刘畅. All rights reserved.
//

#import "LandPageViewController.h"
//#import "DeepleaperFeedAdManager.h"
@import DeepleaperAd;
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface LandPageViewController ()<UIWebViewDelegate>
@end

@implementation LandPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWebview];    
}
-(void)initWebview{
    self.webview  = [[UIWebView alloc]init];
    self.webview.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.webview.delegate = self;
    [self.view addSubview:self.webview];
    
    NSMutableURLRequest * request;
    
    request =[NSMutableURLRequest requestWithURL:self.url];
    [self.webview loadRequest:request];
    
    [self initBackButton];
}
- (void)initBackButton{
    
        UIButton* closeBtn = [[UIButton alloc]init];
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([UIScreen mainScreen].bounds.size.width>414) {
            closeBtn.frame = CGRectMake(0, 45, 100, 30);
            closeBtn.titleLabel.font = [UIFont systemFontOfSize: 17.0];
        }
        else{
            closeBtn.frame = CGRectMake(0, 30, 50, 20);
            closeBtn.titleLabel.font = [UIFont systemFontOfSize: 10.0];
        }
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        closeBtn.backgroundColor = [UIColor lightGrayColor];
        [closeBtn addTarget:self action:@selector(closeMeLand) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn setTitle:@"返回" forState:UIControlStateNormal];
        [self.webview addSubview:closeBtn];
    
}
-(void)closeMeLand{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[DeepleaperFeedAdManager getFeedAdManager] willCloseLandPageView];
}
-(void)dealloc{
    self.webview.delegate = nil;
    [self.webview stopLoading];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
