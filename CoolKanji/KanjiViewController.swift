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
    
    override init() {

        //レイアウト
        let layout = UICollectionViewFlowLayout()
        
        // セルのサイズ
        layout.itemSize = CGSizeMake(100, 100)
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
    
    // セル毎の実装
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as UICollectionViewCell
        
        cell.layer.borderColor = UIColor.greenColor().CGColor
        cell.layer.borderWidth = 1.0
        
        let getText: String = kanjiData.objectAtIndex(indexPath.item) as String
        let numText:Int = countElements(getText)
        cell.bounds.size = CGSizeMake((cell.bounds.width) * CGFloat(numText), cell.bounds.height)
        // 毎回addSubViewしたら大変なことになる...
        if ((cell.subviews).count == 1)
        {
            let lbl = UILabel()
            lbl.frame.size = cell.frame.size
            lbl.frame.origin = CGPointMake(0, 0)
            lbl.font = UIFont(name: "HiraKakuProN-W6", size: cell.bounds.height)
            
            lbl.sizeThatFits(cell.bounds.size)
            lbl.text = getText
            
            cell.addSubview(lbl)
        }
        return cell
    }
}
