//
//  NewNoteController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 3/1/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class NewNoteController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = paletteSystemWhite
        setupUI()
    }
    
    let scrollContainer: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = paletteSystemWhite
        view.bounces = true
        return view
    }()
    
    let navbarContainer: UIView = {
        let view = UIView()
        view.backgroundColor = paletteSystemWhite
        return view
    }()
    
    let selectNoteBookContainer: UIView = {
        let view = UIView()
        view.backgroundColor = paletteSystemWhite
        return view
    }()
    
    let titleNoteBookContainer: UIView = {
        let view = UIView()
        view.backgroundColor = paletteSystemWhite
        return view
    }()
    
    let bodyNoteBookContainer: UIView = {
        let view = UIView()
        view.backgroundColor = paletteSystemWhite
        return view
    }()
    
    let bodyNoteBookTextField: KMPlaceholderTextView = {
        let body = KMPlaceholderTextView()
        body.font = UIFont.systemFont(ofSize: 16)
        body.textColor = paletteSystemGrayBlue
        body.backgroundColor = UIColor.init(white: 0, alpha: 0)
        body.textContainer.lineBreakMode = NSLineBreakMode.byCharWrapping;
        body.placeholder = "Note Here"
        return body
    }()
    
    let selectNoteBookButton: UIButton = {
        let button = UIButton()
        let attributedText = NSMutableAttributedString(string: "Select Notebook", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor:paletteSystemGreen])
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(handleSelectNotebook), for: .touchUpInside)
        return button
    }()
    
    let selectNoteBookSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "xIcon"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "checkIcon"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    let noteTitle: UITextField = {
        let text = UITextField()
        let attributedText = NSMutableAttributedString(string: "Title", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor:UIColor.lightGray])
        text.attributedPlaceholder = attributedText
        text.textColor = paletteSystemGrayBlue
        text.font = UIFont.boldSystemFont(ofSize: 16)
        return text
    }()
    let noteTitleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = paletteSystemGreen
        return view
    }()
    
    
    
    @objc func handleSelectNotebook() {
        print("Select Notebook")
    }
    
    @objc func handleSave() {
        print("Save")
    }
    
    @objc func handleCancel() {
        print("Cancel")
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupNavBarUI() {
        view.addSubview(navbarContainer)
        navbarContainer.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, bottomAnchor: nil, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 40)
        
        view.addSubview(cancelButton)
        view.addSubview(saveButton)
        cancelButton.anchor(topAnchor: navbarContainer.topAnchor, bottomAnchor: navbarContainer.bottomAnchor, leadingAnchor: navbarContainer.leadingAnchor, trailingAnchor: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0)
        saveButton.anchor(topAnchor: navbarContainer.topAnchor, bottomAnchor: navbarContainer.bottomAnchor, leadingAnchor: nil, trailingAnchor: navbarContainer.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 8, width: 0, height: 0)
    }
    
    fileprivate func setupNoteBookSelector() {
        view.addSubview(selectNoteBookContainer)
        selectNoteBookContainer.anchor(topAnchor: saveButton.bottomAnchor, bottomAnchor: nil, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 30)
        view.addSubview(selectNoteBookButton)
        selectNoteBookButton.anchor(topAnchor: selectNoteBookContainer.topAnchor, bottomAnchor: selectNoteBookContainer.bottomAnchor, leadingAnchor: selectNoteBookContainer.leadingAnchor, trailingAnchor: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 150, height: 0)
        
        view.addSubview(selectNoteBookSeperator)
        selectNoteBookSeperator.anchor(topAnchor: nil, bottomAnchor: selectNoteBookContainer.bottomAnchor, leadingAnchor: selectNoteBookContainer.leadingAnchor, trailingAnchor: selectNoteBookContainer.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: 0, height: 0.5)
    }
    
    fileprivate func setupNoteBookTitle() {
        view.addSubview(noteTitleContainer)
        view.addSubview(noteTitle)
        noteTitleContainer.anchor(topAnchor: selectNoteBookSeperator.bottomAnchor, bottomAnchor: nil, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 35)
        noteTitle.anchor(topAnchor: noteTitleContainer.topAnchor, bottomAnchor: noteTitleContainer.bottomAnchor, leadingAnchor: noteTitleContainer.leadingAnchor, trailingAnchor: noteTitleContainer.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0)
    }
    
    fileprivate func setupNoteBookBody() {
        view.addSubview(bodyNoteBookContainer)
        view.addSubview(bodyNoteBookTextField)
        bodyNoteBookContainer.anchor(topAnchor: noteTitle.bottomAnchor, bottomAnchor: scrollContainer.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        bodyNoteBookTextField.anchor(topAnchor: bodyNoteBookContainer.topAnchor, bottomAnchor: bodyNoteBookContainer.bottomAnchor, leadingAnchor: bodyNoteBookContainer.leadingAnchor, trailingAnchor: bodyNoteBookContainer.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
    }
    
    func setupUI(){
        view.addSubview(scrollContainer)
        scrollContainer.anchor(topAnchor: view.topAnchor, bottomAnchor: view.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        setupNavBarUI()
        setupNoteBookSelector()
        setupNoteBookTitle()
        setupNoteBookBody()
    }
}