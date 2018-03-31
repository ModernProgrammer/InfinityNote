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
class SelectNoteBookController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var newNoteController: NewNoteController?
    
    let cellId = "cellId"
    let headerId = "headerId"
    let ref = Database.database().reference()
    var animationView: LOTAnimationView = {
        let view = LOTAnimationView(name: "infinityLoader")
        view.contentMode = .scaleAspectFit
        view.play()
        view.loopAnimation = true
        return view
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.placeholder = "Search for Notebooks"
        searchbar.endEditing(true)
        searchbar.delegate = self
        return searchbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = paletteSystemWhite
        collectionView?.register(NoteBookHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(NoteBookCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.addSubview(animationView)
        navigationController?.navigationBar.addSubview(searchBar)
        
        fetchNotebooks()
        animationView.frame = CGRect(x: view.center.x/4, y: view.center.y/3, width: 300, height: 300)
        setupNavigationController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.isHidden = false
        print("Fetching 1")
    }
    
    var notebooks = [Notebook]()
    func fetchNotebooks(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self.ref.child(uid).child("notebooks").observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key,value) in
                let keyTitle = key
                let notebook = Notebook(notebookTitle: keyTitle)
                //self.notebooks.append(notebook)
                self.notebooks.insert(notebook, at: 0)
            })
            print("Fetching 2")
            self.collectionView?.reloadData()
            
        }
        self.animationView.loopAnimation = false
        self.animationView.removeFromSuperview()
    }
    
    func setupNavigationController() {
        //navigationItem.title = "Infinity"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.title = "Select Notebook"
        navigationController?.navigationBar.tintColor = paletteSystemGrayBlue
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    // Need this function in order to apend and insert notebook into collectionView
    func addNotebook(notebook: Notebook) {
        // 1 - modify your array
        notebooks.append(notebook)
        // 2 - insert a new index path into your collecionView
        let newIndexPath = IndexPath(item: notebooks.count-1, section: 0)
        
        self.collectionView?.insertItems(at: [newIndexPath])
    }
    
    @objc func handleAddNotebookButton() {
        print("Add Notebook")
        let addNoteBookController = AddNotebookController()
        addNoteBookController.selectNoteBookController = self
        let addNotebook = UINavigationController(rootViewController: addNoteBookController)
        present(addNotebook, animated: true, completion: nil)
    }
    
    
    // For Header
    // ----------------------
    // viewForSupplementaryElementOfKind
    // referenceSizeForHeaderInSection
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! NoteBookHeaderCell
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    // For CollectionView You Need...
    // ----------------------
    // numberOfItemsInSection
    // cellForItemAt
    // sizeForItemAt: Requires an extension of UICollectionViewDelegateFlowLayout
    // didSelectItemAt: Checks to see if you clicked on a cell
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notebooks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NoteBookCell
        cell.notebook = notebooks[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: 60)
    }
    
    // For spacing between the cellslgiht
    // minimumLineSpacingForSectionAt
    // minimumInteritemSpacingForSectionAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // For selecting a cell
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let notebook = self.notebooks[indexPath.item]
        
        newNoteController?.notebookTitle = notebook.notebookTitle
        self.dismiss(animated: true, completion: nil)

    }
    
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        let notebookpart = self.notebooks[indexPath.item]
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self.ref.child(uid).child("notebooks").child(notebookpart.notebookTitle).removeValue { (err, ref) in
            if let err = err {
                print("Oops, looks like something went wrong: ", err)
            }
            print("Successfully removed: ", notebookpart)
            self.notebooks.remove(at: indexPath.item)
            collectionView.deleteItems(at: [indexPath])
            print("Here and stuff")
        }
        
        
    }
}
