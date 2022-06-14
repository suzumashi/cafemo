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
    
    @objc dynamic var opHText: String = ""
    @objc dynamic var opMinText: String = ""
    @objc dynamic var clHText: String = ""
    @objc dynamic var clMinText: String = ""
  
    @objc dynamic var hasWent: Bool = true
    @objc dynamic var hasMirror: Bool = true
    @objc dynamic var hasWifi: Bool = true
    @objc dynamic var hasOutlet: Bool = true
//    @objc dynamic var hasMirror: String = ""

    @objc dynamic var memoText: String = ""
}
