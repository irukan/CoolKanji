//
//  CategoryViewController.swift
//  CoolKanji
//
//  Created by kayama on 2014/12/05.
//  Copyright (c) 2014年 kayama. All rights reserved.
//

import UIKit
import iAd

class parentInfo: NSObject {
    var m_setItem: String!
    var m_column: String!
    
    init(setItem: String, column: String)
    {
        m_setItem = setItem
        m_column = column
    }
}

class CategoryViewController: UIViewController, ADBannerViewDelegate {


    var ad: AppDelegate!
    var m_column: String!
    var m_setItem: String!
    
    var items: NSMutableArray!
    var buttons: NSMutableArray!
    
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
    
    init(columnName: String) {
        super.init(nibName: nil, bundle: nil)
        
        // AppDelegate
        ad = UIApplication.sharedApplication().delegate as AppDelegate
        
        m_column = columnName
        
        // 上位階層のCateforyViewControllerの選択項目を取得する　←後で共通化する
        let parentInformation: NSMutableArray = NSMutableArray()
        
        let viewCs = ad.navController!.viewControllers as NSArray
        for (var i=0; i<viewCs.count; i++)
        {
            let tempViewC: AnyObject = viewCs.objectAtIndex(i)
            if (tempViewC as? CategoryViewController != nil)
            {
                parentInformation.addObject(parentInfo(setItem: tempViewC.m_setItem, column: tempViewC.m_column))
            }
    
        }
        
        var whereCmdInput: String = ""
        for (var l = 0; l < parentInformation.count; l++)
        {
            if(l != 0)
            {
                whereCmdInput += " and "
            }
            
            whereCmdInput += (parentInformation.objectAtIndex(l) as parentInfo).m_column
                            + "=\""
                                + (parentInformation.objectAtIndex(l) as parentInfo).m_setItem
                                    + "\""
        }
        
        items = ad.selectDB(true, column: m_column, whereCmd: whereCmdInput)
        buttons = NSMutableArray()
        
        for (var i = 0; i < items.count; i++)
        {
            let getText = items[i] as String
            let numText = countElements(getText) as Int
            let btn = UIButton()
            btn.setTitle(getText, forState: UIControlState.Normal)
        
            btn.layer.cornerRadius = 30
            btn.titleLabel?.font = UIFont(name: ad.systemFontName, size: 50)
            btn.titleLabel?.minimumScaleFactor = 10
            btn.titleLabel?.adjustsFontSizeToFitWidth = true
            btn.backgroundColor = ad.japanRed
            btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            btn.addTarget(self, action: "pushBtn:", forControlEvents: UIControlEvents.TouchDown)
           
            
            buttons.addObject(btn)
        }
        
    }
    
    func pushBtn(sender: UIButton)
    {
        self.m_setItem = sender.titleForState(UIControlState.Normal)
        
        switch m_column
        {
            case "index1" :
                self.navigationController?.pushViewController(CategoryViewController(columnName: "index2"), animated: true)
                
            case "index2":
                self.navigationController?.pushViewController(KanjiViewController(), animated: true)
                
            default:
                break
        }
        

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        let scrollView = UIScrollView(frame: self.view.bounds)
        
        // buttons の位置決め
        var offset: CGFloat = 120
        
        for (var i=0; i < buttons.count; i++)
        {
            (buttons[i] as UIButton).frame = CGRectMake(ad.WWidth*0.15, 50 + offset * CGFloat(i), ad.WWidth*0.7, 60)
            scrollView.addSubview(buttons[i] as UIButton)
        }
        
        //エラーチェック
        if (buttons.count == 0)
        {
            return
        }
        
        // 一番下のボタンのちょい下あたりまでの高さにする
        let lastBtnpos = (buttons.lastObject as UIButton).frame.origin
        scrollView.contentSize = CGSizeMake(self.view.bounds.width, lastBtnpos.y + 120)
        
        scrollView.addSubview(buttons[0] as UIButton)
        
        
        self.view.addSubview(scrollView)
        // Do any additional setup after loading the view.
        
        
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
