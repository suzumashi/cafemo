//
//  DisplayViewController.swift
//  cafelun
//
//  Created by 鈴木ましろ on 2022/06/14.
//

import UIKit
import RealmSwift

class DisplayViewController: UIViewController {
    
    var todoItems:Results<Item>!
    
    @IBOutlet var hasWentLabel: UILabel!
    @IBOutlet var storeNameLabel: UILabel!
    @IBOutlet var ImageView: UIImageView!
    @IBOutlet var placeLabel: UILabel!
    
    @IBOutlet var opHText: UILabel!
    @IBOutlet var opMinText: UILabel!
    @IBOutlet var clHText: UILabel!
    @IBOutlet var clMinText: UILabel!
    
    @IBOutlet var hasMirrorLabel: UILabel!
    @IBOutlet var hasWifiLabel: UILabel!
    @IBOutlet var hasOutletLabel: UILabel!
    @IBOutlet var noMirrorLabel: UILabel!
    @IBOutlet var noWifiLabel: UILabel!
    @IBOutlet var noOutletLabel: UILabel!
    
    @IBOutlet var urlButton: UIButton!
    @IBOutlet var urlLabel: UILabel!
    @IBOutlet var availLable: UILabel!
    @IBOutlet var notLabel: UILabel!
    @IBOutlet var memoLabel: UILabel!

    @IBOutlet var backButton: UIButton!
    
    var likeLabelTo: Bool?
    var num = Int()
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ImageView.layer.cornerRadius = ImageView.frame.size.width * 0.05
        ImageView.clipsToBounds = true
        
        let realm = try! Realm()
        todoItems = realm.objects(Item.self)
        
        let object = todoItems[num]

        storeNameLabel.text = object.storeNameText
        if let imageFileName = object.imageFileName {
            // 画像のパスを取得
            let path = getImageURL(fileName: imageFileName).path
            if FileManager.default.fileExists(atPath: path) {
                // pathに保存されている画像を取得
                if let imageData = UIImage(contentsOfFile: path) {
                    ImageView.image = imageData
                    print("\(imageData)")
                    
                } else {
                    print("Failed to load the image. path")
                }
            } else {
                print("Image file not found. path")
            }
        }
        // URLを取得するメソッド
        func getImageURL(fileName: String) -> URL {
            let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            return docDir.appendingPathComponent(fileName)
        }

        
        if object.hasMirror == true {
            hasMirrorLabel.text = "鏡"
        } else {
            noMirrorLabel.text = "鏡"
        }
        
        if object.hasWifi == true {
            hasWifiLabel.text = "Wi-Fi"
        } else {
            noWifiLabel.text = "Wi-Fi"
        }
        
        if object.hasOutlet == true {
            hasOutletLabel.text = "コンセント"
        } else {
            noOutletLabel.text = "コンセント"
        }
        
        opHText.text = object.opHText
        opMinText.text = object.opMinText
        clHText.text = object.clHText
        clMinText.text = object.clMinText
        
//        placeLabel.text = object.placeText
//        urlLabel.text = object.urlText
        urlButton.setTitle(object.urlText, for: .normal)
        memoLabel.text = object.memoText
        
        if object.hasWent == true {
            hasWentLabel.text = "行きたい"
        } else {
            hasWentLabel.text = "行った"
        }
        
        // Do any additional setup after loading the view.
    }
    
    //バツボタンを押したら
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func terms(_ sender: Any) {
        let object = todoItems[num]
        let url = URL(string: object.urlText)!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
