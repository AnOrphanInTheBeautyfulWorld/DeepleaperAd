//
//  LandPageViewController.swift
//  DeepleaperAdExample_Swift
//
//  Created by 刘畅 on 2017/7/14.
//  Copyright © 2017年 刘畅. All rights reserved.
//

import UIKit
import DeepleaperAd;

class LandPageViewController: UIViewController,UIWebViewDelegate {
    public var webView : UIWebView!;
    public var url : URL!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initWebView();
    }
    func initWebView() {
        self.webView = UIWebView.init();
        self.webView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        self.webView.delegate = self;
        self.view.addSubview(self.webView);
        self.webView .loadRequest(URLRequest.init(url: self.url));
        self.initBackButton();
    }
    func initBackButton() {
        let closeButton = UIButton.init(type:.custom);
        if(UIScreen.main.bounds.size.width>414){
            closeButton.frame = CGRect.init(x: 0, y: 45, width: 100, height: 30);
            closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17);
        }
        else{
            closeButton.frame = CGRect.init(x: 0, y: 30, width: 50, height: 20);
            closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 10);
        }
        closeButton.setTitleColor(UIColor.white, for: .normal);
        closeButton.backgroundColor = UIColor.lightGray;
        closeButton.addTarget(self, action: #selector(self.closeMeLand), for: .touchUpInside);
        closeButton.setTitle("返回", for: .normal);
        self.webView.addSubview(closeButton);
    }
    func closeMeLand() {
        self.dismiss(animated: true, completion: nil);
        DeepleaperFeedAdManager.getFeedAdManager().willCloseLandPageView();
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        self.webView.delegate = nil;
        self.webView.stopLoading();
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
