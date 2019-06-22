//
//  SelectNoteBookController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 3/5/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import Firebase
import Lottie
class SelectNoteBookController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var notebooks = [Notebook]()

    var newNoteController: NewNoteController?
    let cellId = "cellId"
    let headerId = "headerId"
    let ref = Database.database().reference()
    var animationView: AnimationView = {
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotebooks()
        animationView.frame = CGRect(x: view.center.x/4, y: view.center.y/3, width: 300, height: 300)
        setupNavigationController()
        view.backgroundColor = paletteSystemWhite
        view.addSubview(tableView)
        tableView.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Fetching 1")
    }
    

    func setupNavigationController() {
        setupNavBar(barTintColor: paletteSystemBlue, tintColor: paletteSystemGreen, textColor: paletteSystemGrayBlue, clearNavBar: true, largeTitle: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plusIcon"), style: .plain, target: self, action: #selector(handleAddNotebookButton))
        navigationItem.title = "Select Notebook"
    }

}

// MARK: -Notebook Functions
extension SelectNoteBookController {
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func addNotebook(notebook: Notebook) {
        // 1 - modify your array
        notebooks.append(notebook)
        // 2 - insert a new index path into your collecionView
        let newIndexPath = IndexPath(item: notebooks.count-1, section: 0)
        self.tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    @objc func handleAddNotebookButton() {
        print("Add Notebook")
        let addNoteBookController = AddNotebookController()
        addNoteBookController.selectNoteBookController = self
        let addNotebook = UINavigationController(rootViewController: addNoteBookController)
        present(addNotebook, animated: true, completion: nil)
    }
    
    func fetchNotebooks(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        self.ref.child(uid).child("notebooks").observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key,value) in
                let keyTitle = key
                let notebook = Notebook(notebookTitle: keyTitle, dictionary: dictionaries)
                //self.notebooks.append(notebook)
                self.notebooks.insert(notebook, at: 0)
            })
            print("Fetching 2")
            self.tableView.reloadData()
            
        }
        //        self.animationView.loopAnimation = false
        self.animationView.removeFromSuperview()
    }
    
}

// MARK: -UITableView Functions
extension SelectNoteBookController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notebooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.attributedText =  NSMutableAttributedString(string: notebooks[indexPath.item].notebookTitle, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .thin),NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue ])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notebook = self.notebooks[indexPath.item]
        newNoteController?.notebookTitle = notebook.notebookTitle
        self.dismiss(animated: true, completion: nil)
    }
}
