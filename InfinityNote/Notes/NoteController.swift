//
//  NoteBookController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/24/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import Firebase

class NoteController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var searchBar: UISearchBar?
    
    var notebookTitle: String? {
        didSet {
            navigationItem.title = notebookTitle
            let image = UIImage(named: "plusIcon")?.withRenderingMode(.alwaysOriginal)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleAddNoteButton))
        }
    }
    
    let headerId = "headerId"
    let cellId = "cellId"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
        searchBar?.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.keyboardDismissMode = .onDrag
        collectionView?.backgroundColor = paletteSystemTan
        collectionView?.register(NoteHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(NoteCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        self.navigationItem.backBarButtonItem?.tintColor = paletteSystemGreen
        
        fetchNotes()
    }
    
    // Need this function in order to apend and insert notebook into collectionView
    func addNote(note: Note) {
        // 1 - modify your array
        filteredNotes.append(note)
        
        print("Count: ", filteredNotes.count-1)
        // 2 - insert a new index path into your collecionView
        let newIndexPath = IndexPath(item: filteredNotes.count-1, section: 0)
        
        self.collectionView?.insertItems(at: [newIndexPath])
    }
    
    @objc func handleAddNoteButton(){
        print("Add Note")
        let newNote = NewNoteController()
        guard let notebookTitle = self.notebookTitle else { return }
        newNote.notebookTitle = notebookTitle
        newNote.noteController = self
        
        let addNote = UINavigationController(rootViewController: newNote)
        present(addNote, animated: true, completion: nil)
    }
    
    var notes = [Note]()
    var filteredNotes = [Note]()
    func fetchNotes(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let notebookTitle = self.notebookTitle else { return }
    Database.database().reference().child(uid).child("notebooks").child(notebookTitle).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key,value) in
                guard let dictionary = value as? [String: Any] else { return }
                let note = Note(dictionary: dictionary, noteTitle: key, notebookTitle: notebookTitle, uid: uid)
                self.notes.append(note)
            })
            self.filteredNotes = self.notes
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
    
    // For Header
    // ----------------------
    // viewForSupplementaryElementOfKind
    // referenceSizeForHeaderInSection
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! NoteHeaderCell

        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 48)
    }
    
    // For CollectionView You Need...
    // ----------------------
    // numberOfItemsInSection
    // cellForItemAt
    // sizeForItemAt: Requires an extension of UICollectionViewDelegateFlowLayout
    // didSelectItemAt: Checks to see if you clicked on a cell
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredNotes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NoteCell
        cell.note = filteredNotes[indexPath.item]
        print("Cell Index: ", indexPath.item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width/3)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let noteEditorViewController = NoteEditorViewController()
        noteEditorViewController.note = filteredNotes[indexPath.item]
    
        navigationController?.pushViewController(noteEditorViewController, animated: true)
    }
    
    
}
