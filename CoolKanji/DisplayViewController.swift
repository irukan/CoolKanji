//
//  DisplayViewController.swift
//  CoolKanji
//
//  Created by kayama on 2014/12/08.
//  Copyright (c) 2014年 kayama. All rights reserved.
//

import UIKit
import iAd

class DisplayViewController: UIViewController,ADBannerViewDelegate {

    var m_id: Int!
    var ad: AppDelegate!
    
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
    
    init(id: Int)
    {
        super.init(nibName: nil, bundle: nil)
        self.m_id = id
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        // AppDelegate
        ad = UIApplication.sharedApplication().delegate as AppDelegate

        
        let whereCmd = "id=" + String(m_id) //後で治す
        
        let kanji = ad.selectDB(false, column: "kanji", whereCmd: whereCmd)
        
        let lblKanji = UILabel(frame: CGRectMake(ad.WWidth/10.0, ad.WHeight/10.0, ad.WWidth*0.8, ad.WHeight*0.5))
        lblKanji.sizeThatFits(CGSizeMake(ad.WWidth*0.8, ad.WHeight*0.5))
        lblKanji.font = UIFont(name: ad.kanjiFontName, size: ad.WWidth*0.8)
        lblKanji.textColor = UIColor.blackColor()
        lblKanji.text = kanji.objectAtIndex(0) as String
        lblKanji.layer.borderColor = UIColor.blackColor().CGColor
        lblKanji.layer.borderWidth = 3.0
        self.view.addSubview(lblKanji)
        
        
        let (isSet, index) = ad.isFavIDSet(m_id)
        if(isSet == false)
        {
            let addFavorite = UIButton(frame: CGRectMake(ad.WWidth*0.8, ad.WHeight*0.8, 100,100))
            addFavorite.setTitle("+", forState: UIControlState.Normal)
            addFavorite.titleLabel?.font = UIFont(name: "HiraKakuProN-W3", size: 50)
            addFavorite.setTitleColor(UIColor.brownColor(), forState: UIControlState.Normal)
            addFavorite.addTarget(self, action: "pushBtn:", forControlEvents: UIControlEvents.TouchDown)
            self.view.addSubview(addFavorite)
        }
        
        self.navigationItem.rightBarButtonItem = ad.favViewBtn
        
        //iAd実装
        adView = ADBannerView(adType: ADAdType.Banner)
        adView.frame = CGRectMake(0, self.view.frame.size.height - adView.frame.size.height,
            adView.frame.size.width, adView.frame.size.height)
        //最初は非表示
        adView.alpha = 0.0
        isBannerView = false
        adView.delegate = self
        self.view.addSubview(adView)
    }
 
    func pushBtn(sender: UIButton)
    {
        ad.addFavID(self.m_id)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
