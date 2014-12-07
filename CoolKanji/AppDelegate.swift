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
    
    var db:FMDatabase!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        self.WWidth = window?.bounds.width
        self.WHeight = window?.bounds.height
        self.japanRed = UIColor(red: 230.0/255.0, green: 32.0/255.0, blue: 71.0/255.0, alpha: 1.0)
        
        // FMDB init with CoolKnji data
        let dataPath = NSBundle.mainBundle().pathForResource("testDB", ofType: "db")
        db = FMDatabase(path: dataPath)
        
        
        self.navController = UINavigationController(rootViewController: TitleViewController())
        // ナビゲーションバー消す
        self.navController?.navigationBarHidden = true
        self.window?.rootViewController = navController
        //self.window?.rootViewController = KanjiViewController()
        self.window?.makeKeyAndVisible()
        

        
        
        return true
    }

    // SELECT用関数
    func selectDB(distinct: Bool, column:String, whereCmd:String) ->NSMutableArray
    {
        var retData : NSMutableArray = NSMutableArray()
        
        // DB open
        self.db.open()
        
        var sqlCmd : String!
        if (whereCmd.isEmpty == false)
        {
            sqlCmd = "SELECT " + column + " FROM CoolKanjiData WHERE " + whereCmd + ";"
        }
        else
        {
            if (distinct == true)
            {
                sqlCmd = "SELECT DISTINCT " + column + " FROM CoolKanjiData;"
            }
            else
            {
                sqlCmd = "SELECT " + column + " FROM CoolKanjiData;"
            }
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

