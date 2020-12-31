//
//  Category.swift
//  Todoey
//
//  Created by Sandun Liyanage on 12/28/20.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    //forward relationship - Category has Items
    var items = List<Item>()
}
