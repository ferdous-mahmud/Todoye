//
//  data.swift
//  Todoey
//
//  Created by Ferdous Mahmud Akash on 12/18/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
