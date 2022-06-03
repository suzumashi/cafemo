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
    
    // Viewの初期設定
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
    
    //バツボタンを押したら
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 保存ボタンを押したら
    @IBAction func didTapSubmitButton() {
        guard let _ = storeNameTextFeild.text else { return }
        
        saveSubmit()
        self.dismiss(animated: true)
    }
    
    // ツイートを保存するメソッド
    func saveSubmit() {
        guard let storeNameText = storeNameTextFeild.text else { return }

        let item = Item()
        item.storeNameText = storeNameText
        
        // もし画像がボタンにセットされてたら
        if let Image = imageButton.backgroundImage(for: .normal){
            //画像を保存
            let imageURLStr = saveImage(image: Image)
            item.imageFileName = imageURLStr
        }
        
        try! realm.write({
            realm.add(item)
        })
    }
    
    // 画像を保存
    func saveImage(image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return nil }
        
        do {
            let fileName = UUID().uuidString + ".jpeg"
            // 保存先のURLをゲット
            let imageURL = getImageURL(fileName: fileName)
            try imageData.write(to: imageURL)
            
                print("Failed to save the image:")
            return fileName
        } catch {
            print("Failed to save the image:", error)
            return nil
        }
    }
    
    // URLを取得
    func getImageURL(fileName: String) -> URL {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docDir.appendingPathComponent(fileName)
    }
    
    // 画像選択ボタンを押したときに実行
    @IBAction func didTapImageButton() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
//}
    
//extension AddInfoViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // ライブラリから戻ったときに実行
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return picker.dismiss(animated: true) }
        // imageButtonのバックグラウンドに画像を挿入
        //        self.dismiss(animated: true, completion: nil)
        //        photoImageView.image = info[.originalImage]as?UIImage
        imageButton.setBackgroundImage(pickedImage, for: .normal)
        picker.dismiss(animated: true)
    }
}
