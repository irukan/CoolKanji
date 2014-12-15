//
//  KanjiViewController.swift
//  CoolKanji
//
//  Created by kayama on 2014/12/06.
//  Copyright (c) 2014年 kayama. All rights reserved.
//

import UIKit
import iAd

class KanjiViewController: UICollectionViewController,ADBannerViewDelegate {

    // Appdelegate
    var ad: AppDelegate!
    
    var setItem_index1: String!
    var setItem_index2: String!
    var kanjiData: NSMutableArray!
    var idData: NSMutableArray!
    
    var defaultSize: CGSize!
    
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
    
    override init() {

        // AppDelegate
        ad = UIApplication.sharedApplication().delegate as AppDelegate

        //レイアウト
        let layout = UICollectionViewFlowLayout()
        defaultSize = CGSizeMake(ad.WWidth/2.5, ad.WWidth/2.5)
        
        // セルのサイズ
        layout.itemSize = defaultSize
        // セクションごとのヘッダーのサイズ
        layout.headerReferenceSize = CGSizeMake(0, 0)
        // セクションごとのフッターのサイズ
        layout.footerReferenceSize = CGSizeMake(0, 0)
        // 行ごとのスペースの最小値
        layout.minimumLineSpacing = 8.0
        // アイテムごとのスペースの最小値
        layout.minimumInteritemSpacing = 8.0
        // セクションの外枠のスペース
        layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8)

        super.init(collectionViewLayout: layout)
        
        // 上位階層のCateforyViewControllerの選択項目を取得する　←後で共通化する
        let parentInformation: NSMutableArray = NSMutableArray()
        
        let viewCs = ad.navController!.viewControllers as NSArray
        for (var i=0; i<viewCs.count; i++)
        {
            let tempViewC: AnyObject = viewCs.objectAtIndex(i)
            if (tempViewC as? CategoryViewController != nil)
            {
                parentInformation.addObject(parentInfo(setItem: (tempViewC as CategoryViewController).m_setItem,
                                                        column: (tempViewC as CategoryViewController).m_column))
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
        

        kanjiData = ad.selectDB(false, column: "kanji", whereCmd: whereCmdInput)
        idData = ad.selectDB(false, column: "id", whereCmd: whereCmdInput)
        
        //複数選択可能
        self.collectionView?.allowsMultipleSelection = true
        
        self.navigationItem.rightBarButtonItem = ad.favViewBtn
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        self.collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        
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
    
    // セクション数
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    // セル数
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kanjiData.count
    }
    

    // セルの大きさ
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let getText: String = kanjiData.objectAtIndex(indexPath.item) as String
        let numText:Int = countElements(getText)
        
        var cellSize: CGSize
        if (numText > 1 )
        {
            cellSize = CGSizeMake( ad.WWidth*0.9, defaultSize.height)
        }
        else
        {
            cellSize = CGSizeMake( defaultSize.width, defaultSize.height)
        }
        
        return cellSize
    }
    
    // セル毎の実装
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as UICollectionViewCell
        
        cell.layer.borderColor = ad.japanRed.CGColor
        cell.layer.borderWidth = 2.0
        
        let getText: String = kanjiData.objectAtIndex(indexPath.item) as String
        let numText:Int = countElements(getText)
        //cell.bounds.size = CGSizeMake((cell.bounds.width) * CGFloat(numText), cell.bounds.height)
        // 毎回addSubViewしたら大変なことになる...
        if ((cell.subviews).count == 1)
        {
            let kanjiBtn = UIButton()
            kanjiBtn.frame.size = cell.frame.size
            kanjiBtn.frame.origin = CGPointMake(0, 0)
            kanjiBtn.titleLabel?.font = UIFont(name: ad.kanjiFontName, size: (cell.bounds.width)/CGFloat(numText))
            kanjiBtn.sizeThatFits(cell.bounds.size)
            kanjiBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            kanjiBtn.addTarget(self, action: "pushBtn:", forControlEvents: UIControlEvents.TouchDown)
            
            let getTag = idData.objectAtIndex(indexPath.item) as String
            kanjiBtn.tag = getTag.toInt()!
            
            kanjiBtn.setTitle(getText, forState: UIControlState.Normal)
            
            cell.addSubview(kanjiBtn)
        }
        return cell
    }
    
    func pushBtn(sender: UIButton)
    {
        self.navigationController?.pushViewController(DisplayViewController(id: sender.tag), animated: true)
    }
    
    
}


