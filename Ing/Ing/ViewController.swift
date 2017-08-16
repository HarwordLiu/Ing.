//
//  ViewController.swift
//  Ing
//
//  Created by 刘浩 on 2017/8/12.
//  Copyright © 2017年 刘浩. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, CoreDataManagerViewDelegate, NSFetchedResultsControllerDelegate {
    
    var coreDataManager: HLCoreDataManager? {
        didSet {
            if isViewLoaded {
                //
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

