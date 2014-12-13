//
//  AppDelegate.swift
//  CoolKanji
//
//  Created by kayama on 2014/12/05.
//  Copyright (c) 2014年 kayama. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navController: UINavigationController?

    var WWidth:CGFloat!
    var WHeight:CGFloat!
    var japanRed:UIColor!
    var kanjiFontName:String!
    
    var db:FMDatabase!
    
    var defaults:NSUserDefaults!
    var favViewBtn: UIBarButtonItem!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        self.WWidth = window?.bounds.width
        self.WHeight = window?.bounds.height
        self.japanRed = UIColor(red: 230.0/255.0, green: 32.0/255.0, blue: 71.0/255.0, alpha: 1.0)
        self.kanjiFontName = "ackaisyo"
        
        // FMDB init with CoolKnji data
        let dataPath = NSBundle.mainBundle().pathForResource("testDB", ofType: "db")
        db = FMDatabase(path: dataPath)
        
        // UserDefaults
        defaults = NSUserDefaults.standardUserDefaults()
        let favID_tmp:[Int] = []
        
        if let names = defaults.objectForKey("favoriteID") as? [Int]
        {
        }
        else
        {
            //初期化
            defaults.setObject(favID_tmp, forKey: "favoriteID")
            defaults.synchronize()
        }
        // Favorite 画面に行くボタン
        self.favViewBtn = UIBarButtonItem()
        self.favViewBtn.target = self
        self.favViewBtn.action = "pushFav:"
        self.favViewBtn.title = "Favorite"
        
        self.navController = UINavigationController(rootViewController: TitleViewController())
        // ナビゲーションバー消す
        //self.navController?.navigationBarHidden = true
        //self.navController?.interactivePopGestureRecognizer.enabled = true
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()

        return true
    }

    func pushFav(sender: UIButton)
    {
        self.navController?.pushViewController(FavoriteViewController(), animated: true)
    }
    
    // SELECT用関数
    func selectDB(distinct: Bool, column:String, whereCmd:String) ->NSMutableArray
    {
        var retData : NSMutableArray = NSMutableArray()
        
        // DB open
        self.db.open()
        
        var sqlCmd = "SELECT "
                
        if (distinct == true)
        {
            sqlCmd += "DISTINCT "
        }
        
        if (whereCmd.isEmpty == false)
        {
            sqlCmd += column + " FROM CoolKanjiData WHERE " + whereCmd + ";"
        }
        else
        {
            sqlCmd += column + " FROM CoolKanjiData;"
        }
        
        let results : FMResultSet = db.executeQuery(sqlCmd, withArgumentsInArray: nil)
        
        while results.next()
        {
            retData.addObject(results.stringForColumn(column))
        }
        
        // DB close
        self.db.close()
        
        return retData
    }
    
    // UserDefault用関数
    func addFavID(id: Int)
    {
        if let favIDs = defaults.objectForKey("favoriteID") as? [Int]
        {
            let getArray = NSMutableArray(array:(defaults.objectForKey("favoriteID") as NSArray))
            getArray.addObject(id as Int)
            // 設定し直し
            defaults.setObject(getArray, forKey: "favoriteID")
            defaults.synchronize()
        }
    }
    func deleteFavID(id: Int)
    {
        if let favIDs = defaults.objectForKey("favoriteID") as? [Int]
        {
            let getArray = NSMutableArray(array:(defaults.objectForKey("favoriteID") as NSArray))
            getArray.removeObject(id as Int)
            // 設定し直し
            defaults.setObject(getArray, forKey: "favoriteID")
            defaults.synchronize()
        }
    }
    func cleanFavID()
    {
        if let favIDs = defaults.objectForKey("favoriteID") as? [Int]
        {
            let getArray = NSMutableArray(array:(defaults.objectForKey("favoriteID") as NSArray))
            getArray.removeAllObjects()
            // 設定し直し
            defaults.setObject(getArray, forKey: "favoriteID")
            defaults.synchronize()
        }
    }
    func favIDCont()->Int
    {
        var ret: Int = 0
        if let favIDs = defaults.objectForKey("favoriteID") as? [Int]
        {
            let getArray = defaults.objectForKey("favoriteID") as? NSMutableArray
            ret = getArray!.count
        }
        
        return ret
    }
    func getFavIDs()->NSMutableArray!
    {
        var retArray:NSMutableArray = NSMutableArray()
        if let favIDs = defaults.objectForKey("favoriteID") as? [Int]
        {
            retArray = NSMutableArray(array:(defaults.objectForKey("favoriteID") as NSArray))
        }
        return retArray
    }
    func getFavID(id: Int)->Int
    {
        var ret: Int = 0
        if let favIDs = defaults.objectForKey("favoriteID") as? [Int]
        {
            let getArray = defaults.objectForKey("favoriteID") as? NSMutableArray
            ret = getArray?.objectAtIndex(id) as Int
        }
        return ret 
    }
    func isFavIDSet(id: Int)->(isSet:Bool, index:Int)
    {
        var ret_isSet = false
        var ret_index = -1
        
        if let favIDs = defaults.objectForKey("favoriteID") as? [Int]
        {
            let getArray = defaults.objectForKey("favoriteID") as? NSMutableArray
            let ret_index = getArray?.indexOfObject(id)
            
            if (ret_index != NSNotFound)
            {
                ret_isSet = true
            }
        }
        return (ret_isSet, ret_index)
    }

    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

