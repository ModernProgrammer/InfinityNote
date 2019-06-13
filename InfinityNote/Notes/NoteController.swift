//
//  NoteBookController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/24/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import Firebase

class NoteController:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let headerId = "headerId"
    let cellId = "cellId"
    var notes = [Note]()
    var filteredNotes = [Note]()
    
    var notebookTitle: String? {
        didSet {
            navigationItem.title = notebookTitle
            let image = UIImage(named: "plusIcon")?.withRenderingMode(.alwaysOriginal)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleAddNoteButton))
            view.backgroundColor = paletteSystemWhite
        }
    }
    
    lazy var collectionView : UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowlayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = paletteSystemWhite
        collectionView.alwaysBounceVertical = true
        collectionView.isPagingEnabled = false
        collectionView.register(NoteCell.self, forCellWithReuseIdentifier: cellId)
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotes()
        anchorCollectionView()
        collectionView.fadeIn()
    }
    
    func anchorCollectionView() {
        view.addSubview(collectionView)
        collectionView.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        collectionView.alpha = 0
    }
}


// MARK: -Note Functions
extension NoteController {
    // Need this function in order to apend and insert notebook into collectionView
    func addNote(note: Note) {
        // 1 - modify your array
        filteredNotes.append(note)
        
        print("Count: ", filteredNotes.count-1)
        // 2 - insert a new index path into your collecionView
        let newIndexPath = IndexPath(item: filteredNotes.count-1, section: 0)
        
        self.collectionView.insertItems(at: [newIndexPath])
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
            self.collectionView.reloadData()
        }
    }
}

// MARK: -UICollectionView Functions
extension  NoteController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredNotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NoteCell
        cell.note = filteredNotes[indexPath.item]
        print("Cell Index: ", indexPath.item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let noteEditorViewController = NoteEditorViewController()
        noteEditorViewController.note = filteredNotes[indexPath.item]
        
        navigationController?.pushViewController(noteEditorViewController, animated: true)
    }
    
}

