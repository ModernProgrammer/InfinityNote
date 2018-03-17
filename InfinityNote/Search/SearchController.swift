//
//  SearchController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/16/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import Firebase

class SearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    lazy var searchBar: UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.placeholder = "Search for Note"
        return searchbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = paletteSystemWhite
        navigationController?.navigationBar.addSubview(searchBar)
        collectionView?.keyboardDismissMode = .onDrag

        let navbar = navigationController?.navigationBar
        searchBar.anchor(topAnchor: navbar?.topAnchor, bottomAnchor: navbar?.bottomAnchor, leadingAnchor: navbar?.leadingAnchor, trailingAnchor: navbar?.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
        fetchNotes()
    }
    
    
    var notes = [Note]()
    var filteredNotes = [Note]()
    fileprivate func fetchNotes() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let ref = Database.database().reference().child(uid).child("notebooks")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let notebookTitle = snapshot.key
            dictionary.forEach({ (key,value) in
                guard let dic = dictionary[key] as? [String: AnyObject] else { return }
                let noteTitle = key
                
                let bookmarkBool = dic["bookmark"] as? Bool
                
                if bookmarkBool == true {
                    let note = Note(dictionary: dic, noteTitle: noteTitle, notebookTitle: notebookTitle, uid: uid)
                    self.notes.append(note)
                    print(self.notes)
                }
            })
        }
    }
    
    
    // For Searchbar control
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    
    
    // For CollectionView You Need...
    // ----------------------
    // numberOfItemsInSection
    // cellForItemAt
    // sizeForItemAt: Requires an extension of UICollectionViewDelegateFlowLayout
    // didSelectItemAt: Checks to see if you clicked on a cell
    
}
