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

class BookmarkController:  UIViewController, UITableViewDataSource, UITableViewDelegate{
    let cellId = "cellId"
    var notes = [Note]()
    var fetchedNotes = [Note]()
    var refreshControl: UIRefreshControl!
    var animationLoader: AnimationView = {
        let view = AnimationView(name: "infinityLoader")
        view.contentMode = .scaleAspectFit
        view.play()
        return view
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
        refresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchBookmarkNotes()
    }
    
    @objc func refresh() {
        // Code to refresh table view
        fetchBookmarkNotes()
    }
    override func viewDidDisappear(_ animated: Bool) {
        tableView.alpha = 0
    }
    
}
// MARK: -UI/UX Functions
extension BookmarkController {
    func setupUI() {
        view.backgroundColor = paletteSystemWhite
        view.addSubview(tableView)
        tableView.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        setupNavBar(barTintColor: paletteSystemWhite, tintColor: paletteSystemGrayBlue, textColor: paletteSystemGrayBlue, clearNavBar: true, largeTitle: true)
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        navigationItem.title = "Bookmarks"
        animationLoader.frame = CGRect(x: view.center.x/4, y: view.center.y/3, width: 300, height: 300)
        
    }
    
    func fetchBookmarkNotes() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child(uid).child("notebooks").observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: AnyObject] else { return }
            self.notes.removeAll()
            self.fetchedNotes.removeAll()

            dictionaries.forEach({ (key,value) in
                guard let dictionary = value as? [String: AnyObject] else { return }
                let notebookTitle = key
                dictionary.forEach({ (key,value) in
                    guard let dic = dictionary[key] as? [String: AnyObject] else { return }
                    let noteTitle = key
                    
                    let bookmarkBool = dic["bookmark"] as? Bool
                    
                    if bookmarkBool == true {
                        let note = Note(dictionary: dic, noteTitle: noteTitle, notebookTitle: notebookTitle, uid: uid)
                        self.fetchedNotes.append(note)
                    }
                })
            })
            self.notes = self.sortNoteByDate(notes: self.fetchedNotes)
            self.refreshControl.endRefreshing()
            self.animationLoader.removeFromSuperview()
            self.tableView.alpha = 0
            self.tableView.reloadData()
            self.tableView.fadeIn()
        }
    }
}

// MARK: -UICollectionView Functions
extension BookmarkController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NoteCell
        cell.note = self.notes[indexPath.item]
        cell.colorBoarder.backgroundColor = indexPath.item % 2 == 0 ? paletteSystemGreen : paletteSystemBlue
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteEditorViewController = NoteEditorViewController()
        noteEditorViewController.note = notes[indexPath.item]
        let navNoteEditor = UINavigationController(rootViewController: noteEditorViewController)
        present(navNoteEditor, animated: true)
    }
}
