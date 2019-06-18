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

class NoteBookController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let headerId = "headerId"
    let scrollDirection : UICollectionView.ScrollDirection = .horizontal
    let ref = Database.database().reference()
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
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowlayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = paletteSystemWhite
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
        setupUI()
        fetchNotebooks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Fetching 1")
    }
}

// MARK: UI/UX Functions
extension NoteBookController {
    fileprivate func setupWeatherContainer() {
        bottomContainer.addSubview(weatherContainer)
        weatherContainer.translatesAutoresizingMaskIntoConstraints = false
        weatherContainer.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor).isActive = true
        weatherContainer.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor).isActive = true
        weatherContainer.widthAnchor.constraint(equalToConstant: view.frame.width/3+80).isActive = true
        weatherContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
        weatherContainer.layer.cornerRadius = 40
        weatherContainer.layer.borderWidth = 1
        weatherContainer.layer.borderColor = UIColor.black.cgColor
        let attributedText  = NSMutableAttributedString(string: "Today\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .thin), NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue])
        attributedText.append(NSMutableAttributedString(string: "Aug 12, 2019", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold), NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue]))
        weatherLabel.attributedText = attributedText
        weatherContainer.addSubview(weatherLabel)
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherLabel.centerXAnchor.constraint(equalTo: weatherContainer.centerXAnchor).isActive = true
        weatherLabel.centerYAnchor.constraint(equalTo: weatherContainer.centerYAnchor).isActive = true
    }
    
    fileprivate func setupWelcomeLabel() {
        topContrainer.addSubview(welcomeLabel)
        welcomeLabel.anchor(topAnchor: topContrainer.topAnchor, bottomAnchor: topContrainer.bottomAnchor, leadingAnchor: topContrainer.leadingAnchor, trailingAnchor: topContrainer.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 20, paddingRight: 0, width: 0, height: 0)
        
        let attributedText = NSMutableAttributedString(string: "Welcome, \n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 32, weight: .thin),NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue])
        let name = String((Auth.auth().currentUser?.email)!)
        attributedText.append(NSMutableAttributedString(string: "\( String(describing: name))", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .ultraLight),NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue]))
        welcomeLabel.attributedText = attributedText
    }
    
    fileprivate func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [topContrainer,collectionView])
        view.addSubview(stackView)
        stackView.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.alignment = .center
        
        collectionView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        topContrainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
        topContrainer.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        collectionView.alpha = 0
        navigationItem.title = "Notebooks"
    }
    
    func setupUI() {
        self.animationView.frame = CGRect(x: view.center.x/4, y: view.center.y/3, width: 300, height: 300)
        view.backgroundColor = paletteSystemWhite
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plusIcon"), style: .plain, target: self, action: #selector(handleAddNotebookButton))
        
        setupNavBar(barTintColor: paletteSystemBlue, tintColor: paletteSystemGreen, textColor: paletteSystemGrayBlue, clearNavBar: true, largeTitle: true)
        setupStackView()
        setupWelcomeLabel()
//        setupWeatherContainer()
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
                let notebook = Notebook(notebookTitle: keyTitle)
                //self.notebooks.append(notebook)
                self.notebooks.insert(notebook, at: 0)
            })
            self.filteredNotebooks = self.notebooks
            print("Fetching 2")
            self.collectionView.reloadData()
            self.collectionView.fadeIn()            
        }
    }
    
    // Need this function in order to apend and insert notebook into collectionView
    func addNotebook(notebook: Notebook) {
        // 1 - modify your array
        filteredNotebooks.append(notebook)
        notebooks.append(notebook)
        // 2 - insert a new index path into your collecionView
        let newIndexPath = IndexPath(item: filteredNotebooks.count-1, section: 0)
        
        self.collectionView.insertItems(at: [newIndexPath])
    }
    
    @objc func handleAddNotebookButton() {
        print("Add Notebook")
        let addNoteBookController = AddNotebookController()
        addNoteBookController.notebookController = self
        let addNotebook = UINavigationController(rootViewController: addNoteBookController)
        present(addNotebook, animated: true, completion: nil)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let noteController = NoteController()
        let notebook = self.filteredNotebooks[indexPath.item]
        noteController.notebookTitle = notebook.notebookTitle
        print(notebook)
        navigationController?.pushViewController(noteController, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
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
