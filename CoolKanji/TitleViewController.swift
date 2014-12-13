//
//  TitleViewController.swift
//  CoolKanji
//
//  Created by kayama on 2014/12/05.
//  Copyright (c) 2014年 kayama. All rights reserved.
//

import UIKit
import iAd

class TitleViewController: UIViewController , ADBannerViewDelegate{

    var ad :AppDelegate!
    var adView:ADBannerView!
    var isBannerView:Bool!

    // iAdの受信に成功したとき
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        
        if ( isBannerView == false)
        {
            //表示
            self.adView.alpha = 1.0
        }
        isBannerView = true
    }
    
    // iAdの受信に失敗したとき
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        
        if (isBannerView == true)
        {
            //非表示
            self.adView.alpha = 0.0
        }
        isBannerView = false
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // AppDelegate
        ad = UIApplication.sharedApplication().delegate as AppDelegate
        
        self.view.backgroundColor = UIColor.whiteColor()
    
        let titleLbl = UILabel(frame: CGRectMake(50, 100, 300, 100))
        titleLbl.sizeThatFits(CGSizeMake(300, 100))
        titleLbl.font = UIFont(name: ad.kanjiFontName, size: 50)
        titleLbl.textColor = UIColor.blackColor()
        titleLbl.text = "Cool Kanji"
        self.view.addSubview(titleLbl)
        
        //iAd実装
        adView = ADBannerView(adType: ADAdType.Banner)
        adView.frame = CGRectMake(0, self.view.frame.size.height - adView.frame.size.height,
            adView.frame.size.width, adView.frame.size.height)
        //最初は非表示
        adView.alpha = 0.0
        isBannerView = false
        adView.delegate = self
        self.view.addSubview(adView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
  
        self.navigationController?.pushViewController(CategoryViewController(columnName: "index1"), animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
