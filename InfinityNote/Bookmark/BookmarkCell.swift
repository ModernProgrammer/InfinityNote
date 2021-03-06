//
//  BookmarkCellController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 3/15/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit

class BookmarkCell: UICollectionViewCell {
    var bookmarkNote: Note? {
        didSet{
            guard let notebookTitle = bookmarkNote?.noteTitle else { return }
            let attributedText = NSMutableAttributedString(string: notebookTitle, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue])
            self.noteTitle.attributedText = attributedText
        }
    }
    
    let noteImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "noteIcon")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let noteLineSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = paletteSystemLineSeparatorColor
        return view
    }()
    
    let noteTitle: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Title", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue])
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
        noteImage.anchor(topAnchor: safeAreaLayoutGuide.topAnchor, bottomAnchor: safeAreaLayoutGuide.bottomAnchor, leadingAnchor: safeAreaLayoutGuide.leadingAnchor, trailingAnchor: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 16, paddingRight: 0, width: 15, height: 0)
        
        addSubview(noteLineSeperator)
        noteLineSeperator.anchor(topAnchor: nil, bottomAnchor: safeAreaLayoutGuide.bottomAnchor, leadingAnchor: safeAreaLayoutGuide.leadingAnchor, trailingAnchor: safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0.5)
        
        addSubview(noteTitle)
        noteTitle.anchor(topAnchor: safeAreaLayoutGuide.topAnchor, bottomAnchor: safeAreaLayoutGuide.bottomAnchor, leadingAnchor: noteImage.trailingAnchor, trailingAnchor: safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 16, paddingRight: 0, width: 0, height: 0)
        
        addSubview(nextArrow)
        nextArrow.anchor(topAnchor: safeAreaLayoutGuide.topAnchor, bottomAnchor: safeAreaLayoutGuide.bottomAnchor, leadingAnchor: nil, trailingAnchor: safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 8, width: 15, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
