//
//  Items.swift
//  Todoey
//
//  Created by Ferdous Mahmud Akash on 12/18/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object{
    @objc dynamic var checkStatus: Bool = false
    @objc dynamic var itmeTitle: String = ""
    
    // Backword relation
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

