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
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        // AppDelegate
        ad = UIApplication.sharedApplication().delegate as AppDelegate

        
        let whereCmd = "id=" + String(m_id)
        
        let kanji = (ad.selectDB(false, column: "kanji", whereCmd: whereCmd)).objectAtIndex(0) as String
        let kanjiCount = countElements(kanji)
        
        let displayWidth = ad.WWidth * 0.8
        let displayHeight = ad.WHeight * 0.45
        let lblKanji = UILabel(frame: CGRectMake(ad.WWidth/10.0, ad.WHeight/10.0, displayWidth, displayHeight))
        lblKanji.sizeThatFits(CGSizeMake(displayWidth, displayHeight))
        lblKanji.font = UIFont(name: ad.kanjiFontName, size: displayWidth / CGFloat(kanjiCount))
        lblKanji.textColor = UIColor.blackColor()
        lblKanji.text = kanji as String
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
        
        
        let meaning = (ad.selectDB(false, column: "meaning", whereCmd: whereCmd)).objectAtIndex(0) as String
        
        let lblMeaning = UILabel(frame: CGRectMake(lblKanji.frame.origin.x, lblKanji.frame.origin.y + 50, displayWidth, 100))
        lblMeaning.font = UIFont(name: ad.systemFontName, size: 10)
        
        
        
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
