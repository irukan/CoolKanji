//
//  FavoriteViewController.swift
//  CoolKanji
//
//  Created by kayama on 2014/12/13.
//  Copyright (c) 2014年 kayama. All rights reserved.
//

import UIKit
import Social

class FavoriteViewController: UITableViewController, SWTableViewCellDelegate {

    var ad:AppDelegate!

    override func viewWillAppear(animated: Bool) {
        ad.navigationBarCtrl(target: self, title: "BookMark")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        
        // AppDelegate
        ad = UIApplication.sharedApplication().delegate as AppDelegate

        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //線なし
        self.tableView.separatorColor = UIColor.clearColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //黒の半透明
        //cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        //角丸
        cell.layer.cornerRadius = 10.0
        cell.layer.borderColor = ad.japanRed.CGColor
        cell.layer.borderWidth = 2
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ad.favIDCont()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: SWTableViewCell = SWTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyCell")

        let getFavIDs: NSMutableArray = ad.getFavIDs()
        let getID = getFavIDs.objectAtIndex(indexPath.row) as Int
        
        let kanji = (ad.selectDB(false, column: "kanji", whereCmd: "id="+String(getID))).objectAtIndex(0) as String
        cell.textLabel?.text = kanji as String
        //cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont(name: ad.systemFontName, size: 25)
        cell.tag = getID
        
        cell.leftUtilityButtons = leftButtons(cell.tag)
        cell.delegate = self
        
        return cell
    }

    // 左ボタン達
    func leftButtons(id: Int)->NSArray!
    {
        let leftBtns = NSMutableArray()
        
        //let index1: String = (ad.selectDB(false, column: "index1", whereCmd: "id=" + String(id) )).objectAtIndex(0) as String
        //let index2: String = (ad.selectDB(false, column: "index2", whereCmd: "id=" + String(id) )).objectAtIndex(0) as String

        let faceBook = ImageSave.reSizeUIImage(UIImage(named: "FB-fLogo-White-broadcast"), width: 40, height: 40)
        let twitter = ImageSave.reSizeUIImage(UIImage(named: "Twitter_logo_white"), width: 40, height: 40)
        
        
        leftBtns.sw_addUtilityButtonWithColor(ad.japanRed, icon: twitter)
        leftBtns.sw_addUtilityButtonWithColor(ad.japanRed, icon: faceBook)

        
        return leftBtns
    }
    // 左ボタンアクション
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerLeftUtilityButtonWithIndex index: Int) {
        switch(index)
        {
            case 0:
                snsViewPresent(SLServiceTypeTwitter, id: cell.tag)
            case 1:
                snsViewPresent(SLServiceTypeFacebook, id: cell.tag)
            default:
                 break
        }
    }
    
    func snsViewPresent(servieType: String, id: Int)
    {
        var composectl:SLComposeViewController = SLComposeViewController(forServiceType: servieType)
        
        //デフォルト表示文字列
        composectl.setInitialText("")
        
        //漢字画像
        let displayWidth = ad.WWidth * 0.8
        let displayHeight = ad.WHeight * 0.45
        let kanji = (ad.selectDB(false, column: "kanji", whereCmd: "id=" + String(id))).objectAtIndex(0) as String
        let kanjiCount = countElements(kanji)
        let lblKanji = UILabel(frame: CGRectMake(ad.WWidth/10.0, ad.WHeight/10.0, displayWidth, displayHeight))
        lblKanji.sizeThatFits(CGSizeMake(displayWidth, displayHeight))
        lblKanji.font = UIFont(name: ad.kanjiFontName, size: displayWidth / CGFloat(kanjiCount))
        lblKanji.textColor = UIColor.blackColor()
        lblKanji.text = kanji as String
        
        let kanjiImage = ImageSave.imageFromView(lblKanji, size: lblKanji.frame.size, bkColor: UIColor.whiteColor())

        // 漢字画像を追加
        composectl.addImage(kanjiImage)
        
//        // Done, Cancel押した時のイベント
//        composectl.completionHandler = {
//            (result:SLComposeViewControllerResult) -> () in
//            switch (result) {
//            case SLComposeViewControllerResult.Done:
//                println("SLComposeViewControllerResult.Done")
//            case SLComposeViewControllerResult.Cancelled:
//                println("SLComposeViewControllerResult.Cancelled")
//            }
//        }
        self.presentViewController(composectl, animated: true, completion: nil)
    }
    
    // セル選択
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell: UITableViewCell = self.tableView.cellForRowAtIndexPath(indexPath)!
        let getID: Int = cell.tag
        
        let dispView = DisplayViewController(id: getID)
        dispView.hiderightBtn = true
        self.navigationController?.pushViewController(dispView, animated: true)
    }
    
    // Edit
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let cell: UITableViewCell = self.tableView.cellForRowAtIndexPath(indexPath)!
        let getID: Int = cell.tag
        // 削除
        ad.deleteFavID(getID)
        
        //アニメーション的に削除
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        //self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        //self.tableView.reloadData()
    }
}
