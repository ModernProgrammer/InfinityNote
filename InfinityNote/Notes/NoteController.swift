//
//  NoteBookController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/24/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import Firebase

class NoteController:  UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    let headerId = "headerId"
    let cellId = "cellId"
    var notes = [Note]()
    var filteredNotes = [Note]()
    let ref = Database.database().reference()
    var notebookTitle: String? {
        didSet {
            navigationItem.title = notebookTitle
            let image = UIImage(named: "plusIcon")?.withRenderingMode(.alwaysOriginal)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleAddNoteButton))
            view.backgroundColor = paletteSystemWhite
        }
    }
    
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = paletteSystemWhite
        tableView.register(NoteCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotes()
        anchorCollectionView()
        tableView.fadeIn()
    }
    
    func anchorCollectionView() {
        view.addSubview(tableView)
        tableView.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        tableView.alpha = 0
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
        
        self.tableView.insertRows(at: [newIndexPath], with: .automatic)
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
            self.tableView.reloadData()
        }
    }
}

// MARK: -UITableView Functions
extension  NoteController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NoteCell
        cell.note = filteredNotes[indexPath.item]
        cell.colorBoarder.backgroundColor = indexPath.item % 2 == 0 ? paletteSystemGreen : paletteSystemBlue
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        print("Cell Index: ", indexPath.item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let noteEditorViewController = NoteEditorViewController()
        noteEditorViewController.note = filteredNotes[indexPath.item]
        let navNoteEditor = UINavigationController(rootViewController: noteEditorViewController)
        present(navNoteEditor, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let removeAction = UITableViewRowAction(style: .normal, title: "-") { (_, indexPath) in
//            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.removeNote(indexPath: indexPath)
        }
        removeAction.backgroundColor = .red
        return [removeAction]
    }
    
    func removeNote(indexPath: IndexPath) {
        let note = self.filteredNotes[indexPath.item]
        guard let uid = Auth.auth().currentUser?.uid else { return }
        self.ref.child(uid).child("notebooks").child(note.notebookTitle).child(note.noteTitle).removeValue { (err, ref) in
            if let err = err {
                print("Oops, looks like something went wrong: ", err)
            }
            print("Successfully removed: ", note)
            self.filteredNotes.remove(at: indexPath.item)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            print("Here and stuff")
        }
    }

}

