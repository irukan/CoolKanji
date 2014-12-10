//
//  KanjiViewController.swift
//  CoolKanji
//
//  Created by kayama on 2014/12/06.
//  Copyright (c) 2014年 kayama. All rights reserved.
//

import UIKit

class KanjiViewController: UICollectionViewController {

    // Appdelegate
    var ad: AppDelegate!
    
    var setItem_index1: String!
    var setItem_index2: String!
    var kanjiData: NSMutableArray!
    var indexData: NSMutableArray!
    
    var defaultSize: CGSize!
    
    override init() {

        //レイアウト
        let layout = UICollectionViewFlowLayout()
        defaultSize = CGSizeMake(80, 80)
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
        
        // AppDelegate
        ad = UIApplication.sharedApplication().delegate as AppDelegate
        
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
        indexData = ad.selectDB(false, column: "index3", whereCmd: whereCmdInput) // 後で治す
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = UIColor.whiteColor()
        

        
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        
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
        
        let cellSize = CGSizeMake( defaultSize.width * CGFloat(numText), defaultSize.height)
        return cellSize
    }
    
    // セル毎の実装
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as UICollectionViewCell
        
        cell.layer.borderColor = UIColor.greenColor().CGColor
        cell.layer.borderWidth = 1.0
        
        let getText: String = kanjiData.objectAtIndex(indexPath.item) as String
        let numText:Int = countElements(getText)
        //cell.bounds.size = CGSizeMake((cell.bounds.width) * CGFloat(numText), cell.bounds.height)
        // 毎回addSubViewしたら大変なことになる...
        if ((cell.subviews).count == 1)
        {
            let kanjiBtn = UIButton()
            kanjiBtn.frame.size = cell.frame.size
            kanjiBtn.frame.origin = CGPointMake(0, 0)
            kanjiBtn.titleLabel?.font = UIFont(name: "ackaisyo", size: cell.bounds.height)
            kanjiBtn.sizeThatFits(cell.bounds.size)
            kanjiBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            kanjiBtn.addTarget(self, action: "pushBtn:", forControlEvents: UIControlEvents.TouchDown)
            
            let getTag = indexData.objectAtIndex(indexPath.item) as String
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


