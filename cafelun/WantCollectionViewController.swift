//
//  WantViewController.swift
//  cafelun
//
//  Created by 鈴木ましろ on 2022/05/22.
//

import UIKit
import RealmSwift

class WantCollectionViewController: UIViewController{
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var addButton: UIButton!
    
    let realm = try! Realm()
    
    var collection = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //関数を設定する(自分自身をセットする)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //データベースファイルのパスを表示
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        getItemData()
        
        print("viewdid done")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getItemData()
    }
    
    
    
    // Realmからデータを取得してテーブルビューを再リロードするメソッド
    func getItemData() {
        //保存されている配列を全て取り出す
        collection = Array(realm.objects(Item.self)).reversed()
        print("realm")
        //画面をリロードして最新に
        collectionView.reloadData()
        print("reloadData")
    }


}

extension WantCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        guard let itemImageView = cell.viewWithTag(4) as? UIImageView else {
            return cell
        }
        
        let item = collection[indexPath.row]
        
        if let imageFileName = item.imageFileName {
            // 画像のパスを取得
            let path = getImageURL(fileName: imageFileName).path
            if FileManager.default.fileExists(atPath: path) {
                // pathに保存されている画像を取得
                if let imageData = UIImage(contentsOfFile: path) {
                    itemImageView.image = imageData
                    print("\(imageData)")
                    
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
    
}
extension WantCollectionViewController: UICollectionViewDelegateFlowLayout{
    // Cellのサイズを設定するデリゲートメソッド
    func collectionView(_ collectionView: UICollectionView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let item = collection[indexPath.row]
        return item.imageFileName == nil ? 10 : 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 2 // 行間
    }
}
