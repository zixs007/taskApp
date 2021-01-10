//
//  Task.swift
//  taskApp
//
//  Created by 河崎優人 on 2021/01/08.
//  Copyright © 2021 yuto. All rights reserved.
//


import Foundation
import RealmSwift

class Task:Object{
    @objc dynamic var id =  0
    @objc dynamic var title = ""
    @objc dynamic var category = ""
    @objc dynamic var contents = ""
    @objc dynamic var date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
     
}
