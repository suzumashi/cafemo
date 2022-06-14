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
    @IBOutlet var hasWentSegmentedControl: UISegmentedControl!
    @IBOutlet var hasMirrorSwitch: UISwitch!
    @IBOutlet var hasWifiSwitch: UISwitch!
    @IBOutlet var hasOutletSwitch: UISwitch!
    @IBOutlet var memoTextFeild: UITextField!
    
    @IBOutlet var imageView: UIImageView!
    var selectedImg: UIImage!

    
    var hasWent: Bool = true
    var hasMirror: Bool = true
    var hasWifi: Bool = true
    var hasOutlet: Bool = true
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()

        self.placeTextFeild.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
//        imageView.image = selectedImg
        // 画像のアスペクト比を維持しUIImageViewサイズに収まるように表示
//        imageView.contentMode = UIView.ContentMode.scaleAspectFit
//
        //        let imagePickerController = UIImagePickerController()
        //        imagePickerController.delegate = self
        //        present(imagePickerController, animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            } else {
                let suggestionHeight = self.view.frame.origin.y + keyboardSize.height
                self.view.frame.origin.y -= suggestionHeight
            }
        }
    }
    
    @objc func keyboardWillHide() {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    @IBAction func hasWentSegmented(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            hasWent = true
            print("hasWentSegmented 行きたい")
            break
        case 1:
            hasWent = false
            print("hasWentSegmented 行った")
            break
        default:
            print("Error")
            break
        }
    }
    
    @IBAction func hasMirrorSwitch(_ sender: UISwitch) {
        if sender.isOn == true {
            hasMirror = true
            print("hasMirror true")
            //ボタンがオフの時の処理
        } else {
            hasMirror = false
            print("hasMirror false")
        }
    }
    
    @IBAction func hasWifiSwitch(_ sender: UISwitch) {
        if sender.isOn == true {
            hasWifi = true
            print("hasWifi true")
            //ボタンがオフの時の処理
        } else {
            hasWifi = false
            print("hasWifi false")
        }
    }
    
    @IBAction func hasOutletSwitch(_ sender: UISwitch) {
        if sender.isOn == true {
            hasOutlet = true
            print("hasOutlet true")
            //ボタンがオフの時の処理
        } else {
            hasOutlet = false
            print("hasOutlet false")
        }
    }
    
    // 保存ボタンを押したら
    @IBAction func didTapSubmitButton() {
        guard let _ = storeNameTextFeild.text else { return }
        guard let _ = placeTextFeild.text else { return }
        guard let _ = urlTextFeild.text else { return }
        guard let _ = memoTextFeild.text else { return }
        
        saveSubmit()
        self.dismiss(animated: true)
    }
    
    
    // ツイートを保存するメソッド
    func saveSubmit() {
        //オプショナル型(アンラップ)
        guard let storeNameText = storeNameTextFeild.text else { return }
        guard let placeText = placeTextFeild.text else { return }
        guard let urlText = urlTextFeild.text else { return }
        guard let memoText = memoTextFeild.text else { return }
        
        let item = Item()
        item.storeNameText = storeNameText
        item.placeText = placeText
        item.urlText = urlText
        item.memoText = memoText
        item.hasWent = hasWent
        item.hasMirror = hasMirror
        item.hasWifi = hasWifi
        item.hasOutlet = hasOutlet
        
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
        imageButton.setBackgroundImage(pickedImage, for: .normal)
        picker.dismiss(animated: true)
    }

    
}

extension AddInfoViewController: UITextFieldDelegate {
    
    func placeTextFeild(_ placeTextFeild: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
