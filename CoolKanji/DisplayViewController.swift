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
    
    var lblKanji: UILabel!
    var adView:ADBannerView!
    var isBannerView:Bool!
    var hiderightBtn:Bool!
    
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
        self.hiderightBtn = false
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(animated: Bool) {
        ad.navigationBarCtrl(target: self, title: "Kanji View")
        
        let (isSet, index) = ad.isFavIDSet(m_id)
        if(isSet == false)
        {
            let favPlus = UIBarButtonItem(barButtonSystemItem:.Add, target: self, action: "AddFav:")
            self.navigationItem.rightBarButtonItem = favPlus
        }
        else
        {
            if (hiderightBtn == false)
            {
                self.navigationItem.rightBarButtonItem = ad.favViewBtn
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        // AppDelegate
        ad = UIApplication.sharedApplication().delegate as AppDelegate

        
        //iAd実装
        adView = ADBannerView(adType: ADAdType.Banner)
        adView.frame = CGRectMake(0, self.view.frame.size.height - adView.frame.size.height,
            adView.frame.size.width, adView.frame.size.height)
        //最初は非表示
        adView.alpha = 0.0
        isBannerView = false
        adView.delegate = self
        self.view.addSubview(adView)
        let whereCmd = "id=" + String(m_id)
        
        let kanji = (ad.selectDB(false, column: "kanji", whereCmd: whereCmd)).objectAtIndex(0) as String
        let kanjiCount = countElements(kanji)
        
        let displayWidth = ad.WWidth * 0.8
        let displayHeight = ad.WHeight * 0.45
        lblKanji = UILabel(frame: CGRectMake(ad.WWidth/10.0, ad.WHeight/10.0, displayWidth, displayHeight))
        lblKanji.sizeThatFits(CGSizeMake(displayWidth, displayHeight))
        lblKanji.font = UIFont(name: ad.kanjiFontName, size: displayWidth / CGFloat(kanjiCount))
        lblKanji.textColor = UIColor.blackColor()
        lblKanji.text = kanji as String
        lblKanji.layer.borderColor = ad.japanRed.CGColor
        lblKanji.layer.borderWidth = 3.0
        self.view.addSubview(lblKanji)
        
        let (isSet, index) = ad.isFavIDSet(m_id)
        
        let meaning = (ad.selectDB(false, column: "meaning", whereCmd: whereCmd)).objectAtIndex(0) as String
        
        let lblMeaning = UILabel(frame: CGRectMake(lblKanji.frame.origin.x, lblKanji.frame.origin.y + 50, displayWidth, 100))
        lblMeaning.font = UIFont(name: ad.systemFontName, size: 10)
        
        // ImageSave
        let saveImgBtn = UIButton(frame: CGRectMake(ad.WWidth*0.7, ad.WHeight*0.8, 100,100))
        saveImgBtn.setTitle("save image", forState: UIControlState.Normal)
        saveImgBtn.setTitleColor(UIColor.brownColor(), forState: UIControlState.Normal)
        saveImgBtn.addTarget(self, action: "saveImage:", forControlEvents: UIControlEvents.TouchDown)
        self.view.addSubview(saveImgBtn)
    }
 
    func AddFav(sender: UIBarButtonItem)
    {
        // お気に入りに追加
        ad.addFavID(self.m_id)

        // 右上に吸い込まれるアニメーション
        let kanjiImage = ImageSave.imageFromView(lblKanji, size: lblKanji.frame.size, bkColor: UIColor.whiteColor())
        let kanjiImageView = UIImageView(image: kanjiImage)
        kanjiImageView.frame.origin = lblKanji.frame.origin
        self.view.addSubview(kanjiImageView)

        self.navigationItem.rightBarButtonItem = self.ad.favViewBtn
        UIView.animateWithDuration(1.0, animations: {
            
            kanjiImageView.frame = CGRectMake(self.ad.WWidth, 0, 0, 0)
            kanjiImageView.alpha = 0.0

            }, completion: {(_) -> Void in
                kanjiImageView.removeFromSuperview()
        })
    }
    
    func saveImage(sender: UIButton)
    {
        lblKanji.layer.borderWidth = 0.0
        let lblImage = ImageSave.imageFromView(lblKanji, size: CGSizeMake(ad.WWidth, ad.WHeight), bkColor: UIColor.whiteColor())
        ImageSave.saveImageToPhotosAlbum(lblImage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
