//
//  CoreDataProtocols.swift
//  Ing
//
//  Created by 刘浩 on 2017/8/16.
//  Copyright © 2017年 刘浩. All rights reserved.
//


import Foundation

protocol CoreDataManagerViewController {
    var coreDataManager: CoreDataManager? { get set }
    var modelObjectType: ModelObjectType? { get set }
}

@objc protocol CTBRootManagedObject {
    var name: String? { get set }
    var added: Date? { get set }
    var lastUpdate: Date? { get set }
    var notes: NSSet? { get set }
}
