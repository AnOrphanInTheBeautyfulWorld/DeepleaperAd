//
//  WebViewController.swift
//  DeepleaperAdExample_Swift
//
//  Created by 刘畅 on 2017/7/14.
//  Copyright © 2017年 刘畅. All rights reserved.
//

import UIKit
import DeepleaperAd;

class WebViewController: UIViewController,DeepleaperFeedAdManagerDelegate,UITableViewDelegate,UITableViewDataSource  {
    @IBOutlet weak var tableView: UITableView!
    var _sourceArray:[FakeData] = Array();
    var _indexRow = 0;
    var _fam : DeepleaperFeedAdManager!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //初始化数据
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
        return UITableViewAutomaticDimension;
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
            cell?.contentView.addSubview(data.webAdView!);
            return cell!;
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _indexRow = indexPath.row;
        //初始化
        _fam = DeepleaperFeedAdManager.getFeedAdManager();
        _fam.delegate = self;
        _fam.placementID = "4cc2f95f-629f-446f-83cd-46ca8593f76b";
        _fam.sandBox = true;
        let urlString = "http://m.d1cm.com/news/2017032089009.shtml";
        _fam.loadAd(with: FEEDAD_WEB, andUrl: urlString);
        let lvc = LandPageViewController();
        lvc.url = URL.init(string: urlString);
        self.present(lvc, animated: true) {
        };
    }
    //成功返回
    func didLoad(_ webAdView: DeepleaperWebAdView) {
        //加入到数据源
        let data = FakeData();
        data.webAdView = webAdView;
        _sourceArray.insert(data, at: _indexRow);
        DispatchQueue.main.async {
            self.tableView.reloadData();
        }
    }
    //关闭广告
    func didClose(_ webAdView: DeepleaperWebAdView) {
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
    func didFailLoadWebAdView(_ error: Error?) {
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
