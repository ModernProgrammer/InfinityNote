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

class NoteBookController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let headerId = "headerId"
    var animationView: LOTAnimationView = {
        let view = LOTAnimationView(name: "infinityLoader")
        view.contentMode = .scaleAspectFit
        view.play()
        view.loopAnimation = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = paletteSystemWhite
        collectionView?.register(NoteBookHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(NoteBookCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.addSubview(animationView)
        animationView.frame = CGRect(x: view.center.x/4, y: view.center.y/3, width: 300, height: 300)
        fetchNotebooks()
        setupNavigationController()
    }
    
    var notebooks = [Notebook]()
    func fetchNotebooks(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child(uid).child("notebooks").observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key,value) in
                let keyTitle = key
                let notebook = Notebook(notebookTitle: keyTitle)
                //self.notebooks.append(notebook)
                self.notebooks.insert(notebook, at: 0)
            })
            
            self.animationView.loopAnimation = false
            self.animationView.removeFromSuperview()
            self.collectionView?.reloadData()
        }
    }
    
    func setupNavigationController() {
        navigationItem.title = "Infinity"
        let image = UIImage(named: "plusIcon")?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleAddNotebookButton))
        
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
    
    // For spacing between the cells
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
        
        let notebook = self.notebooks[indexPath.item]
        
        noteController.notebookTitle = notebook.notebookTitle
        print(notebook)
        
        navigationController?.pushViewController(noteController, animated: true)
    }
}
