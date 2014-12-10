//
//  TitleViewController.swift
//  CoolKanji
//
//  Created by kayama on 2014/12/05.
//  Copyright (c) 2014年 kayama. All rights reserved.
//

import UIKit

class TitleViewController: UIViewController {

    var ad :AppDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // AppDelegate
        ad = UIApplication.sharedApplication().delegate as AppDelegate
        
        self.view.backgroundColor = UIColor.whiteColor()
    
        let titleLbl = UILabel(frame: CGRectMake(50, 100, 300, 100))
        titleLbl.sizeThatFits(CGSizeMake(300, 100))
        titleLbl.font = UIFont(name: "ackaisyo", size: 50)
        titleLbl.textColor = UIColor.blackColor()
        titleLbl.text = "Cool Kanji"
        self.view.addSubview(titleLbl)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
  
        self.navigationController?.pushViewController(CategoryViewController(columnName: "index1"), animated: true)
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
