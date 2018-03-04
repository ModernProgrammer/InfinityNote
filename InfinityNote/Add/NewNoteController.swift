//
//  NewNoteController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 3/1/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit

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
        view.backgroundColor = paletteSystemTan
        return view
    }()
    
    let selectNoteBookContainer: UIView = {
        let view = UIView()
        view.backgroundColor = paletteSystemBlue
        return view
    }()
    
    let titleNoteBookContainer: UIView = {
        let view = UIView()
        view.backgroundColor = paletteSystemGreen
        return view
    }()
    
    let bodyNoteBookContainer: UIView = {
        let view = UIView()
        view.backgroundColor = paletteSystemBlue
        return view
    }()
    
    let selectNoteBookButton: UIButton = {
        let button = UIButton()
        let attributedText = NSMutableAttributedString(string: "Select Notebook ", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor:paletteSystemGreen])
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(handleSelectNotebook), for: .touchUpInside)
        return button
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
    
    let noteTitle: UITextView = {
        let text = UITextView()
        let attributedText = NSMutableAttributedString(string: "Title", attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor:UIColor.lightGray])
        text.attributedText = attributedText
        return text
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
    
    func setupUI(){
        view.addSubview(scrollContainer)
        scrollContainer.anchor(topAnchor: view.topAnchor, bottomAnchor: view.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(navbarContainer)
        navbarContainer.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, bottomAnchor: nil, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 40)
        
        view.addSubview(cancelButton)
        view.addSubview(saveButton)
        
        cancelButton.anchor(topAnchor: navbarContainer.topAnchor, bottomAnchor: navbarContainer.bottomAnchor, leadingAnchor: navbarContainer.leadingAnchor, trailingAnchor: nil, paddingTop: 8, paddingBottom: 8, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
        
        saveButton.anchor(topAnchor: navbarContainer.topAnchor, bottomAnchor: navbarContainer.bottomAnchor, leadingAnchor: nil, trailingAnchor: navbarContainer.trailingAnchor, paddingTop: 8, paddingBottom: 8, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
        
        
    }
}
