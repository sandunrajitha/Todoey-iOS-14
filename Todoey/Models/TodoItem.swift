//
//  TodoItem.swift
//  Todoey
//
//  Created by Sandun Liyanage on 12/19/20.
//

import Foundation

struct TodoItem {
    let title: String
    var isDone: Bool
    
    init(_ title: String, _ checked: Bool) {
        self.title = title
        self.isDone = checked
    }
}
