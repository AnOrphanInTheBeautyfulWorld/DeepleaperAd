//
//  WebViewController.m
//  DeepleaperAdExample
//
//  Created by 刘畅 on 2017/7/10.
//  Copyright © 2017年 刘畅. All rights reserved.
//

#import "WebViewController.h"
#import "FakeData.h"
#import "LandPageViewController.h"
@import DeepleaperAd;

@interface WebViewController ()<DeepleaperFeedAdManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,copy) NSMutableArray* sourceArray;
@property(nonatomic,assign) NSInteger indexRow;
@property(nonatomic,strong) DeepleaperFeedAdManager* fam;
@end

@implementation WebViewController

-(NSMutableArray*)sourceArray{
    if (!_sourceArray) {
        _sourceArray = [NSMutableArray new];
    }
    return _sourceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    for (NSUInteger i = 0 ; i<50; i++) {
        FakeData* data = [FakeData new];
        data.title = [NSString stringWithFormat:@"第%ld行",(unsigned long)i];
        [self.sourceArray addObject:data];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    FakeData* data = _sourceArray[indexPath.row];
    if (data.title) {
        static NSString *ID = @"cell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.textLabel.text = data.title;
        return cell;
    }
    //广告
    else{
        static NSString *adID = @"adCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:adID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:adID];
        }
        for (UIView* view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:data.webAdView];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //记录点击行
    _indexRow = indexPath.row+1;
    //初始化
    _fam = [DeepleaperFeedAdManager getFeedAdManager];
    _fam.delegate = self;
    _fam.placementID = @"4cc2f95f-629f-446f-83cd-46ca8593f76b";
    _fam.sandBox = YES;
    NSString* urlString = @"http://m.d1cm.com/news/2017032089009.shtml"; //跳转的落地页url
    //请求广告
    [_fam loadAdWithFeedAdType:FEEDAD_WEB andUrl:urlString];
    //跳转落地页
    LandPageViewController* lvc = [LandPageViewController new];
    lvc.url = [NSURL URLWithString:@"http://www.deepleaper.com"];
    [self presentViewController:lvc animated:YES completion:^{
    }];
}

//返回广告成功
-(void)didLoadWebAdView:(DeepleaperWebAdView *)webAdView{
    //加入到数据数组
    FakeData* data = [[FakeData alloc]init];
    data.webAdView = webAdView;
    [_sourceArray insertObject:data atIndex:_indexRow];
    dispatch_async(dispatch_get_main_queue(), ^(){
        //刷新
        [self.tableView reloadData];
    });
    
}
//关闭了广告
-(void)didCloseWebAdView:(DeepleaperWebAdView *)webAdView{
    for (NSInteger i = _sourceArray.count-1 ; i>=0; i--) {
        FakeData* data = _sourceArray[i];
        if (data.webAdView.isClosed) {
            [_sourceArray removeObjectAtIndex:i];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]]  withRowAnimation:UITableViewRowAnimationFade];
            });
            break;
        }
    }
}
-(void)didFailLoadWebAdView:(NSError *)error{
    NSLog(@"error:%@",error);
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
