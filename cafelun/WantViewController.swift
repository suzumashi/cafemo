//
//  WantViewController.swift
//  cafelun
//
//  Created by 鈴木ましろ on 2022/05/22.
//

import UIKit
import RealmSwift

class WantViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var addButton: UIButton!
    
    let realm = try! Realm()
    
    var collection = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //データベースファイルのパスを表示
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        getItemData()
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
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        guard let itemImageView = cell.viewWithTag(4) as? UIImageView else { return cell }
        
        let item = collection[indexPath.row]
        
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
        return cell
    }
    
    // URLを取得するメソッド
    func getImageURL(fileName: String) -> URL {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docDir.appendingPathComponent(fileName)
    }
    
    
    // Cellのサイズを設定するデリゲートメソッド
    func collectionView(_ collectionView: UICollectionView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = collection[indexPath.row]
        return item.imageFileName == nil ? 100 : 100
        
    }
}
