//
//  AddInfoViewController.swift
//  cafelun
//
//  Created by 鈴木ましろ on 2022/05/23.
//

import Foundation
import UIKit
import RealmSwift

class AddInfoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet var storeNameTextFeild: UITextField!
    @IBOutlet var imageButton: UIButton!
    @IBOutlet var placeTextFeild: UITextField!
    @IBOutlet var urlTextFeild: UITextField!
    @IBOutlet var hasWent: UISegmentedControl!
    @IBOutlet var hasMirror: UISwitch!
    @IBOutlet var hasWifi: UISwitch!
    @IBOutlet var hasOutlet: UISwitch!
    @IBOutlet var memoTextFeild: UITextField!
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    // Viewの初期設定を行うメソッド
    func setUpViews() {
        imageButton.layer.cornerRadius = 8
        imageButton.imageView?.contentMode = .scaleAspectFill
    }
        
//        presenPickerController(sourceType: .photoLibrary)
//
//        func presenPickerController(sourceType: UIImagePickerController.SourceType){
//            if UIImagePickerController.isSourceTypeAvailable(sourceType){
//                let picker = UIImagePickerController()
//                picker.sourceType = sourceType
//                picker.delegate = self
//                self.present(picker,animated: true, completion: nil)
//            }
//        }
        // Do any additional setup after loading the view.
        
//    }

//    @IBAction func onTappedAlbumButton() {
//        presenPickerController(sourceType: .photoLibrary)
//        func presenPickerController(sourceType: UIImagePickerController.SourceType){
//            if UIImagePickerController.isSourceTypeAvailable(sourceType){
//                let picker = UIImagePickerController()
//                picker.sourceType = sourceType
//                picker.delegate = self
//                self.present(picker,animated: true, completion: nil)
//                }
//            }
//        }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey:Any]) {
//        self.dismiss(animated: true, completion: nil)
//        photoImageView.image = info[.originalImage]as?UIImage
//    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // ツイートボタンを押したときのアクション
    @IBAction func didTapTweetButton() {
        guard let _ = storeNameTextFeild.text else { return }
        
        saveSubmit()
        self.dismiss(animated: true)
    }
    
    // ツイートを保存するメソッド
    func saveSubmit() {
        guard let storeNameText = storeNameTextFeild.text else { return }

        let submit = Submit()
        submit.storeNameText = storeNameText// ツイートのテキストをセット
        
        // 画像がボタンにセットされてたら画像も保存
        if let tweetImage = imageButton.backgroundImage(for: .normal){
            let imageURLStr = saveImage(image: tweetImage) //画像を保存
            submit.imageFileName = imageURLStr
        }
        
        try! realm.write({
            realm.add(submit) // レコードを追加
        })
    }
    
    // 画像を保存するメソッド
    func saveImage(image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return nil }
        
        do {
            let fileName = UUID().uuidString + ".jpeg" // ファイル名を決定(UUIDは、ユニークなID)
            let imageURL = getImageURL(fileName: fileName) // 保存先のURLをゲット
            try imageData.write(to: imageURL) // imageURLに画像を書き込む
            return fileName
        } catch {
            print("Failed to save the image:", error)
            return nil
        }
    }
    
    // URLを取得するメソッド
    func getImageURL(fileName: String) -> URL {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docDir.appendingPathComponent(fileName)
    }
    
    // 画像選択ボタンを押したときのアクション
    @IBAction func didTapImageButton() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
//}
    
//extension AddInfoViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // ライブラリから戻ってきた時に呼ばれるデリゲートメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return picker.dismiss(animated: true) }
        // imageButtonのバックグラウンドに選択した画像をセット
        imageButton.setBackgroundImage(pickedImage, for: .normal)
        picker.dismiss(animated: true)
}
}
