//
//  BookmarkController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/16/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import Firebase

class BookmarkController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = paletteSystemWhite
        collectionView?.register(BookmarkCellController.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true

        fetchBookmarkNotes()
    }
    
    var notes = [Note]()
    func fetchBookmarkNotes() {
        //print(self.Note)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child(uid).child("notebooks").observeSingleEvent(of: .value) { (snapshot) in
//            guard let dictionaries = snapshot.value as? [String: Any] else { return }
//            print(snapshot.children)
//            var num = 0
//            dictionaries.forEach({ (key,value) in
//                print(num)
//                guard let dictionary = value as? [String: AnyObject] else { return }
//                print("Keys: ", dictionary.keys.first)
//                guard let dic = dictionary["Another "] as? [String: AnyObject] else { return }
//                print("Bookmark ",dic["bookmark"])
//                num = num + 1
//
//            })
//            self.collectionView?.reloadData()
        }
    }
    
   
    
    // For CollectionView You Need...
    // ----------------------
    // numberOfItemsInSection
    // cellForItemAt
    // sizeForItemAt: Requires an extension of UICollectionViewDelegateFlowLayout
    // didSelectItemAt: Checks to see if you clicked on a cell
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BookmarkCellController
        //cell.bookmarkednote = note[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let noteEditorViewController = NoteEditorViewController()
        //noteEditorViewController.note = notes[indexPath.item]
        print("Yo: ",indexPath.item)
        navigationController?.pushViewController(noteEditorViewController, animated: true)
    }
    
    // For spacing between the cells
    // minimumLineSpacingForSectionAt
    // minimumInteritemSpacingForSectionAt

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
