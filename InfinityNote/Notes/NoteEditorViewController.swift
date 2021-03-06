//
//  NoteEditorViewController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/24/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import Firebase

class NoteEditorViewController: UIViewController, UITextViewDelegate {
    var image: UIImage?
    var searchBar: UISearchBar?
    var changedText: String?
    
    let bookmarkUnselected = "bookmarkUnselected"
    let bookmarkSelected = "bookmarkSelected"

    var note: Note? {
        didSet {
            guard let titleName = note?.noteTitle else { return }
            
            // hide lottie animation
            let attributedText = NSMutableAttributedString(string: titleName, attributes: [NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 32, weight: .bold)])
            noteTitle.attributedText = attributedText
            
            guard let bodyText = note?.body else { return }

            let bodyAttributedText = NSMutableAttributedString(string: bodyText, attributes: [NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 22, weight: .thin)])
            bodyNoteBookTextField.attributedText = bodyAttributedText
            
            
            if note?.bookmark == false{
                self.image = UIImage(named: bookmarkUnselected)
            } else {
                self.image = UIImage(named: bookmarkSelected)
            }
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: self.image, style: .plain, target: self, action: #selector(handleSelectBookmark))
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = paletteSystemWhite
        setupUI()
    }
    
    let bodyNoteBookTextField: UITextView = {
        let body = UITextView()
        body.font = UIFont.systemFont(ofSize: 22, weight: .thin)
        body.textColor = paletteSystemGrayBlue
        body.backgroundColor = UIColor.init(white: 0, alpha: 0)
        body.textContainer.lineBreakMode = NSLineBreakMode.byCharWrapping;
        return body
    }()
    
    let noteTitle: UITextField = {
        let text = UITextField()
        let attributedText = NSMutableAttributedString(string: "Title", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 32, weight: .bold), NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        text.attributedPlaceholder = attributedText
        text.textColor = paletteSystemGrayBlue
        text.textAlignment = .center
        return text
    }()
    
    
    let selectNoteBookSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.05)
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.alwaysBounceVertical = true
        return view
    }()
    
    let toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(handleDone))
        let boldButton = UIBarButtonItem(image: #imageLiteral(resourceName: "bold"), style: .plain, target: self, action: #selector(handleBold))
        let italicButton = UIBarButtonItem(image: #imageLiteral(resourceName: "italicize"), style: .plain, target: self, action: #selector(handleItalic))
        let bulletButton = UIBarButtonItem(image: #imageLiteral(resourceName: "bulletedList"), style: .plain, target: self, action: #selector(handleBulletedList))
        let numberedButton = UIBarButtonItem(image: #imageLiteral(resourceName: "numberedlist"), style: .plain, target: self, action: #selector(handleNumberedList))
        
        toolBar.setItems([boldButton,italicButton,bulletButton,numberedButton,space,doneButton], animated: true)
        
        toolBar.tintColor = paletteSystemGreen
        return toolBar
    }()
    
    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupUI() {
        setupNavBar(barTintColor: paletteSystemWhite, tintColor: paletteSystemGreen, textColor: paletteSystemGrayBlue, clearNavBar: true, largeTitle: false)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "xIcon"), style: .plain, target: self, action: #selector(handleDismiss))

        
        let stackView = UIStackView(arrangedSubviews: [noteTitle, selectNoteBookSeperator])
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        tabBarController?.tabBar.isHidden = true
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        view.addSubview(scrollView)
        view.addSubview(stackView)
        view.addSubview(bodyNoteBookTextField)
        view.addGestureRecognizer(tap)
        
        scrollView.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: view.safeAreaLayoutGuide.leadingAnchor, trailingAnchor: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 8, paddingBottom: 8, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        stackView.anchor(topAnchor: scrollView.topAnchor, bottomAnchor: nil, leadingAnchor: scrollView.leadingAnchor, trailingAnchor: scrollView.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
        
        bodyNoteBookTextField.anchor(topAnchor: selectNoteBookSeperator.bottomAnchor, bottomAnchor: scrollView.bottomAnchor, leadingAnchor: scrollView.leadingAnchor, trailingAnchor: scrollView.trailingAnchor, paddingTop: 0, paddingBottom: 4, paddingLeft: 4, paddingRight: 4, width: 0, height: 0)
        
        bodyNoteBookTextField.inputAccessoryView = toolBar
        bodyNoteBookTextField.delegate = self
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        self.changedText = textView.text as String
    }
    
    @objc func handleDone() {
        view.endEditing(true)
        print("Done")
    }
    
    @objc func handleBold() {
        print("Bold")
        bodyNoteBookTextField.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    @objc func handleItalic() {
        print("Italic")
        if bodyNoteBookTextField.font == UIFont.boldSystemFont(ofSize: 16){
            bodyNoteBookTextField.font = UIFont.italicSystemFont(ofSize: 16)
        }

    }
    
    @objc func handleBulletedList() {
        print("Bullets")
    }
    
    @objc func handleNumberedList() {
        print("Numbered")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isToolbarHidden = true;
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let notebookTitle = note?.notebookTitle else { return }
        guard let noteTitle = note?.noteTitle else { return }
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "MM/dd/yyyy"
        let date = formatter.string(from: Date())
        
        if changedText != nil {
            let dictionaryValues = ["body": changedText as Any,"date": date] as [String: Any]
            Database.database().reference().child(uid).child("notebooks").child(notebookTitle).child(noteTitle).updateChildValues(dictionaryValues, withCompletionBlock: { (err, ref) in
                if let err = err {
                    print("Something went wrong: ", err)
                    return
                }
                
            })
        }
    }

    @objc func handleSelectBookmark() {
        guard let note = self.note else { return }
        if navigationItem.rightBarButtonItem?.image == UIImage(named: bookmarkUnselected) {
            self.image = UIImage(named: bookmarkSelected)
            // Use firebase to set bookmark for note
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let date = formatter.string(from: Date())
            Database.setNoteBookmark(note: note, bookmarkBool: true, bookmarkDate: date)
        } else {
            self.image = UIImage(named: bookmarkUnselected)
            // Use firebase to remove bookmark for note
            Database.setNoteBookmark(note: note, bookmarkBool: false, bookmarkDate: "")
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: self.image, style: .plain, target: self, action: #selector(handleSelectBookmark))
    }
}


