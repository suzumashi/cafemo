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
    
    @objc dynamic var hasMirrorON = true
    @objc dynamic var hasMirrorOff = false
    
    @objc dynamic var hasWifiOn = true
    @objc dynamic var hasWifiOff = false
    
    @objc dynamic var hasOutletOn = true
    @objc dynamic var hasOutletOff = false
    
    @objc dynamic var memoText: String = ""
}
