//
//  FavoriteViewController.swift
//  CoolKanji
//
//  Created by kayama on 2014/12/13.
//  Copyright (c) 2014年 kayama. All rights reserved.
//

import UIKit
import iAd

class FavoriteViewController: UITableViewController, ADBannerViewDelegate {

    var ad:AppDelegate!
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

    override func viewWillAppear(animated: Bool) {
        ad.navigationBarCtrl(target: self, title: "BookMark")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        
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

        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
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
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyCell")

        let getFavIDs: NSMutableArray = ad.getFavIDs()
        let getID = getFavIDs.objectAtIndex(indexPath.row) as Int
        
        let kanji = (ad.selectDB(false, column: "kanji", whereCmd: "id="+String(getID))).objectAtIndex(0) as String
        cell.textLabel?.text = kanji as String
        //cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont(name: ad.systemFontName, size: 20)
        cell.tag = getID
        
        return cell
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
