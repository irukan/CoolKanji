//
//  CategoryViewController.swift
//  CoolKanji
//
//  Created by kayama on 2014/12/05.
//  Copyright (c) 2014年 kayama. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {


    var ad: AppDelegate!
    var m_column: String!
    var m_setItem: String!
    
    init(columnName: String) {
        super.init(nibName: nil, bundle: nil)
        
        // AppDelegate
        ad = UIApplication.sharedApplication().delegate as AppDelegate
        
        m_column = columnName
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()

        
        let dd = ad.selectDB(true, column: m_column, whereCmd: "")
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidDisappear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {

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
