//
//  NativeViewController.m
//  DeepleaperAdExample
//
//  Created by 刘畅 on 2017/6/22.
//  Copyright © 2017年 刘畅. All rights reserved.
//

#import "NativeViewController.h"
#import "FakeData.h"
#import "LandPageViewController.h"

@import DeepleaperAd;

@interface NativeViewController ()<DeepleaperFeedAdManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,copy) NSMutableArray* sourceArray;//数据数组
@property(nonatomic,assign) NSInteger indexRow;//上次点击的行
@property(nonatomic,strong) DeepleaperFeedAdManager* fam;
@end

@implementation NativeViewController

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
    FakeData* data = _sourceArray[indexPath.row];
    //如果禁用了autoMode，则手动返回行高
    if (data.nativeAdView && !data.nativeAdView.autoMode) {
        return data.height;
    }
    else{
        return UITableViewAutomaticDimension;
    }
    
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
        [cell.contentView addSubview:data.nativeAdView];
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
    _fam.sandBox = NO;
    NSString* urlString = @"http://m.d1cm.com/news/2017032089009.shtml"; //跳转的落地页url
    //请求广告
    [_fam loadAdWithFeedAdType:FEEDAD_NATIVE andUrl:urlString];
    //跳转落地页
    LandPageViewController* lvc = [LandPageViewController new];
    lvc.url = [NSURL URLWithString:urlString];
    [self presentViewController:lvc animated:YES completion:^{
    }];
}

//返回广告成功
-(void)didLoadNativeAdView:(DeepleaperNativeAdView *)nativeAdView{
//使用autoMode
    //加入到数据数组
    FakeData* data = [[FakeData alloc]init];
    data.nativeAdView = nativeAdView;
    [_sourceArray insertObject:data atIndex:_indexRow];
    dispatch_async(dispatch_get_main_queue(), ^(){
        //刷新
        [self.tableView reloadData];
    });
//不适用autoMode，手动布局
    /*
        FakeData* data = [[FakeData alloc]init];
        dispatch_async(dispatch_get_main_queue(), ^(){
     //禁用autoMode
            nativeAdView.autoMode = NO;
     //设置title
            nativeAdView.title ? [nativeAdView.title setFrame:CGRectMake(0, 0, 375, 20)] : nil;
     //根据不同物料类型设置位置
            if (nativeAdView.nativeType == NATIVE_BIGIMAGE || nativeAdView.nativeType == NATIVE_SINGLEIMAGE || nativeAdView.nativeType == NATIVE_BIGVIDEO || nativeAdView.nativeType == NATIVE_SINGLEVIDEO) {
                [nativeAdView.originalityView setFrame:CGRectMake(0, nativeAdView.title?nativeAdView.title.frame.size.height+10:0, 375, 375*nativeAdView.scale)];
                [nativeAdView.originalityView.firstImageView setFrame:nativeAdView.originalityView.bounds];
                if (nativeAdView.originalityView.PlayImageView) {
                    [nativeAdView.originalityView.PlayImageView setFrame:CGRectMake(0, 0, nativeAdView.originalityView.bounds.size.height/3, nativeAdView.originalityView.bounds.size.height/3)];
                    [nativeAdView.originalityView.PlayImageView setCenter:nativeAdView.originalityView.center];
                }
            }
            else if (nativeAdView.nativeType == NATIVE_THREEIMAGES){
                [nativeAdView.originalityView setFrame:CGRectMake(0, nativeAdView.title?nativeAdView.title.frame.size.height+10:0, 375, (375/3-10)*nativeAdView.scale)];
                [nativeAdView.originalityView.firstImageView setFrame:CGRectMake(0, 0, 375/3-10, (375/3-10)*nativeAdView.scale)];
                [nativeAdView.originalityView.secondImageView setFrame:CGRectMake(0, 0, 375/3-10, (375/3-10)*nativeAdView.scale)];
                [nativeAdView.originalityView.secondImageView setCenter:nativeAdView.originalityView.center];
                [nativeAdView.originalityView.thirdImageView setFrame:CGRectMake(375-(375/3-10), 0, 375/3-10, (375/3-10)*nativeAdView.scale)];
            }
            else if (nativeAdView.nativeType == NATIVE_SMALLIMAGE){
                [nativeAdView.originalityView setFrame:CGRectMake(0, nativeAdView.title?nativeAdView.title.frame.size.height+10:0, 375, (375/3-10)*nativeAdView.scale+20)];
                [nativeAdView.originalityView.firstImageView setFrame:CGRectMake(0, 10, 375/3-10, (375/3-10)*nativeAdView.scale)];
                [nativeAdView.originalityView.originalityText  setFrame:CGRectMake(375/3, 0, 375/3*2, (375/3-10)*nativeAdView.scale+20)];
            }
            else if (nativeAdView.nativeType == NATIVE_SINGLETITLE){
                [nativeAdView.originalityView setFrame:CGRectMake(0, nativeAdView.title?nativeAdView.title.frame.size.height+10:0, 375, (375/3-10)*nativeAdView.scale+20)];
                [nativeAdView.originalityView.originalityText  setFrame:CGRectMake(0, 0, 375, 100)];
            }
     //判断是否有附加创意
            if (nativeAdView.additionalType) {
                nativeAdView.additionalView.frame = CGRectMake(0, nativeAdView.originalityView.frame.origin.y+nativeAdView.originalityView.frame.size.height, 375, 30);
                nativeAdView.additionalView.additionalText.frame = CGRectMake(0, 0, 200, 30);
                [nativeAdView.additionalView.additionalButton sizeToFit];
                nativeAdView.additionalView.additionalButton.frame = CGRectMake(375-nativeAdView.additionalView.additionalButton.bounds.size.width-10, 0, nativeAdView.additionalView.additionalButton.bounds.size.width, nativeAdView.additionalView.additionalButton.bounds.size.height);
            }
            nativeAdView.logoView.frame = CGRectMake(0, nativeAdView.additionalType ? nativeAdView.additionalView.frame.origin.y+nativeAdView.additionalView.frame.size.height : nativeAdView.originalityView.frame.origin.y+nativeAdView.originalityView.frame.size.height, 375, 20);
            nativeAdView.logoView.logoImageView.frame = CGRectMake(5, 5, 10/0.0625, 10);
            nativeAdView.logoView.closeButton.frame = CGRectMake(375-20-10, 0, 20, 20);
            data.height = nativeAdView.logoView.frame.origin.y+nativeAdView.logoView.frame.size.height;
            data.nativeAdView = nativeAdView;
            [_sourceArray insertObject:data atIndex:_indexRow];
            [self.tableView reloadData];
        });
     */
}
//关闭了广告
-(void)didCloseNativeAdView:(DeepleaperNativeAdView *)nativeAdView{
    for (NSInteger i = _sourceArray.count-1 ; i>=0; i--) {
        FakeData* data = _sourceArray[i];
        if (data.nativeAdView.isClosed) {
            [_sourceArray removeObjectAtIndex:i];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]]  withRowAnimation:UITableViewRowAnimationFade];
            });
            break;
        }
    }
}
//广告请求失败
-(void)didFailLoadNativeAdView:(NSError *)error{
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
