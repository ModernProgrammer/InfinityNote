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
    var cellId = "cellId"
    
    lazy var searchBar: UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.placeholder = "Search your notes"
        searchbar.endEditing(true)
        searchbar.delegate = self
        return searchbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = paletteSystemWhite
        navigationController?.navigationBar.addSubview(searchBar)
        collectionView?.register(SearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        
        let navbar = navigationController?.navigationBar
        searchBar.anchor(topAnchor: navbar?.topAnchor, bottomAnchor: navbar?.bottomAnchor, leadingAnchor: navbar?.leadingAnchor, trailingAnchor: navbar?.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
        collectionView?.keyboardDismissMode = .onDrag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        searchBar.isHidden = false
        
        fetchNotes()
    }
    
    var notes = [Note]()
    var filteredNotes = [Note]()
    fileprivate func fetchNotes() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        self.notes.removeAll()
        self.filteredNotes.removeAll()
        let ref = Database.database().reference().child(uid).child("notebooks")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            dictionary.forEach({ (key,value) in
                print("in dictionary")
                let notebookTitle = key
                guard let dic = dictionary[key] as? [String: AnyObject] else { return }
                dic.forEach({ (key, value) in
                    
                    guard let noteDic = value as? [String: AnyObject] else { return }
                    let noteTitle = key
                    
                    let note = Note(dictionary: noteDic, noteTitle: noteTitle, notebookTitle: notebookTitle, uid: uid)
                    self.notes.append(note)
                    
                })
            })
            self.filteredNotes = self.notes
            print(self.notes)
            self.collectionView?.reloadData()
        }
    }
    
    
    // For Searchbar control
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredNotes = notes
        }
        else {
            filteredNotes = self.notes.filter({ (notes) -> Bool in
                return notes.noteTitle.lowercased().contains(searchText.lowercased())
            })
        }
        self.collectionView?.reloadData()
    }
    
    
    // For CollectionView You Need...
    // ----------------------
    // numberOfItemsInSection
    // cellForItemAt
    // sizeForItemAt: Requires an extension of UICollectionViewDelegateFlowLayout
    // didSelectItemAt: Checks to see if you clicked on a cell
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredNotes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchCell
        cell.note = self.filteredNotes[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let noteEditor = NoteEditorViewController()
        let note = self.filteredNotes[indexPath.item]
        
        noteEditor.note = note
        noteEditor.searchBar = self.searchBar
        
        navigationController?.pushViewController(noteEditor, animated: true)
    }
    

}
