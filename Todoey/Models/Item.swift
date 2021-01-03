//
//  Item.swift
//  Todoey
//
//  Created by Sandun Liyanage on 12/28/20.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var dateCreated: Date?
    //Inverse relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
