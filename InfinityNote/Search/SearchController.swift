//
//  SearchController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/16/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import Firebase

class SearchController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    var cellId = "cellId"
    var notes = [Note]()
    var filteredNotes = [Note]()
    lazy var searchBar: UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.placeholder = "Search your notes"
        searchbar.endEditing(true)
        searchbar.delegate = self
        return searchbar
    }()
    
    lazy var collectionView : UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowlayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = paletteSystemWhite
        collectionView.alwaysBounceVertical = true
        collectionView.isPagingEnabled = false
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: cellId)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar(barTintColor: paletteSystemWhite, tintColor: paletteSystemGrayBlue, textColor: paletteSystemGrayBlue, clearNavBar: true, largeTitle: true)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        searchBar.isHidden = false
        collectionView.alpha = 0
        collectionView.keyboardDismissMode = .onDrag
        fetchNotes()
    }
    
    func setupUI() {
        navigationItem.title = "Search"
        navigationController?.navigationBar.addSubview(searchBar)
        view.addSubview(searchBar)
        searchBar.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, bottomAnchor: nil, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 44)
        searchBar.barTintColor = paletteSystemWhite
        searchBar.backgroundColor = paletteSystemWhite
        view.addSubview(collectionView)
        view.backgroundColor = paletteSystemWhite
        collectionView.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 44, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        collectionView.alpha = 0
    }
}

// MARK: -Search Functions
extension SearchController {
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
            self.collectionView.reloadData()
            self.collectionView.fadeIn()
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
        self.collectionView.reloadData()
    }
}

// MARK: -UICollectionView functions
extension SearchController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredNotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchCell
        cell.note = self.filteredNotes[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let noteEditor = NoteEditorViewController()
        let note = self.filteredNotes[indexPath.item]
        
        noteEditor.note = note
        noteEditor.searchBar = self.searchBar
        
        navigationController?.pushViewController(noteEditor, animated: true)
    }
}
