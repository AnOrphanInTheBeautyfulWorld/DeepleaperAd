//
//  NativeViewController.swift
//  DeepleaperAdExample_Swift
//
//  Created by 刘畅 on 2017/7/14.
//  Copyright © 2017年 刘畅. All rights reserved.
//

import UIKit
import DeepleaperAd;
class NativeViewController: UIViewController,DeepleaperFeedAdManagerDelegate,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var _sourceArray:[FakeData] = Array();
    var _indexRow = 0;
    var _fam : DeepleaperFeedAdManager!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 假数据数组
        for i in 0..<50{
            let data = FakeData();
            data.title = String.init(format: "第%d行",i);
            _sourceArray.append(data);
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _sourceArray.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = _sourceArray[indexPath.row];
        if (data.nativeAdView != nil && !(data.nativeAdView?.autoMode)!){
            return data.height;
        }
        else{
            return UITableViewAutomaticDimension;
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = _sourceArray[indexPath.row];
        if(data.title != nil){
            let ID = "cell";
            var cell = tableView.dequeueReusableCell(withIdentifier: ID);
            if(cell == nil){
                cell = UITableViewCell.init(style: .default, reuseIdentifier: ID);
            }
            cell?.textLabel?.text = data.title;
            return cell!;
        }
        else{
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
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _indexRow = indexPath.row;
        //初始化
        _fam = DeepleaperFeedAdManager.getFeedAdManager();
        _fam.delegate = self;
        _fam.placementID = "4cc2f95f-629f-446f-83cd-46ca8593f76b";
        _fam.sandBox = false;
        let urlString = "http://m.d1cm.com/news/2017032089009.shtml";
        //请求原生广告
        _fam.loadAd(with: FEEDAD_NATIVE, andUrl: urlString);
        let lvc = LandPageViewController();
        lvc.url = URL.init(string: urlString);
        self.present(lvc, animated: true) {
        };
    }
    func didLoad(_ nativeAdView: DeepleaperNativeAdView) {
//        使用autoMode
//        加入到数据源
                let data = FakeData();
                data.nativeAdView = nativeAdView;
                _sourceArray.insert(data, at: _indexRow);
                DispatchQueue.main.async {
                    self.tableView.reloadData();
                }
        
        /*
        //不适用自动布局
        let data = FakeData();
        DispatchQueue.main.async {
            //设置详细参数
            nativeAdView.autoMode = false;
            if((nativeAdView.title) != nil){
                nativeAdView.title?.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 20);
            }
            if(nativeAdView.nativeType == NATIVE_BIGIMAGE || nativeAdView.nativeType == NATIVE_SINGLEIMAGE || nativeAdView.nativeType == NATIVE_BIGVIDEO || nativeAdView.nativeType == NATIVE_SINGLEVIDEO){
                (nativeAdView.title == nil) ? (nativeAdView.originalityView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width*nativeAdView.scale)) : (nativeAdView.originalityView.frame = CGRect.init(x: 0, y: (nativeAdView.title?.frame.size.height)!+10, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width*nativeAdView.scale));
                nativeAdView.originalityView.firstImageView.frame = nativeAdView.originalityView.bounds;
                if((nativeAdView.originalityView.playImageView) != nil){
                    nativeAdView.originalityView.playImageView.frame = CGRect.init(x: 0, y: 0, width: nativeAdView.originalityView.bounds.size.height/3, height: nativeAdView.originalityView.bounds.size.height/3);
                    nativeAdView.originalityView.playImageView.center = nativeAdView.originalityView.center;
                }
            }
            else if(nativeAdView.nativeType == NATIVE_THREEIMAGES){
                (nativeAdView.title == nil) ? (nativeAdView.originalityView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: (UIScreen.main.bounds.size.width/3-10)*nativeAdView.scale)) : (nativeAdView.originalityView.frame = CGRect.init(x: 0, y: (nativeAdView.title?.frame.size.height)!+10, width: UIScreen.main.bounds.size.width, height: (UIScreen.main.bounds.size.width/3-10)*nativeAdView.scale));
                nativeAdView.originalityView.firstImageView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width/3-10, height: (UIScreen.main.bounds.size.width/3-10)*nativeAdView.scale);
                nativeAdView.originalityView.secondImageView.frame = CGRect.init(x: UIScreen.main.bounds.size.width/3+5, y: 0, width: UIScreen.main.bounds.size.width/3-10, height: (UIScreen.main.bounds.size.width/3-10)*nativeAdView.scale);
                //nativeAdView.originalityView.secondImageView.center = nativeAdView.originalityView.center;
                nativeAdView.originalityView.thirdImageView.frame = CGRect.init(x: UIScreen.main.bounds.size.width-(UIScreen.main.bounds.size.width/3-10), y: 0, width: UIScreen.main.bounds.size.width/3-10, height: (UIScreen.main.bounds.size.width/3-10)*nativeAdView.scale);
            }
            else if (nativeAdView.nativeType == NATIVE_SMALLIMAGE){
                (nativeAdView.title == nil) ? (nativeAdView.originalityView.frame = CGRect.init(x: 0, y:0, width: UIScreen.main.bounds.size.width, height: (UIScreen.main.bounds.size.width/3-10)*nativeAdView.scale+20)) : (nativeAdView.originalityView.frame = CGRect.init(x: 0, y: (nativeAdView.title?.frame.size.height)!+10, width: UIScreen.main.bounds.size.width, height: (UIScreen.main.bounds.size.width/3-10)*nativeAdView.scale+20));
                nativeAdView.originalityView.firstImageView.frame = CGRect.init(x: 0, y: 10, width: UIScreen.main.bounds.size.width/3-10, height: (UIScreen.main.bounds.size.width/3-10)*nativeAdView.scale);
                nativeAdView.originalityView.originalityText.frame = CGRect.init(x: UIScreen.main.bounds.size.width/3, y: 0, width: UIScreen.main.bounds.size.width/3*2, height: (UIScreen.main.bounds.size.width/3-10)*nativeAdView.scale);
            }
            else if (nativeAdView.nativeType == NATIVE_SINGLETITLE){
                nativeAdView.originalityView.originalityText.font = UIFont.systemFont(ofSize: 20);
                nativeAdView.originalityView.originalityText.sizeToFit();
                (nativeAdView.title != nil) ? (nativeAdView.originalityView.frame = CGRect.init(x: 0, y: (nativeAdView.title?.frame.size.height)!+10, width: UIScreen.main.bounds.size.width, height: nativeAdView.originalityView.originalityText.bounds.size.height)) : (nativeAdView.originalityView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: nativeAdView.originalityView.originalityText.bounds.size.height));
                nativeAdView.originalityView.originalityText.frame = CGRect.init(x: 0, y: 0, width: nativeAdView.originalityView.originalityText.bounds.size.width, height: nativeAdView.originalityView.originalityText.bounds.size.height);
            }
            if(nativeAdView.additionalType == ADDITIONAL_FORM || nativeAdView.additionalType == ADDITIONAL_PHONE || nativeAdView.additionalType == ADDITIONAL_DOWNLOAD){
                nativeAdView.additionalView?.frame = CGRect.init(x: 0, y: nativeAdView.originalityView.frame.origin.y+nativeAdView.originalityView.frame.size.height, width: UIScreen.main.bounds.size.width, height: 30);
                nativeAdView.additionalView?.additionalText.frame = CGRect.init(x: 0, y: 0, width: 200, height: 30);
                nativeAdView.additionalView?.additionalButton.sizeThatFits(CGSize.init(width: 60, height: 25));
                nativeAdView.additionalView?.additionalButton.frame = CGRect.init(x: UIScreen.main.bounds.size.width-60-5, y: 2.5, width: 60, height: 25);
            }
            (nativeAdView.additionalType == ADDITIONAL_FORM || nativeAdView.additionalType == ADDITIONAL_PHONE || nativeAdView.additionalType == ADDITIONAL_DOWNLOAD) ? (nativeAdView.logoView.frame = CGRect.init(x: 0, y: (nativeAdView.additionalView?.frame.origin.y)!+(nativeAdView.additionalView?.frame.size.height)!, width: UIScreen.main.bounds.size.width, height: 20)) : (nativeAdView.logoView.frame = CGRect.init(x: 0, y: nativeAdView.originalityView.frame.origin.y+nativeAdView.originalityView.frame.size.height, width: UIScreen.main.bounds.size.width, height: 20));
            nativeAdView.logoView.adTag.sizeToFit();
            nativeAdView.logoView.adTag.frame = CGRect.init(x: 5, y: (20-nativeAdView.logoView.adTag.frame.size.height)/2, width: nativeAdView.logoView.adTag.frame.size.width, height: nativeAdView.logoView.adTag.frame.size.height);
            nativeAdView.logoView.adSource.sizeToFit();
            nativeAdView.logoView.adSource.frame = CGRect.init(x: 5+nativeAdView.logoView.adTag.frame.size.width+5, y: (20-nativeAdView.logoView.adSource.frame.size.height)/2, width: nativeAdView.logoView.adSource.frame.size.width, height: nativeAdView.logoView.adSource.frame.size.height);
            nativeAdView.logoView.closeButton.frame = CGRect.init(x: UIScreen.main.bounds.size.width-20-10, y: 0, width: 20, height: 20);
            data.height = nativeAdView.logoView.frame.origin.y+nativeAdView.logoView.frame.size.height;
            data.nativeAdView = nativeAdView;
            self._sourceArray.insert(data, at: self._indexRow+1);
            self.tableView.reloadData();
        }
 */
    }
    //关闭广告
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
    //请求失败
    func didFailLoadNativeAdView(_ error: Error?) {
        print(error);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
