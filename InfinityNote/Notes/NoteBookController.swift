//
//  HomeController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/10/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class NoteBookController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
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
    var filteredNotebooks = [Notebook]()
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
            self.filteredNotebooks = self.notebooks
            print("Fetching 2")
            self.collectionView?.reloadData()
            
        }
        self.animationView.loopAnimation = false
        self.animationView.removeFromSuperview()
    }
    
    // For Searchbar control
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredNotebooks = notebooks
        }
        else {
            filteredNotebooks = self.notebooks.filter({ (notebooks) -> Bool in
                return notebooks.notebookTitle.lowercased().contains(searchText.lowercased())
            })
        }
        self.collectionView?.reloadData()
    }
    
    func setupNavigationController() {
        //navigationItem.title = "Infinity"
        let navbar = navigationController?.navigationBar
        searchBar.anchor(topAnchor: navbar?.topAnchor, bottomAnchor: navbar?.bottomAnchor, leadingAnchor: navbar?.leadingAnchor, trailingAnchor: navbar?.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
        collectionView?.keyboardDismissMode = .onDrag
        
    }
    
    // Need this function in order to apend and insert notebook into collectionView
    func addNotebook(notebook: Notebook) {
        // 1 - modify your array
        filteredNotebooks.append(notebook)
        notebooks.append(notebook)
        // 2 - insert a new index path into your collecionView
        let newIndexPath = IndexPath(item: filteredNotebooks.count-1, section: 0)
        
        self.collectionView?.insertItems(at: [newIndexPath])
    }
    
    @objc func handleAddNotebookButton() {
        print("Add Notebook")
        let addNoteBookController = AddNotebookController()
        addNoteBookController.notebookController = self
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
        return filteredNotebooks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NoteBookCell
        cell.notebook = filteredNotebooks[indexPath.item]
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
        let noteController = NoteController(collectionViewLayout: UICollectionViewFlowLayout())
        
        let notebook = self.filteredNotebooks[indexPath.item]
        
        noteController.notebookTitle = notebook.notebookTitle
        print(notebook)
        noteController.searchBar = self.searchBar
        
        navigationController?.pushViewController(noteController, animated: true)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        let notebookpart = self.filteredNotebooks[indexPath.item]
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self.ref.child(uid).child("notebooks").child(notebookpart.notebookTitle).removeValue { (err, ref) in
            if let err = err {
                print("Oops, looks like something went wrong: ", err)
            }
            print("Successfully removed: ", notebookpart)
            self.filteredNotebooks.remove(at: indexPath.item)
            collectionView.deleteItems(at: [indexPath])
            print("Here and stuff")
        }
        
        
    }
}
