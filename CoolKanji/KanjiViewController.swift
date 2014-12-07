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
        
        // index1, index2の階層を取得. このやり方は後で変える?
        let categories = ad.navController!.viewControllers as NSArray

        setItem_index1 = (categories.objectAtIndex(1) as CategoryViewController).m_setItem
        setItem_index2 = (categories.objectAtIndex(2) as CategoryViewController).m_setItem

        let whereInput = "index1=\"" + setItem_index1 + "\" and index2=\"" + setItem_index2 + "\";"
        kanjiData = ad.selectDB(false, column: "kanji", whereCmd: whereInput)
        
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
        
        // 毎回addSubViewしたら大変なことになる...
        if ((cell.subviews).count == 1)
        {
            let lbl = UILabel(frame: CGRectMake(0, 10, 20, 20))
            lbl.text = kanjiData.objectAtIndex(indexPath.item) as String
            cell.addSubview(lbl)
        }
        return cell
    }
}
