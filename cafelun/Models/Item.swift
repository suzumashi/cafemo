//
//  submit.swift
//  cafelun
//
//  Created by 鈴木ましろ on 2022/05/27.
//

import Foundation
import RealmSwift



//@IBOutlet var hasWent: UISegmentedControl!
//@IBOutlet var hasMirror: UISwitch!
//@IBOutlet var hasWifi: UISwitch!
//@IBOutlet var hasOutlet: UISwitch!

class Item: Object {
    @objc dynamic var storeNameText: String = ""
    @objc dynamic var imageFileName: String?
    @objc dynamic var placeText: String = ""
    @objc dynamic var urlText: String = ""
    
    @objc dynamic var hasMirror: String = ""
    @objc dynamic var hasWifi: String = ""
    @objc dynamic var hasOutlet: String = ""
    @objc dynamic var memoText: String = ""
}
