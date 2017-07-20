# <center>DeepleaperAd</center>
</br>
## <center>iOS广告平台SDK 用户手册</center>

</br>



|&nbsp;日期&nbsp;|&nbsp;版本&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;修改描述&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|
|:-------------:|:-------------:|:-----:|
| 2017-03-15| V1.2.0 | 新建 | 
</br>

## 1.简介

**DeepleaperAd**是[跃盟科技](http://www.deepleaper.com)推出的内容语义智能广告平台在iOS上的版本。本文档针对媒体端接入提供了如何使用SDK的详细说明，建议配合样例工程一起阅读，代码中的注释非常全面。

</br>

## 2.环境

- iOS 8.0+；</br>
- **StoreKit.framework** 和 **AdSupport.framework** 作为依赖库；</br>
- 工程可以访问http网页，即**Info.plist**文件中的**App Transport Security Settings**字典中的**Allow Arbitrary Loads**布尔值为**YES**。
</br>

## 3.集成
#### 在集成前请确保您已经在[跃盟科技](http://www.deepleaper.com)注册了媒体端的账号，并完成广告位等相关设置。
### ① 使用Cocoapods（推荐）
在Podfile中写入：
```
platform :ios, '8.0'
use_frameworks!
target 'YOURTARGETNAME' do
pod 'DeepleaperAd'
end
```
执行</br>
<code>pod install</code>

### ② 手动添加：
从[DeepLeaper官网](www.deepleaper.com)下载**DeepleaperAd.framework**静态库，在**Build Phases** -> **Link Binary With Libraries** 和 **Build Phases** -> **Copy Bundle Resources**中添加**DeepleaperAd.framework**
</br>

## 4.信息流广告
#### 信息流广告将会返回一个封装好的View和它的高度，在数据源内插入并设置好渲染的Cell，完成代理方法即可。信息流广告包含native类型和web类型。native类型会返回原生的控件，您可以在遵循广告设计守则的前提下自由设置所有控件的位置，大小等；web类型会返回由webView渲染的控件，在此类型下您可以设置标题的属性和图文的间隔；
### 4.1 native

### 4.2 web
### ① 引用:
#### Objective-C
```
#import "ViewController.h"
@import DeepleaperAd;
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,DLDynamicAdManagerDelegate>
@property(nonatomic,copy) NSMutableArray* sourceAry;//数据数组
@end
@implementation ViewController
{
    NSInteger _indexRow;//存储上一次点击的row
}
```
#### Swift
```
import UIKit
import DeepleaperAd;
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,DLDynamicAdManagerDelegate {
var _indexRow : Int = Int.init();//存储上一次点击的row
var _dataAry = NSMutableArray();//数据数组
```
### ② 请求广告:
#### Objective-C
```
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //初始化动态广告管理器
    DLDynamicAdManager* dlm = [DLDynamicAdManager getDynamicAdManager];
    dlm.delegate = self;
    InfoData* data = _sourceAry[indexPath.row];
    //请求广告 参数为 落地页地址，广告位ID，广告位宽度
    [dlm startLoadDynamicAD:data.webUrl AuTag:YOURADID andWidth:FeedAdWeight];
    _indexRow = indexPath.row ? indexPath.row : 0;
    //Your Code...
}    
```
#### Swift
```
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	//初始化动态广告管理器
    let dlm : DLDynamicAdManager = DLDynamicAdManager.getDynamicAdManager();
    dlm.delegate = self;
    let data : InfoData = _dataAry[indexPath.row] as! InfoData;
    //请求广告 参数为 落地页地址，广告位ID，广告位宽度
    dlm.startLoadDynamicAD(data.webUrl, auTag:"YOURAPPAUTAG" , andWidth:375.00);
    _indexRow = indexPath.row != 0 ? indexPath.row : 0;
    //Your Code...
}
```
### ③ 添加广告展示:
#### Objective-C
```
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"adCell";
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: ID];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    for (UIView* view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    [cell.contentView addSubview:data.ad];//data.ad是广告view
    return cell;
}
```
#### Swift
```
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let ID = "adCell";
    _tableView.separatorStyle = UITableViewCellSeparatorStyle(rawValue: 1)!;
    var cell = _tableView.dequeueReusableCell(withIdentifier: ID);
    if cell == nil {
        cell = UITableViewCell.init(style: UITableViewCellStyle(rawValue: 0)!, reuseIdentifier: ID);
    }
    cell?.selectionStyle = UITableViewCellSelectionStyle(rawValue:0)!;
    cell?.contentView.addSubview(data.ad);
    return cell!;
}
```
### ④ 实现代理方法:
#### Objective-C
```
//动态广告下载成功 收到广告的view和高度
-(void)didLoadDynamicAdView:(DLFeedAdView*)AdView andHeight:(float)height{
    //根据既定数据结构添加到数据源
    InfoData* data = [[InfoData alloc]init];
    data.ad = AdView;
    data.height = height;

#warning "Optional start"
    //如果需要同时只存在一个动态广告（即展示下一个就回收上一个），就加上此段代码用来回收旧广告
    for (int i = 0; i<=_sourceAry.count-1; i++) {
        InfoData* data = _sourceAry[i];
        if (data.ad.adType == DLAD_DYNAMIC) {
            [_sourceAry removeObjectAtIndex:i];
            if(i<_indexRow){
                _indexRow--;
            }
            break;
        }
    }
#warning "Optional end"
    
    //成功下载的广告加入数据源
    [_sourceAry insertObject:data atIndex:_indexRow+1];
    //刷新
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
```
```
//关闭广告位
-(void)closeDynamicFeedView{
    for (int i = 0; i<=_sourceAry.count-1; i++) {
        InfoData* data = _sourceAry[i];
        //如果广告需要关闭
        if (data.ad.isClosed) {
            //从数据源移除
            [_sourceAry removeObjectAtIndex:i];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]]  withRowAnimation:UITableViewRowAnimationFade];
            });
            break;
        }
    }
}
```
```
//失败
-(void)didFailLoadDynamicAdView{
    NSLog(@"动态广告下载失败");
}
```
#### Swift
```
//广告下载成功
func didLoadDynamicAdView(_ AdView: DLFeedAdView!, andHeight height: Float) {
    //根据既定数据结构添加到数据源
    let data = InfoData.init();
    data.ad = AdView;
    data.height = height;
    
    //Start->如果需要同时只存在一个动态广告（即展示下一个就回收上一个），就加上此段代码用来回收旧广告
    var i = _dataAry.count-1;
    for temp in _dataAry {
        let tempData : InfoData = _dataAry[i] as! InfoData;
        if tempData.ad.adType == DLAD_DYNAMIC {
            _dataAry .removeObject(at: i);
            if i<_indexRow {
                _indexRow -= 1;
            }
            break;
        }
        i -= 1;
    }
    //End->如果需要同时只存在一个动态广告（即展示下一个就回收上一个），就加上此段代码用来回收旧广告
    
    //成功下载的广告加入数据源
    _dataAry .insert(data, at: _indexRow+1);
    //刷新
    DispatchQueue.main.async {
        self._tableView.reloadData();
    }
}
```
```
//关闭广告
func closeDynamicFeedView() {
    var i = 0;
    for temp in _dataAry {
        let data = _dataAry[i] as! InfoData;
        //如果广告需要关闭
        if data.ad.isClosed {
            //从数据源移除
            _dataAry.removeObject(at: i);
            DispatchQueue.main.async {
                self._tableView.deleteRows(at: [IndexPath.init(row: i, section: 0)], with: UITableViewRowAnimation(rawValue: 0)!)   
            }
            break;
        }
        i += 1;
    }
}
```

```
//广告下载失败
func didFailLoadDynamicAdView() {
    NSLog("Fail");
}
```
### ⑤ 在拿到需要展示的广告view和广告位高度后，可以根据您的数据结构自行适配，Demo只提供一个例子
</br>

## 5.原生信息流模块
#### 原生信息流模块将会返回一个封装好的数据，在数据源内插入数据并按照原生的样式设置好渲染的Cell，完成代理方法即可。此模块的样例工程为DeepleaperNativeDemo和DeepleaperNativeDemo_Swift，分别对应Objective-C和Swift版本。
### ① 请求广告:
#### Objective-C

```
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //记录点击行数
    _indexRow = indexPath.row ? indexPath.row : 0;
    DLNativeAdManager* DAM = [DLNativeAdManager getDLNativeAdManager];
    DAM.placementID = @"YOURPLACEMENTID";
    DAM.delegate = self;
    DLdata* data = _sourceAry[indexPath.row];
    //开始请求广告
    [DAM loadAdWithUrl:data.url];
}
//已经加载了原生广告信息，对图片缓存
-(void)didLoadNativeAd:(DLNativeAdData *)NativeAdData{
    if (NativeAdData.type  == DLAD_NATIVE_BIGIMAGE) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *imageUrl = NativeAdData.imagesSrcArray[0];
            NSData *data = [NSData dataWithContentsOfURL:imageUrl];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage* image = [UIImage imageWithData:data];
                if (data && image) {
                    //图片下载完成后，缓存图片，并把原生广告数据加入数组
                    DLdata* data = [[DLdata alloc]init];
                    data.adData = NativeAdData;
                    data.imgae = image;
                    [_sourceAry insertObject:data atIndex:_indexRow+1];
                    [_tableView reloadData];
                }
            });
        });
    }
    else if (NativeAdData.type  == DLAD_NATIVE_BIGVIDEO){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *imageUrl = NativeAdData.videoCoverImageSrc;
            NSData *data = [NSData dataWithContentsOfURL:imageUrl];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage* image = [UIImage imageWithData:data];
                if (data && image) {
                    DLdata* data = [[DLdata alloc]init];
                    data.adData = NativeAdData;
                    data.imgae = image;
                    [_sourceAry insertObject:data atIndex:_indexRow+1];
                    [_tableView reloadData];
                }
            });
        });
    }
    else if (NativeAdData.type  == DLAD_NATIVE_SINGLEIMAGE){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *imageUrl = NativeAdData.imagesSrcArray[0];
            NSData *data = [NSData dataWithContentsOfURL:imageUrl];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage* image = [UIImage imageWithData:data];
                if (data && image) {
                    DLdata* data = [[DLdata alloc]init];
                    data.adData = NativeAdData;
                    data.imgae = image;
                    [_sourceAry insertObject:data atIndex:_indexRow+1];
                    [_tableView reloadData];
                }
            });
        });
    }
    else if (NativeAdData.type  == DLAD_NATIVE_SINGLEVIDEO){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *imageUrl = NativeAdData.videoCoverImageSrc;
            NSData *data = [NSData dataWithContentsOfURL:imageUrl];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage* image = [UIImage imageWithData:data];
                if (data && image) {
                    DLdata* data = [[DLdata alloc]init];
                    data.adData = NativeAdData;
                    data.imgae = image;
                    [_sourceAry insertObject:data atIndex:_indexRow+1];
                    [_tableView reloadData];
                }
            });
        });
    }
    else if (NativeAdData.type  == DLAD_NATIVE_SINGLETITLE){
        DLdata* data = [[DLdata alloc]init];
        data.adData = NativeAdData;
        [_sourceAry insertObject:data atIndex:_indexRow+1];
        [_tableView reloadData];
    }
    else if (NativeAdData.type  == DLAD_NATIVE_THREEIMAGES){
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        __block NSData *firstImageViewData;
        __block NSData *secondImageViewData;
        __block NSData *thirdImageViewData;
        dispatch_group_async(group, queue, ^{
            NSURL *firstImageViewUrl = NativeAdData.imagesSrcArray[0];
            firstImageViewData = [NSData dataWithContentsOfURL:firstImageViewUrl];
        });
        dispatch_group_async(group, queue, ^{
            NSURL *secondImageViewUrl = NativeAdData.imagesSrcArray[1];
            secondImageViewData = [NSData dataWithContentsOfURL:secondImageViewUrl];
        });
        dispatch_group_async(group, queue, ^{
            NSURL *thirdImageViewUrl = NativeAdData.imagesSrcArray[2];
            thirdImageViewData = [NSData dataWithContentsOfURL:thirdImageViewUrl];
        });
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            DLdata* data = [[DLdata alloc]init];
            data.adData = NativeAdData;
            data.imgae = [UIImage imageWithData:firstImageViewData];
            data.imgae1 = [UIImage imageWithData:secondImageViewData];
            data.imgae2 = [UIImage imageWithData:thirdImageViewData];
            [_sourceAry insertObject:data atIndex:_indexRow+1];
            [_tableView reloadData];
        });
    }
    else if (NativeAdData.type  == DLAD_NATIVE_SMALLIMAGE){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *imageUrl = NativeAdData.imagesSrcArray[0];
            NSData *data = [NSData dataWithContentsOfURL:imageUrl];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage* image = [UIImage imageWithData:data];
                if (data && image) {
                    DLdata* data = [[DLdata alloc]init];
                    data.adData = NativeAdData;
                    data.imgae = image;
                    [_sourceAry insertObject:data atIndex:_indexRow+1];
                    [_tableView reloadData];
                }
            });
        });
    }
}

```
#### Swift
```
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //记录点击行
        _indexRow = indexPath.row != 0 ? indexPath.row : 0;
        let data : InfoData = _dataAry[indexPath.row] as! InfoData;
        //初始化DeepleaperNativeAdManager对象来请求广告
        let DAM = DeepleaperNativeAdManager.getNativeAdManager();
        //设置属性
        DAM?.placementID = "866a5e72-600c-4ba8-ad76-02aa1ec8cb05";
        DAM?.delegate = self;
        //根据落地页地址请求广告
        DAM?.loadAd(withUrl: data.url);
}

//广告数据返回成功
    func didLoadNativeAd(_ NativeAdData: DeepleaperNativeAdData!) {
        //判断类型，根据类型对数据进行缓冲
        if NativeAdData.type == DLAD_NATIVE_BIGIMAGE{
            DispatchQueue.global().async {
                let imageUrl = NativeAdData.imagesSrcArray[0];
                let data = NSData.init(contentsOf: imageUrl as! URL);
                DispatchQueue.main.async {
                    let image = UIImage.init(data: data as! Data);
                    if data != nil && image != nil {
                        let data = InfoData();
                        data.adData = NativeAdData;
                        data.image = image!;
                        if self._lastAdRow != 0{
                            self._dataAry.removeObject(at: self._lastAdRow);
                        }
                        self._dataAry .insert(data, at: self._indexRow+1);
                        self._lastAdRow = self._indexRow+1;
                        self._tableView.reloadData();
                    }
                }
            }
        }
        else if NativeAdData.type == DLAD_NATIVE_BIGVIDEO{
            DispatchQueue.global().async {
                let imageUrl = NativeAdData.videoCoverImageSrc;
                let data = NSData.init(contentsOf: imageUrl!);
                DispatchQueue.main.async {
                    let image = UIImage.init(data: data as! Data);
                    if data != nil && image != nil {
                        let data = InfoData();
                        data.adData = NativeAdData;
                        data.image = image!;
                        if self._lastAdRow != 0{
                            self._dataAry.removeObject(at: self._lastAdRow);
                        }
                        self._dataAry .insert(data, at: self._indexRow+1);
                        self._lastAdRow = self._indexRow+1;
                        self._tableView.reloadData();
                    }
                }
            }
        }
        else if NativeAdData.type == DLAD_NATIVE_SINGLEIMAGE{
            DispatchQueue.global().async {
                let imageUrl = NativeAdData.imagesSrcArray[0];
                let data = NSData.init(contentsOf: imageUrl as! URL);
                DispatchQueue.main.async {
                    let image = UIImage.init(data: data as! Data);
                    if data != nil && image != nil {
                        let data = InfoData();
                        data.adData = NativeAdData;
                        data.image = image!;
                        if self._lastAdRow != 0{
                            self._dataAry.removeObject(at: self._lastAdRow);
                        }
                        self._dataAry .insert(data, at: self._indexRow+1);
                        self._lastAdRow = self._indexRow+1;
                        self._tableView.reloadData();
                    }
                }
            }
        }
        else if NativeAdData.type == DLAD_NATIVE_SINGLEVIDEO{
            DispatchQueue.global().async {
                let imageUrl = NativeAdData.videoCoverImageSrc;
                let data = NSData.init(contentsOf: imageUrl!);
                DispatchQueue.main.async {
                    let image = UIImage.init(data: data as! Data);
                    if data != nil && image != nil {
                        let data = InfoData();
                        data.adData = NativeAdData;
                        data.image = image!;
                        if self._lastAdRow != 0{
                            self._dataAry.removeObject(at: self._lastAdRow);
                        }
                        self._dataAry .insert(data, at: self._indexRow+1);
                        self._lastAdRow = self._indexRow+1;
                        self._tableView.reloadData();
                    }
                }
            }
        }
        else if NativeAdData.type == DLAD_NATIVE_SINGLETITLE{
            let data = InfoData.init();
            data.adData = NativeAdData;
            if self._lastAdRow != 0{
                self._dataAry.removeObject(at: self._lastAdRow);
            }
            self._dataAry .insert(data, at: self._indexRow+1);
            self._lastAdRow = self._indexRow+1;
            self._tableView.reloadData();
        }
        else if NativeAdData.type == DLAD_NATIVE_THREEIMAGES{
            let group = DispatchGroup();
            var  firstImageViewData = NSData();
            var secondImageViewData = NSData();
            var thirdImageViewData = NSData();

            //将当前的下载操作添加到组中
            group.enter()
                
            //在这里异步加载任务
            DispatchQueue.global().async {
                let url = NativeAdData.imagesSrcArray[0];
                do {
                    firstImageViewData = try NSData.init(contentsOf: url as! URL);
                } catch {
                    return;
                }
            }
            DispatchQueue.global().async {
                let url = NativeAdData.imagesSrcArray[1];
                do {
                    secondImageViewData = try NSData.init(contentsOf: url as! URL);
                } catch {
                    return;
                }
            }
            DispatchQueue.global().async {
                let url = NativeAdData.imagesSrcArray[2];
                do {
                    thirdImageViewData = try NSData.init(contentsOf: url as! URL);
                } catch {
                    return;
                }
            }
                
            //离开当前组
            group.leave()
            
            group.notify(queue: DispatchQueue.main) {
                //在这里告诉调用者,下完完毕,执行下一步操作
                DispatchQueue.main.async {
                    let data = InfoData();
                    data.adData = NativeAdData;
                    data.image = UIImage.init(data: firstImageViewData as Data)!;
                    data.image1 = UIImage.init(data: secondImageViewData as Data)!;
                    data.image2 = UIImage.init(data: thirdImageViewData as Data)!;
                    if self._lastAdRow != 0{
                        self._dataAry.removeObject(at: self._lastAdRow);
                    }
                    self._dataAry .insert(data, at: self._indexRow+1);
                    self._lastAdRow = self._indexRow+1;
                    self._tableView.reloadData();
                }
            }
        }
        else if NativeAdData.type == DLAD_NATIVE_SMALLIMAGE{
            DispatchQueue.global().async {
                let imageUrl = NativeAdData.imagesSrcArray[0];
                let data = NSData.init(contentsOf: imageUrl as! URL);
                DispatchQueue.main.async {
                    let image = UIImage.init(data: data as! Data);
                    if data != nil && image != nil {
                        let data = InfoData();
                        data.adData = NativeAdData;
                        data.image = image!;
                        if self._lastAdRow != 0{
                            self._dataAry.removeObject(at: self._lastAdRow);
                        }
                        self._dataAry .insert(data, at: self._indexRow+1);
                        self._lastAdRow = self._indexRow+1;
                        self._tableView.reloadData();
                    }
                }
            }
        }
    }
```
### ② 添加广告展示:
#### Objective-C
```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRowAtIndexPath");
    DLdata* data = _sourceAry[indexPath.row];
    if (data.adData.type == DLAD_NATIVE_BIGIMAGE || data.adData.type == DLAD_NATIVE_BIGVIDEO) {
            BigMediaCell* cell = [BigMediaCell cellWithTableView:tableView];
            cell.delegate = self;
            cell.backgroundColor = [UIColor whiteColor] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setCellData:data andIndex:indexPath];
            return cell;
        }
        else if (data.adData.type == DLAD_NATIVE_SMALLIMAGE){
            SmallMediaCell* cell = [SmallMediaCell cellWithTableView:tableView];
            cell.delegate = self;
            cell.backgroundColor = [UIColor whiteColor] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setCellData:data andIndex:indexPath];
            return cell;
        }
        else if (data.adData.type == DLAD_NATIVE_SINGLETITLE){
            SingleTitleCell* cell = [SingleTitleCell cellWithTableView:tableView];
            cell.delegate = self;
            cell.backgroundColor = [UIColor whiteColor] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setCellData:data andIndex:indexPath];
            return cell;
        }
        else if (data.adData.type == DLAD_NATIVE_SINGLEIMAGE || data.adData.type == DLAD_NATIVE_SINGLEVIDEO){
            SingleMediaCell* cell = [SingleMediaCell cellWithTableView:tableView];
            cell.delegate = self;
            cell.backgroundColor = [UIColor whiteColor] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setCellData:data andIndex:indexPath];
            return cell;
        }
        else if (data.adData.type == DLAD_NATIVE_THREEIMAGES){
            ThreeImagesCell* cell = [ThreeImagesCell cellWithTableView:tableView];
            cell.delegate = self;
            cell.backgroundColor = [UIColor whiteColor] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setCellData:data andIndex:indexPath];
            return cell;
        }
        else{
            static NSString *ID = @"cell";
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: ID];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.textLabel.text = [NSString stringWithFormat:@"NO.%ld \n%@",indexPath.row,data.title];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.numberOfLines = 0;
            cell.contentView.backgroundColor = [UIColor lightGrayColor];
            return cell;
        }
}
```
#### Swift
```
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	//根据自己的布局判断广告类型，此处PIC交互模板和Video交互模板使用同样的布局
            if data.adData.type == DLAD_NATIVE_BIGIMAGE || data.adData.type == DLAD_NATIVE_BIGVIDEO{
                let cell = BigMediaCell.cellWithTableView(tableView: tableView);
                cell.delegate = self;
                cell.setCellData(data: data, indexPath: indexPath as NSIndexPath);
                return cell;
            }
            else if data.adData.type == DLAD_NATIVE_SMALLIMAGE{
                let cell = SmallMediaCell.cellWithTableView(tableView: tableView);
                cell.delegate = self;
                cell.setCellData(data: data, indexPath: indexPath as NSIndexPath);
                return cell;
            }
            else if data.adData.type == DLAD_NATIVE_SINGLETITLE{
                let cell = SingleTitleCell.cellWithTableView(tableView: tableView);
                cell.delegate = self;
                cell.setCellData(data: data, indexPath: indexPath as NSIndexPath);
                return cell;
            }
            //根据自己的布局判断广告类型，此处PIC垂直图片模板和Video垂直视频模板使用同样的布局
            else if data.adData.type == DLAD_NATIVE_SINGLEIMAGE || data.adData.type == DLAD_NATIVE_SINGLEVIDEO{
                let cell = SingleMediaCell.cellWithTableView(tableView: tableView);
                cell.delegate = self;
                cell.setCellData(data: data, indexPath: indexPath as NSIndexPath);
                return cell;
            }
            else if data.adData.type == DLAD_NATIVE_THREEIMAGES{
                let cell = ThreeImagesCell.cellWithTableView(tableView: tableView);
                cell.delegate = self;
                cell.setCellData(data: data, indexPath: indexPath as NSIndexPath);
                return cell;
            }

}
```
### ③响应落地页跳转:
#### Objective-C
```
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	//判断落地页是否为广告落地页
    if (data.adData) {
        LandPageViewController* LPVC = [[LandPageViewController alloc]init];
        LPVC.landPageUrl = data.adData.landPageUrl;
        LPVC.data = data;
        //判断落地页是否有视频播放
        if (data.adData.type == DLAD_NATIVE_BIGVIDEO || data.adData.type == DLAD_NATIVE_SINGLEVIDEO) {
            LPVC.videoHeight = [UIScreen mainScreen].bounds.size.width*data.adData.aspectRatio;
        }
        [self.navigationController pushViewController:LPVC animated:YES];
        [data.adData willEnterLandPage];
    }
    else{
        LandPageViewController* LPVC = [[LandPageViewController alloc]init];
        LPVC.landPageUrl = [NSURL URLWithString:data.url];
        [self.navigationController pushViewController:LPVC animated:YES];
    }
}
```
#### Swift
```
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	//落地页初始化
        let dvc = DetailViewController();
        //判断是广告数据
        if data.adData.type != DLAD_NATIVE_UNKNOW{
            dvc.landPageUrl = data.adData.landPageUrl as NSURL;
            dvc.data = data;
            //判断是视频类广告数据
            if data.adData.type == DLAD_NATIVE_BIGVIDEO || data.adData.type == DLAD_NATIVE_SINGLEVIDEO {
                dvc.videoHeight = UIScreen.main.bounds.size.width * CGFloat.init(data.adData.aspectRatio) ;
            }
            //进入广告落地页时调用
            data.adData.willEnterLandPage();
        }
        else{
            dvc.landPageUrl = NSURL.init(string: data.url)!;
        }
        self.present(dvc, animated: true, completion: nil);
}
```
### ④实现代理方法:
原生信息流模块的代理方法需要媒体开发者写入，详情可以参考我们的样例工程。
## 6.广告渲染指南
### 动态信息流广告位
- 采用UIWebView渲染固定几种[样式](http://www.deepleaper.com/addemo.html)的广告布局，根据返回的高度设置好父View的Frame即可；
- 如果信息流两边需要留白，可以通过缩小广告位宽度，并把广告居中来达到两边留白，来达到和原生内容相似的效果；
- 如果信息流上下需要留白，可以通过加大cell高度，并把广告居中来达到上下留白，来达到和原生内容相似的效果。

### 原生信息流广告位
- 只做数据交互，请根据广告数据类型参照官网[样式](http://www.deepleaper.com/addemo.html)布局，以达到更好的原生体验和广告效果；
- 参照Demo完成广告主体和附加按钮的点击响应；
- 在恰当的时机调用展示/点击接口来记录此次行为；

## 7.频次控制
##### 广告中的频次控制是指控制用户在媒体一段时间内最多看到广告的次数，引入频次控制可以提高CTR，增强用户体验。

#### 同时满足以下所有规则才会返回广告：
1：距离上一次广告展现时间间隔大于等于1分钟；</br>
2：同一个广告计划下的广告两次展示的间隔大于等于10分钟；</br>
3：同一个广告计划最近24小时内展现小于5次；</br>
4：在上一个广告展现后，用户点击的不同文章数大于5篇，或时间间隔超过10分钟；</br>
5：文章点击后进入详情页，阅读时间大于3秒。</br>
</br>


## 帮助
### 感谢您的阅读，更多信息和帮助请登陆 [跃盟科技官网](http://www.deepleaper.com) 或与 [我们](mailto:fluency@deepleaper.com) 联系。
</br>