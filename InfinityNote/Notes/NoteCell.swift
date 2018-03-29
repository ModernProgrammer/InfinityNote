//
//  HomeNotebookCell.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/10/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import Lottie

class NoteCell: UICollectionViewCell {
    
    var note: Note? {
        didSet{
            guard let noteTitle = note?.noteTitle else { return }
            guard let noteDate = note?.date else { return }
            guard let body = note?.body else { return }
            
            let attributedText = NSMutableAttributedString(string: noteTitle, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16),NSAttributedStringKey.foregroundColor: paletteSystemGrayBlue])
            attributedText.append(NSMutableAttributedString(string: "\n\n", attributes: [NSAttributedStringKey.foregroundColor: paletteSystemGreen, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 4)]))
            
            attributedText.append(NSMutableAttributedString(string: noteDate, attributes: [NSAttributedStringKey.foregroundColor: paletteSystemGreen, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 11)]))
            
            attributedText.append(NSMutableAttributedString(string: "\n\n", attributes: [NSAttributedStringKey.foregroundColor: paletteSystemGreen, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 4)]))

            attributedText.append(NSMutableAttributedString(string: body + "\n" + "..." , attributes: [NSAttributedStringKey.foregroundColor: paletteSystemGrayBlue, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
            self.noteTitle.attributedText = attributedText
        }
    }
    
    let noteContainer: UIView = {
        let view = UIView()
        view.backgroundColor = paletteSystemWhite
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 5
        return view
    }()
    
    let noteTitle: UITextView = {
        let label = UITextView()
        label.isEditable = false
        label.isSelectable = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(noteContainer)
        addSubview(noteTitle)
        
        noteContainer.anchor(topAnchor: topAnchor, bottomAnchor: safeAreaLayoutGuide.bottomAnchor, leadingAnchor: safeAreaLayoutGuide.leadingAnchor, trailingAnchor: safeAreaLayoutGuide.trailingAnchor, paddingTop: 8, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
        
        noteTitle.anchor(topAnchor: noteContainer.topAnchor, bottomAnchor: noteContainer.bottomAnchor, leadingAnchor: noteContainer.leadingAnchor, trailingAnchor: noteContainer.trailingAnchor, paddingTop: 8, paddingBottom: 8, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
