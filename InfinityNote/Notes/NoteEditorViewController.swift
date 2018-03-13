//
//  NoteEditorViewController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/24/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import Firebase

class NoteEditorViewController: UIViewController {
    var image: UIImage?
    let bookmarkUnselected = "bookmarkUnselected"
    let bookmarkSelected = "bookmarkSelected"
    
    var note: Note? {
        didSet {
            guard let titleName = note?.noteTitle else { return }
            let attributedText = NSMutableAttributedString(string: titleName, attributes: [NSAttributedStringKey.foregroundColor: paletteSystemGrayBlue])
            noteTitle.attributedText = attributedText
            
            guard let bodyText = note?.body else { return }

            let bodyAttributedText = NSMutableAttributedString(string: bodyText, attributes: [NSAttributedStringKey.foregroundColor: paletteSystemGrayBlue])
            noteBody.attributedText = bodyAttributedText
            
            
            if note?.bookmark == false{
                self.image = UIImage(named: bookmarkUnselected)?.withRenderingMode(.alwaysOriginal)
            } else {
                self.image = UIImage(named: bookmarkSelected)?.withRenderingMode(.alwaysOriginal)
            }
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: self.image, style: .plain, target: self, action: #selector(handleSelectBookmark))
        }
    }
    
    let noteTitleContainer: UIView = {
        let view = UIView()
        return view
    }()

    let noteTitle: UITextField = {
        let title = UITextField()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = paletteSystemGrayBlue
        title.textAlignment = .left
        return title
    }()
    
    let noteBodyContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    let noteBody: UITextView = {
        let body = UITextView()
        body.font = UIFont.systemFont(ofSize: 16)
        body.textColor = paletteSystemGrayBlue
        body.backgroundColor = UIColor.init(white: 0, alpha: 0)
        body.textContainer.lineBreakMode = NSLineBreakMode.byCharWrapping;
        return body
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = paletteSystemWhite
        view.addSubview(noteTitleContainer)
        view.addSubview(noteTitle)
        
        noteTitleContainer.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, bottomAnchor: nil, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 80)
        noteTitle.anchor(topAnchor: noteTitleContainer.topAnchor, bottomAnchor: noteTitleContainer.bottomAnchor, leadingAnchor: noteTitleContainer.safeAreaLayoutGuide.leadingAnchor, trailingAnchor: noteTitleContainer.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingLeft: 20, paddingRight: 20, width: 0, height: 0)
        
        view.addSubview(noteBodyContainer)
        view.addSubview(noteBody)
        noteBodyContainer.anchor(topAnchor: noteTitleContainer.bottomAnchor, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: view.leadingAnchor, trailingAnchor: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        noteBody.anchor(topAnchor: noteBodyContainer.topAnchor, bottomAnchor: noteBodyContainer.bottomAnchor, leadingAnchor: noteBodyContainer.safeAreaLayoutGuide.leadingAnchor, trailingAnchor: noteBodyContainer.safeAreaLayoutGuide.trailingAnchor, paddingTop: 20, paddingBottom: 20, paddingLeft: 20, paddingRight: 20, width: 0, height: 0)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isToolbarHidden = true;
    }
    
    @objc func handleSelectBookmark() {
        guard let note = self.note else { return }
        
        if navigationItem.rightBarButtonItem?.image == UIImage(named: bookmarkUnselected)?.withRenderingMode(.alwaysOriginal) {
            self.image = UIImage(named: bookmarkSelected)?.withRenderingMode(.alwaysOriginal)
            // Use firebase to set bookmark for note
            Database.setNoteBookmark(note: note, bookmarkBool: true)            
        } else {
            self.image = UIImage(named: bookmarkUnselected)?.withRenderingMode(.alwaysOriginal)
            // Use firebase to remove bookmark for note
            Database.setNoteBookmark(note: note, bookmarkBool: false)
        }
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleSelectBookmark))
    }
}


