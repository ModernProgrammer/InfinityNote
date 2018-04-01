//
//  NewNoteController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 3/1/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import Firebase
import KMPlaceholderTextView

class NewNoteController: UIViewController {

    var noteController: NoteController?
    
    var notebookTitle: String? {
        didSet{
            guard let notebook = notebookTitle else { return }
            let attributedText = NSMutableAttributedString(string: notebook, attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor:paletteSystemGreen])
            selectNoteBookButton.setAttributedTitle(attributedText, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = paletteSystemWhite
        setupNavBar()
        setupUI()
    }   

    let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "xIcon"), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "checkIcon"), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    let selectNoteBookButton: UIButton = {
        let button = UIButton()
        let attributedText = NSMutableAttributedString(string: "Select Notebook", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor:paletteSystemGreen])
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(handleSelectNotebook), for: .touchUpInside)
        button.layer.borderWidth = 0.0;
        return button
    }()

    let bodyNoteBookTextField: KMPlaceholderTextView = {
        let body = KMPlaceholderTextView()
        body.font = UIFont.systemFont(ofSize: 16)
        body.textColor = paletteSystemGrayBlue
        body.backgroundColor = UIColor.init(white: 0, alpha: 0)
        body.textContainer.lineBreakMode = NSLineBreakMode.byCharWrapping;
        body.placeholder = "Note"
        return body
    }()
    
    let noteTitle: UITextField = {
        let text = UITextField()
        let attributedText = NSMutableAttributedString(string: "Title", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 16), NSAttributedStringKey.foregroundColor:UIColor.lightGray])
        text.attributedPlaceholder = attributedText
        text.textColor = paletteSystemGrayBlue
        text.font = UIFont.boldSystemFont(ofSize: 16)
        return text
    }()
    
    
    let selectNoteBookSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.05)
        return view
    }()
    
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.alwaysBounceVertical = true
        return view
    }()
    

    @objc func handleSelectNotebook() {
        print("Select Notebook")
        
        let selectNoteBookController = SelectNoteBookController(collectionViewLayout: UICollectionViewFlowLayout())
        selectNoteBookController.newNoteController = self
        let selectNoteBookView = UINavigationController(rootViewController:selectNoteBookController)
        present(selectNoteBookView, animated: true, completion: nil)
    }
    
    @objc func handleSave() {
        print("Save")
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let notebookTitle = self.notebookTitle else { return }
        guard let noteTitle = self.noteTitle.text, noteTitle.count > 0 else { return }
        guard let body = bodyNoteBookTextField.text, body.count > 0 else { return }
        
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "MM/dd/yyyy"
        
        let date = formatter.string(from: Date())
        print(date)
        let dictionaryValues = ["body": body,"date": date]
        Database.database().reference().child(uid).child("notebooks").child(notebookTitle).child(noteTitle).updateChildValues(dictionaryValues) { (err, ref) in
            if let err = err {
                print("Something went wrong: ", err)
                return
            }
            print("Successful saving")
            self.dismiss(animated: true, completion: nil)
            let dictionaryValues = ["bookmark": false]
            
            ref.updateChildValues(dictionaryValues)
            
            let noteDictionary = ["body": body,"date": date] as [String : Any]
            
            let note = Note(dictionary: noteDictionary, noteTitle: noteTitle, notebookTitle: notebookTitle, uid: uid)
            self.noteController?.addNote(note: note)
        }
    }
    
    @objc func handleCancel() {
        print("Cancel")
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.noteTitle.resignFirstResponder()
        self.bodyNoteBookTextField.resignFirstResponder()
        return true
    }
    
    func setupUI(){
        let stackView = UIStackView(arrangedSubviews: [selectNoteBookButton, selectNoteBookSeperator, noteTitle])
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(scrollView)
        view.addSubview(stackView)
        view.addSubview(bodyNoteBookTextField)

        scrollView.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: view.safeAreaLayoutGuide.leadingAnchor, trailingAnchor: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 8, paddingBottom: 8, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        selectNoteBookSeperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        stackView.anchor(topAnchor: scrollView.topAnchor, bottomAnchor: nil, leadingAnchor: scrollView.leadingAnchor, trailingAnchor: scrollView.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
        
        bodyNoteBookTextField.anchor(topAnchor: noteTitle.bottomAnchor, bottomAnchor: scrollView.bottomAnchor, leadingAnchor: scrollView.leadingAnchor, trailingAnchor: scrollView.trailingAnchor, paddingTop: 0, paddingBottom: 4, paddingLeft: 4, paddingRight: 4, width: 0, height: 0)
    }
    
    func setupNavBar() {
        let cancelButtonImage = UIImage(named: "xIcon")?.withRenderingMode(.alwaysOriginal)
        let saveButtonImage = UIImage(named: "checkIcon")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: cancelButtonImage, style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.title = "New Note"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: saveButtonImage, style: .plain, target: self, action: #selector(handleSave))
        navigationController?.navigationBar.tintColor = paletteSystemGrayBlue
    }
    
}
