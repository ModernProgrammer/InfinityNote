//
//  BookmarkCellController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 3/15/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit

class BookmarkCellController: UICollectionViewCell {
    var note: Note? {
        didSet{
            guard let notebookTitle = note?.notebookTitle else { return }
            let attributedText = NSMutableAttributedString(string: notebookTitle, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14),NSAttributedStringKey.foregroundColor: paletteSystemGrayBlue])
            self.noteTitle.attributedText = attributedText
        }
    }
    
    let noteImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "notebook")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let noteLineSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    let noteTitle: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Title", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14),NSAttributedStringKey.foregroundColor: paletteSystemGrayBlue])
        label.attributedText = attributedText
        return label
    }()
    
    let nextArrow: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "rightArrow")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = paletteSystemWhite
        
        addSubview(noteImage)
        noteImage.anchor(topAnchor: safeAreaLayoutGuide.topAnchor, bottomAnchor: safeAreaLayoutGuide.bottomAnchor, leadingAnchor: safeAreaLayoutGuide.leadingAnchor, trailingAnchor: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 16, paddingRight: 0, width: 30, height: 0)
        
        addSubview(noteLineSeperator)
        noteLineSeperator.anchor(topAnchor: nil, bottomAnchor: safeAreaLayoutGuide.bottomAnchor, leadingAnchor: safeAreaLayoutGuide.leadingAnchor, trailingAnchor: safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0.5)
        
        addSubview(noteTitle)
        noteTitle.anchor(topAnchor: safeAreaLayoutGuide.topAnchor, bottomAnchor: safeAreaLayoutGuide.bottomAnchor, leadingAnchor: noteImage.trailingAnchor, trailingAnchor: safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 16, paddingRight: 0, width: 0, height: 0)
        
        addSubview(nextArrow)
        nextArrow.anchor(topAnchor: safeAreaLayoutGuide.topAnchor, bottomAnchor: safeAreaLayoutGuide.bottomAnchor, leadingAnchor: nil, trailingAnchor: safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 8, width: 20, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
