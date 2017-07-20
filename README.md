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
- 工程可以访问http url，即**Info.plist**文件中的**App Transport Security Settings**字典中的**Allow Arbitrary Loads**布尔值为**YES**。
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
从[DeepLeaper官网](www.deepleaper.com)下载**DeepleaperAd.framework**静态库和**DeepleaperAd.bundle**资源包，在**Build Phases** -> **Link Binary With Libraries**添加**DeepleaperAd.framework**，**Build Phases** -> **Copy Bundle Resources**中添加**bundle**
</br>

## 4.信息流广告渲染指南
#### web
- 采用UIWebView渲染固定几种[样式](http://www.deepleaper.com/addemo.html)的广告布局，根据返回的高度设置好父View的Frame即可；
- 如果信息流两边需要留白，可以通过缩小广告位宽度，并把广告居中来达到两边留白，来达到和原生内容相似的效果；
- 如果信息流上下需要留白，可以通过加大cell高度，并把广告居中来达到上下留白，来达到和原生内容相似的效果。

#### native
- 采用原生控件渲染，如需要自定义请根据广告数据类型参照官网[样式](http://www.deepleaper.com/addemo.html)布局，以达到更好的原生体验和广告效果；
- 有两种模式，自动模式默认开启，则会自动按照官网模板添加约束；手动模式请设置autoMode为假，则需要开发者手动设置响应控件的位置，大小以及其他属性

## 5.信息流广告实例代码
#### 信息流广告将会返回一个封装好的View和它的高度，在数据源内插入并设置好渲染的Cell，完成代理方法即可。信息流广告包含native类型和web类型。native类型会返回原生的控件，您可以在遵循广告设计守则的前提下自由设置所有控件的位置，大小等；web类型会返回由webView渲染的控件，在此类型下您仅可以设置标题的属性和图文的间隔；
### 5.1 native
#### Objective-C
##### ① 引用,遵循代理:
```
@import DeepleaperAd;
@interface YOURVIEWCONTROLLER ()<DeepleaperFeedAdManagerDelegate>
```
##### ② 初始化并请求广告:
```
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _fam = [DeepleaperFeedAdManager getFeedAdManager];
    _fam.delegate = self;
    _fam.placementID = @"YOURPLACEMENTID";
    _fam.sandBox = NO;
    NSString* urlString = @"LANDPAGEURL";
    [_fam loadAdWithFeedAdType:FEEDAD_NATIVE andUrl:urlString];
}
```
##### ③ 完成回调方法:
```
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
}
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
-(void)didFailLoadNativeAdView:(NSError *)error{
    NSLog(@"error:%@",error);
}
```
##### ④ 完成渲染:
```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
```
#### Swift
##### ① 引用,遵循代理:
```
import DeepleaperAd;
class YOURVIEWCONTROLLER: DeepleaperFeedAdManagerDelegate
```
##### ② 初始化并请求广告:
```
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	_fam = DeepleaperFeedAdManager.getFeedAdManager();
	_fam.delegate = self;
	_fam.placementID = "YOURPLACEMENTID";
	_fam.sandBox = false;
	let urlString = "LANDPAGEURL";
	_fam.loadAd(with: FEEDAD_NATIVE, andUrl: urlString);
}
```
##### ③ 完成回调方法:
```
func didLoad(_ nativeAdView: DeepleaperNativeAdView) {
    let data = FakeData();
    data.nativeAdView = nativeAdView;
	_sourceArray.insert(data, at: _indexRow);
	DispatchQueue.main.async {
	self.tableView.reloadData();
	}
}
func didClose(_ nativeAdView: DeepleaperNativeAdView) {
	for i in 0..<_sourceArray.count{
	let data = _sourceArray[i];
	if(data.nativeAdView?.isClosed == true){
	    _sourceArray.remove(at: i);
	    DispatchQueue.main.async {
		    self.tableView.deleteRows(at: [IndexPath.init(row: i, section: 0)], with: .fade);
    };
	    break;
        }
    }
}
func didFailLoadNativeAdView(_ error: Error?) {
    print(error);
}
```
##### ④ 完成渲染:
```
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	let adID = "adCell";
	var cell = tableView.dequeueReusableCell(withIdentifier: adID);
	if(cell == nil){
		cell = UITableViewCell.init(style: .default, reuseIdentifier: adID);
	}
	for view in (cell?.contentView.subviews)! {
		view.removeFromSuperview();
	}
	cell?.contentView.addSubview(data.nativeAdView!);
	return cell!;
}
```

### 5.2 web
#### Objective-C
##### ① 引用,遵循代理:
```
@import DeepleaperAd;
@interface YOURVIEWCONTROLLER ()<DeepleaperFeedAdManagerDelegate>
```
##### ② 初始化并请求广告:
```
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _fam = [DeepleaperFeedAdManager getFeedAdManager];
    _fam.delegate = self;
    _fam.placementID = @"YOURPLACEMENTID";
    _fam.sandBox = NO;
    NSString* urlString = @"LANDPAGEURL";
    [_fam loadAdWithFeedAdType:FEEDAD_WEB andUrl:urlString];
}
```
##### ③ 完成回调方法:
```
-(void)didLoadWebAdView:(DeepleaperNativeAdView *)webAdView{
//使用autoMode
    //加入到数据数组
    FakeData* data = [[FakeData alloc]init];
    data.webAdView = webAdView;
    [_sourceArray insertObject:data atIndex:_indexRow];
    dispatch_async(dispatch_get_main_queue(), ^(){
        //刷新
        [self.tableView reloadData];
    });
}
-(void)didCloseWebAdView:(DeepleaperNativeAdView *)webAdView{
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
```
##### ④ 完成渲染:
```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
```
#### Swift
##### ① 引用,遵循代理:
```
import DeepleaperAd;
class YOURVIEWCONTROLLER: DeepleaperFeedAdManagerDelegate
```
##### ② 初始化并请求广告:
```
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	_fam = DeepleaperFeedAdManager.getFeedAdManager();
	_fam.delegate = self;
	_fam.placementID = "YOURPLACEMENTID";
	_fam.sandBox = false;
	let urlString = "LANDPAGEURL";
	_fam.loadAd(with: FEEDAD_WEB, andUrl: urlString);
}
```
##### ③ 完成回调方法:
```
func didLoad(_ webAdView: DeepleaperWebAdView) {
    let data = FakeData();
    data.webAdView = webAdView;
	_sourceArray.insert(data, at: _indexRow);
	DispatchQueue.main.async {
	self.tableView.reloadData();
	}
}
func didClose(_ webAdView: DeepleaperWebAdView) {
	for i in 0..<_sourceArray.count{
	let data = _sourceArray[i];
	if(data. webAdView?.isClosed == true){
	    _sourceArray.remove(at: i);
	    DispatchQueue.main.async {
		    self.tableView.deleteRows(at: [IndexPath.init(row: i, section: 0)], with: .fade);
    };
	    break;
        }
    }
}
func didFailLoadWebAdView(_ error: Error?) {
    print(error);
}
```
##### ④ 完成渲染:
```
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	let adID = "adCell";
	var cell = tableView.dequeueReusableCell(withIdentifier: adID);
	if(cell == nil){
		cell = UITableViewCell.init(style: .default, reuseIdentifier: adID);
	}
	for view in (cell?.contentView.subviews)! {
		view.removeFromSuperview();
	}
	cell?.contentView.addSubview(data.webAdView!);
	return cell!;
}
```

## 6.频次控制
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