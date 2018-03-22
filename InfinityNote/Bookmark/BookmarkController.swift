//
//  BookmarkController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/16/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class BookmarkController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    
    var refreshControl: UIRefreshControl!

    var animationLoader: LOTAnimationView = {
        let view = LOTAnimationView(name: "infinityLoader")
        view.contentMode = .scaleAspectFit
        view.play()
        view.loopAnimation = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = paletteSystemWhite
        collectionView?.register(BookmarkCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refreshControl)
        
        navigationItem.title = "Bookmarks"
        collectionView?.addSubview(animationLoader)
        animationLoader.frame = CGRect(x: view.center.x/4, y: view.center.y/3, width: 300, height: 300)
        fetchBookmarkNotes()
    }
    
    @objc func refresh() {
        // Code to refresh table view
        fetchBookmarkNotes()
    }
    
    var notes = [Note]()
    func fetchBookmarkNotes() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child(uid).child("notebooks").observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: AnyObject] else { return }
            self.notes.removeAll()

            dictionaries.forEach({ (key,value) in
                guard let dictionary = value as? [String: AnyObject] else { return }
                let notebookTitle = key
                dictionary.forEach({ (key,value) in
                    guard let dic = dictionary[key] as? [String: AnyObject] else { return }
                    let noteTitle = key
                    
                    let bookmarkBool = dic["bookmark"] as? Bool
                    
                    if bookmarkBool == true {
                        let note = Note(dictionary: dic, noteTitle: noteTitle, notebookTitle: notebookTitle, uid: uid)
                        self.notes.append(note)
                    }
                })
            })
            self.refreshControl.endRefreshing()
            self.animationLoader.loopAnimation = false
            self.animationLoader.removeFromSuperview()
            self.collectionView?.reloadData()
        }
    }
    
   
    
    // For CollectionView You Need...
    // ----------------------
    // numberOfItemsInSection
    // cellForItemAt
    // sizeForItemAt: Requires an extension of UICollectionViewDelegateFlowLayout
    // didSelectItemAt: Checks to see if you clicked on a cell
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BookmarkCell
        cell.bookmarkNote = self.notes[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let noteEditorViewController = NoteEditorViewController()
        noteEditorViewController.note = notes[indexPath.item]
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
