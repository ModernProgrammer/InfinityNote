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

protocol NotebookDelegate {
    func presentAlertController(indexPath: IndexPath)
    func addNotebook(notebook: Notebook)
}

class NoteBookController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NotebookDelegate {
    let cellId = "cellId"
    let headerId = "headerId"
    let scrollDirection : UICollectionView.ScrollDirection = .horizontal
    let ref = Database.database().reference()
    var user : User?
    var notebooks = [Notebook]()
    var filteredNotebooks = [Notebook]()
    var animationView: AnimationView = {
        let view = AnimationView(name: "infinityLoader")
        view.contentMode = .scaleAspectFit
        view.play()
        return view
    }()
    
    let welcomeLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let weatherContainer : UIView = {
        let view = UIView()
        return view
    }()
    
    let weatherLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let weatherIcon : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let topContrainer : UIView = {
        let view = UIView()
        return view
    }()
    
    
    lazy var collectionView : UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        flowlayout.minimumLineSpacing = 0
        flowlayout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowlayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(NoteBookCell.self, forCellWithReuseIdentifier: cellId)
        return collectionView
    }()
    
    
    let bottomContainer : UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        user = Database.getUserInfo()
//        print("User: \(user?.uid)")
        setupWelcomeLabel()
        setupUI()
        fetchNotebooks()
        getUserInfo()
    }
}

// MARK: UI/UX Functions
extension NoteBookController {
    fileprivate func setupWelcomeLabel() {
        let user = UserInfo.shared.user
        view.addSubview(welcomeLabel)
        welcomeLabel.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, bottomAnchor: nil, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 20, paddingRight: 0, width: 0, height: 80)
        
        let attributedText = NSMutableAttributedString(string: "Welcome, \n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 32, weight: .thin),NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue])
        guard let name = user?.fullname else { return }
        attributedText.append(NSMutableAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .ultraLight),NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue]))
        welcomeLabel.attributedText = attributedText
    }
    
    fileprivate func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.anchor(topAnchor: view.topAnchor, bottomAnchor: view.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        collectionView.alpha = 0
        navigationItem.title = "Notebooks"
    }
    
    func setupUI() {
        self.animationView.frame = CGRect(x: view.center.x/4, y: view.center.y/3, width: 300, height: 300)
        view.backgroundColor = paletteSystemWhite
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plusIcon"), style: .plain, target: self, action: #selector(handleAddNotebookButton))
        setupNavBar(barTintColor: paletteSystemBlue, tintColor: paletteSystemGreen, textColor: paletteSystemGrayBlue, clearNavBar: true, largeTitle: true)
        self.setupCollectionView()

    }
    
    func presentAlertController(indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Notebook Options", message: nil, preferredStyle: .actionSheet)
        alertController.modalPresentationStyle = .popover
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            self.deleteNotebook(indexPath: indexPath)
        }))
        
        if let presenter = alertController.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            presenter.permittedArrowDirections = []
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: Notebook functions
extension NoteBookController {
    func fetchNotebooks(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self.ref.child(uid).child("notebooks").observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key,value) in
                let keyTitle = key
                guard let dictionary = value as? [String: Any] else { return }
                dictionary.forEach({ (arg0) in

                    let (key, value) = arg0
                    print("\(key) and \(value)")
                })
                let notebook = Notebook(notebookTitle: keyTitle, dictionary: dictionary)
                self.notebooks.insert(notebook, at: 0)
            })
            let sortedNotebooks = self.sortNotebookByDate(notebooks: self.notebooks)
            self.filteredNotebooks = sortedNotebooks
            self.filteredNotebooks.forEach({ (notebook) in
                print("Notebook:\(notebook.notebookTitle) : \(notebook.date)")
            })
            self.collectionView.alpha = 0
            self.collectionView.reloadData()
            self.collectionView.fadeIn()            
        }
    }
    
    func deleteNotebook(indexPath: IndexPath) {
        let notebookpart = self.filteredNotebooks[indexPath.item]
        guard let uid = Auth.auth().currentUser?.uid else { return }
        self.ref.child(uid).child("notebooks").child(notebookpart.notebookTitle).removeValue { (err, ref) in
            if let err = err {
                print("Oops, looks like something went wrong: ", err)
            }
            print("Successfully removed: ", notebookpart)
            self.filteredNotebooks.remove(at: indexPath.item)
            self.collectionView.deleteItems(at: [indexPath])
            print("Here and stuff")
        }
    }
    
    // Need this function in order to apend and insert notebook into collectionView
    func addNotebook(notebook: Notebook) {
        self.collectionView.performBatchUpdates({
            let indexPath = IndexPath(row: 0, section: 0)
            filteredNotebooks.insert(notebook, at: indexPath.item)
            self.collectionView.insertItems(at: [indexPath])
        }, completion: { (done) in
            self.collectionView.reloadData()
            self.collectionView.fadeIn()
        })
    }
    
    @objc func handleAddNotebookButton() {
        print("Add Notebook")
        let addNoteBookController = AddNotebookController()
        addNoteBookController.notebookController = self
        let addNotebook = UINavigationController(rootViewController: addNoteBookController)
        present(addNotebook, animated: true, completion: nil)
    }
    
    func getUserInfo() {
        let userName = Auth.auth().currentUser?.email
        print(userName)
    }
}

// MARK: UICollectionView Functions
extension NoteBookController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredNotebooks.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cells = collectionView.visibleCells as! [NoteBookCell]
        let bounds = collectionView.bounds
        for cell in cells {
            cell.parallaxOffset(collectionViewBounds: bounds, scrollDirecton: scrollDirection)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NoteBookCell
        cell.indexPath = indexPath
        cell.notebookDelegate = self
        cell.notebook = filteredNotebooks[indexPath.item]
        cell.paddingOffset = 150
        let bounds = collectionView.bounds
        cell.parallaxOffset(collectionViewBounds: bounds, scrollDirecton: scrollDirection)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.safeAreaLayoutGuide.layoutFrame.width
        let height = view.safeAreaLayoutGuide.layoutFrame.height-160
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let noteController = NoteController()
        let notebook = self.filteredNotebooks[indexPath.item]
        noteController.notebookTitle = notebook.notebookTitle
        print(notebook)
        navigationController?.pushViewController(noteController, animated: true)
    }

}
