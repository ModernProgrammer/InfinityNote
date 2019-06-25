//
//  SearchController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/16/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import Firebase

class SearchController: UIViewController, UITableViewDataSource, UITableViewDelegate,  UISearchBarDelegate {

    
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
    
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = paletteSystemWhite
        tableView.register(NoteCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar(barTintColor: paletteSystemWhite, tintColor: paletteSystemGrayBlue, textColor: paletteSystemGrayBlue, clearNavBar: true, largeTitle: true)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        searchBar.isHidden = false
        tableView.alpha = 0
        tableView.keyboardDismissMode = .onDrag
        fetchNotes()
    }
    
    func setupUI() {
        navigationItem.title = "Search"
        navigationController?.navigationBar.addSubview(searchBar)
        view.addSubview(searchBar)
        searchBar.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, bottomAnchor: nil, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 44)
        searchBar.barTintColor = paletteSystemWhite
        searchBar.backgroundColor = paletteSystemWhite
        view.addSubview(tableView)
        view.backgroundColor = paletteSystemWhite
        tableView.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 44, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        tableView.alpha = 0
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
            self.filteredNotes = self.sortNoteByDate(notes: self.notes)
            self.tableView.reloadData()
            self.tableView.fadeIn()
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
        self.tableView.reloadData()
    }
}

// MARK: -UITableView functions
extension SearchController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NoteCell
        cell.note = self.filteredNotes[indexPath.item]
        cell.colorBoarder.backgroundColor = indexPath.item % 2 == 0 ? paletteSystemGreen : paletteSystemBlue
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteEditorViewController = NoteEditorViewController()
        noteEditorViewController.note = filteredNotes[indexPath.item]
        let navNoteEditor = UINavigationController(rootViewController: noteEditorViewController)
        present(navNoteEditor, animated: true)
    }
}
