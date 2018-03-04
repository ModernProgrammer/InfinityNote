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
    let noteContainer: UIView = {
        let view = UIView()
        view.backgroundColor = paletteSystemWhite
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 5
        return view
    }()
    
    let notebookImage: UIImageView = {
        var image = UIImageView()
        image.image = #imageLiteral(resourceName: "notebook")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let bookmarkButton: LOTAnimationView = {
        let animation = LOTAnimationView(name: "loader_animation")
        animation.play()
        return animation
    }()
    
    let notebookTitle: UITextView = {
        let label = UITextView()
        let attributedText = NSMutableAttributedString(string: "Title", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16),NSAttributedStringKey.foregroundColor: paletteSystemGrayBlue])
        attributedText.append(NSMutableAttributedString(string: "\n\n", attributes: [NSAttributedStringKey.foregroundColor: paletteSystemGreen, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 4)]))


        attributedText.append(NSMutableAttributedString(string: "By Diego Bustamante", attributes: [NSAttributedStringKey.foregroundColor: paletteSystemGreen, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 11)]))
        
        attributedText.append(NSMutableAttributedString(string: "\n\n", attributes: [NSAttributedStringKey.foregroundColor: paletteSystemGreen, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 4)]))

        attributedText.append(NSMutableAttributedString(string: "Loaded MobileCoreServices.framework", attributes: [NSAttributedStringKey.foregroundColor: paletteSystemGrayBlue, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSMutableAttributedString(string: "Lazy loading NSBundle MobileCoreServices.framework", attributes: [NSAttributedStringKey.foregroundColor: paletteSystemGrayBlue, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSMutableAttributedString(string: "Unknown class _TtC12InfinityNote14ViewController in", attributes: [NSAttributedStringKey.foregroundColor: paletteSystemGrayBlue, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        label.isEditable = false
        label.isSelectable = false
        label.attributedText = attributedText
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(noteContainer)
        addSubview(notebookTitle)
        addSubview(bookmarkButton)
        
        noteContainer.anchor(topAnchor: topAnchor, bottomAnchor: safeAreaLayoutGuide.bottomAnchor, leadingAnchor: safeAreaLayoutGuide.leadingAnchor, trailingAnchor: safeAreaLayoutGuide.trailingAnchor, paddingTop: 8, paddingBottom: 8, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
        
        
        notebookTitle.anchor(topAnchor: noteContainer.topAnchor, bottomAnchor: noteContainer.bottomAnchor, leadingAnchor: noteContainer.leadingAnchor, trailingAnchor: bookmarkButton.leadingAnchor, paddingTop: 8, paddingBottom: 8, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
        
        
        bookmarkButton.anchor(topAnchor: noteContainer.topAnchor, bottomAnchor: nil, leadingAnchor: notebookTitle.trailingAnchor, trailingAnchor: noteContainer.trailingAnchor, paddingTop: 8, paddingBottom: 8, paddingLeft: 8, paddingRight: 8, width: 20, height: 20)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
