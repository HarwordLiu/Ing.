//
//  ModelObjectTypeEnum.swift
//  Ing
//
//  Created by 刘浩 on 2017/9/5.
//  Copyright © 2017年 刘浩. All rights reserved.
//

import Foundation

enum ModelObjectType: String {
    case Task = "Task"
    case TaskType = "TaskType"
    case DeletedCloudKitObject = "DeletedCloudKitObject"
    
    init?(storyboardRestorationID: String) {
        switch storyboardRestorationID {
        case "TasksListScene" : self = .Task
        case "TaskTypesListScene" : self = .TaskType
        default : return nil
        }
    }
    
    static let allCloudKitModelObjectTypes = [
        ModelObjectType.Task.rawValue,
        ModelObjectType.TaskType.rawValue
    ]
}
