//
//  WentViewController.swift
//  cafelun
//
//  Created by 鈴木ましろ on 2022/05/22.
//

import UIKit
import RealmSwift

class VisitCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var AddButton: UIButton!
    
    let realm = try! Realm()
    
    var selectedImage: UIImage?
    
    var collection = [Item]()

    var indexNum = 0
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //関数を設定する(自分自身をセットする)
        collectionView.delegate = self
        collectionView.dataSource = self

        //データベースファイルのパスを表示
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        getItemData()
        
//        imageView.image = selectedImg
        // 画像のアスペクト比を維持しUIImageViewサイズに収まるように表示
//        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getItemData()
    }
    
    
    // Realmからデータを取得してテーブルビューを再リロードするメソッド
    func getItemData() {
        //保存されている配列を全て取り出す
        collection = Array(realm.objects(Item.self)).reversed()
        //画面をリロードして最新に
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collection.count
//        var collectionNumber: Int = 0
//            if collection.count >= 1{
//                for i in 0...collection.count - 1 {
//                    if collection[i].hasWent == false {
//                        collectionNumber += 1
//                    } else {
//                        //
//                    }
//                }
//            } else {
//                collectionNumber = 0
//            }
//            return collectionNumber
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        guard let itemImageView = cell.viewWithTag(4) as? UIImageView else { return cell }
        
        let item = collection[indexPath.row]
        
//        if item.hasWent == false {
            if let imageFileName = item.imageFileName {
                // 画像のパスを取得
                let path = getImageURL(fileName: imageFileName).path
                if FileManager.default.fileExists(atPath: path) {
                    // pathに保存されている画像を取得
                    if let imageData = UIImage(contentsOfFile: path) {
                        itemImageView.image = imageData
                        
                    } else {
                        print("Failed to load the image. path")
                    }
                } else {
                    print("Image file not found. path")
                }
            }
//        } else {
//            print("VisitCollection")
//        }
        return cell
    }
    
    // Cell が選択された場合
//    func collectionView(_ collectionView: UICollectionView,
//                          didSelectItemAt indexPath: IndexPath) {
//
//        // [indexPath.row] から画像名を探し、UImage を設定
//        let item = collection[indexPath.row]
//        let imageFileName = item.imageFileName
//        selectedImage = UIImage(named: imageFileName[indexPath.row])
//        if selectedImage != nil {
//            // SubViewController へ遷移するために Segue を呼び出す
//            performSegue(withIdentifier: "AddInfoViewController",sender: nil)
//        }
//
//    }

    // URLを取得するメソッド
    func getImageURL(fileName: String) -> URL {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docDir.appendingPathComponent(fileName)
    }
    
    // Cellのサイズを設定するデリゲートメソッド
    func collectionView(_ collectionView: UICollectionView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = collection[indexPath.row]
        return item.imageFileName == nil ? 10 : 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2 // 行間
    }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print("Cellがタップされた！")
            collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            indexNum = indexPath.row
            performSegue(withIdentifier: "VisitCollectionViewController", sender: nil)
            print(indexNum)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "VisitCollectionViewController") {
            let nextVC: DisplayViewController = (segue.destination as? DisplayViewController)!
            nextVC.num = indexNum
        }
    }
    
    // ＋ボタンを押したら追加画面へ遷移
    @IBAction func didTapButton(_ sender: UIButton){
        performSegue(withIdentifier: "AddInfoView", sender: nil)
    }
}
