//
//  CategoryViewController.swift
//  CoolKanji
//
//  Created by kayama on 2014/12/05.
//  Copyright (c) 2014年 kayama. All rights reserved.
//

import UIKit

class parentInfo: NSObject {
    var m_setItem: String!
    var m_column: String!
    
    init(setItem: String, column: String)
    {
        m_setItem = setItem
        m_column = column
    }
}

class CategoryViewController: UIViewController {


    var ad: AppDelegate!
    var m_column: String!
    var m_setItem: String!
    
    var items: NSMutableArray!
    var buttons: NSMutableArray!
    
    
    init(columnName: String) {
        super.init(nibName: nil, bundle: nil)
        
        // AppDelegate
        ad = UIApplication.sharedApplication().delegate as AppDelegate
        
        m_column = columnName
        
        // 上位階層のCateforyViewControllerの選択項目を取得する　←後で共通化する
        let parentInformation: NSMutableArray = NSMutableArray()
        
        let viewCs = ad.navController!.viewControllers as NSArray
        for (var i=0; i<viewCs.count; i++)
        {
            let tempViewC: AnyObject = viewCs.objectAtIndex(i)
            if (tempViewC as? CategoryViewController != nil)
            {
                parentInformation.addObject(parentInfo(setItem: tempViewC.m_setItem, column: tempViewC.m_column))
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
        
        items = ad.selectDB(true, column: m_column, whereCmd: whereCmdInput)
        buttons = NSMutableArray()
        
        for (var i = 0; i < items.count; i++)
        {
            let btn = UIButton()
            btn.setTitle(items[i] as? String, forState: UIControlState.Normal)
            btn.backgroundColor = ad.japanRed//UIColor.redColor()
            btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            btn.addTarget(self, action: "pushBtn:", forControlEvents: UIControlEvents.TouchDown)
            
            buttons.addObject(btn)
        }
        
    }
    
    func pushBtn(sender: UIButton)
    {
        self.m_setItem = sender.titleForState(UIControlState.Normal)
        
        switch m_column
        {
            case "index1" :
                self.navigationController?.pushViewController(CategoryViewController(columnName: "index2"), animated: true)
                
            case "index2":
                self.navigationController?.pushViewController(KanjiViewController(), animated: true)
                
            default:
                break
        }
        

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()

        let scrollView = UIScrollView(frame: self.view.bounds)
        
        // buttons の位置決め
        var offset: CGFloat = 120
        
        for (var i=0; i < buttons.count; i++)
        {
            (buttons[i] as UIButton).frame = CGRectMake(ad.WWidth*0.2, 50 + offset * CGFloat(i), 200, 50)
            scrollView.addSubview(buttons[i] as UIButton)
        }
        
        // 一番下のボタンのちょい下あたりまでの高さにする
        let lastBtnpos = (buttons.lastObject as UIButton).frame.origin
        scrollView.contentSize = CGSizeMake(self.view.bounds.width, lastBtnpos.y + 120)
        
        scrollView.addSubview(buttons[0] as UIButton)
        
        
        self.view.addSubview(scrollView)
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
