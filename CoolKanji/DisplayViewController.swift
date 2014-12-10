//
//  DisplayViewController.swift
//  CoolKanji
//
//  Created by kayama on 2014/12/08.
//  Copyright (c) 2014年 kayama. All rights reserved.
//

import UIKit

class DisplayViewController: UIViewController {

    var m_id: Int!
    var ad: AppDelegate!
    
    init(id: Int)
    {
        super.init(nibName: nil, bundle: nil)
        self.m_id = id
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // AppDelegate
        ad = UIApplication.sharedApplication().delegate as AppDelegate

        
        let whereCmd = "index3=" + String(m_id) //後で治す
        
        let kanji = ad.selectDB(false, column: "kanji", whereCmd: whereCmd)
        //let idiom = ad.selectDB(false, column: "Idiom", whereCmd: whereCmd)
        
        
        
        let lblKanji = UILabel()
        
        
        
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
