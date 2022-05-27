//
//  submit.swift
//  cafelun
//
//  Created by 鈴木ましろ on 2022/05/27.
//

import Foundation
import RealmSwift

class Submit: Object {
    @objc dynamic var storeNameText: String = ""
    @objc dynamic var imageFileName: String?
}
