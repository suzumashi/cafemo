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
    @IBOutlet var tweetButton: UIButton!

    let realm = try! Realm()

    var collection = [Submit]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getTweetData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTweetData()
    }


    // Realmからデータを取得してテーブルビューを再リロードするメソッド
    func getTweetData() {
        collection = Array(realm.objects(Submit.self)).reversed()  // Realm DBから保存されてるツイートを全取得
        collectionView.reloadData() // テーブルビューをリロード
    }


func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    collection.count
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) // 表示するセルを登録(先程命名した"Cell")
            guard let tweetImageView = cell.viewWithTag(4) as? UIImageView else { return cell }
    
            let submit = collection[indexPath.row]
    
            if let imageFileName = submit.imageFileName {
                let path = getImageURL(fileName: imageFileName).path // 画像のパスを取得
                if FileManager.default.fileExists(atPath: path) { // pathにファイルが存在しているかチェック
                    if let imageData = UIImage(contentsOfFile: path) { // pathに保存されている画像を取得
                        tweetImageView.image = imageData
                    } else {
                        print("Failed to load the image. path = ", path)
                    }
                } else {
                    print("Image file not found. path = ", path)
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
        let submit = collection[indexPath.row]
        return submit.imageFileName == nil ? 100 : 100
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace : CGFloat = 10
        let cellSize : CGFloat = self.view.bounds.width / 3 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }

}
