//
//  WantViewController.swift
//  cafelun
//
//  Created by 鈴木ましろ on 2022/05/22.
//

import UIKit
import RealmSwift

class WantCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var addButton: UIButton!
    
    let realm = try! Realm()
    
    var indexNum = 0
    var id: String?
    var itemBox: String?
    
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
        
        //長押し時の判定
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressAction))
            longPressRecognizer.allowableMovement = 10
            longPressRecognizer.minimumPressDuration = 1
            self.collectionView.addGestureRecognizer(longPressRecognizer)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getItemData()
    }
    
    @objc func onLongPressAction(sender: UILongPressGestureRecognizer) {
            let point: CGPoint = sender.location(in: self.collectionView)
            let indexPath = self.collectionView.indexPathForItem(at: point)
            if let indexPath = indexPath {
                //何らかの処理
                print("a")
            }
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
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        guard let itemImageView = cell.viewWithTag(4) as? UIImageView else {
            return cell
        }
        
        let item = collection[indexPath.row]
        
        if item.hasWent == true {
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
        } else {
            print("WantCollection")
        }
        return cell
    }
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return collection.count
        }
    
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
        
        let item = collection[indexPath.row]
        itemBox = item.imageFileName
//        print(itemBox.1)

        performSegue(withIdentifier: "WantCollectionViewController", sender: nil)
        print(indexNum)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "WantCollectionViewController") {
            let nextVC: DisplayViewController = (segue.destination as? DisplayViewController)!
            nextVC.num = indexNum

        }
    }
    
    // ＋ボタンを押したら追加画面へ遷移
    @IBAction func didTapButton() {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddInfoViewController") as! AddInfoViewController
        self.present(secondViewController, animated: true, completion: nil)

    }
}
