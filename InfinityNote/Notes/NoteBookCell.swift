//
//  HomeNoteBookBodyCell.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/24/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit

class NoteBookCell: UICollectionViewCell {
    var notebook: Notebook? {
        didSet{
            guard let notebookTitle = notebook?.notebookTitle else { return }
            let attributedText = NSMutableAttributedString(string: notebookTitle, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),NSAttributedStringKey.foregroundColor: paletteSystemGrayBlue])
            self.notebookTitle.attributedText = attributedText
        }
    }
    
    let notebookImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "bookIcon")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let notebookLineSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = paletteSystemLineSeparatorColor
        return view
    }()
    
    let notebookTitle: UILabel = {
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
        
        addSubview(notebookImage)
        notebookImage.anchor(topAnchor: safeAreaLayoutGuide.topAnchor, bottomAnchor: safeAreaLayoutGuide.bottomAnchor, leadingAnchor: safeAreaLayoutGuide.leadingAnchor, trailingAnchor: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 16, paddingRight: 0, width: 30, height: 0)
        
        addSubview(notebookLineSeperator)
        notebookLineSeperator.anchor(topAnchor: nil, bottomAnchor: safeAreaLayoutGuide.bottomAnchor, leadingAnchor: safeAreaLayoutGuide.leadingAnchor, trailingAnchor: safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0.5)
        
        addSubview(notebookTitle)
        notebookTitle.anchor(topAnchor: safeAreaLayoutGuide.topAnchor, bottomAnchor: safeAreaLayoutGuide.bottomAnchor, leadingAnchor: notebookImage.trailingAnchor, trailingAnchor: safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 16, paddingRight: 0, width: 0, height: 0)
        
        addSubview(nextArrow)
        nextArrow.anchor(topAnchor: safeAreaLayoutGuide.topAnchor, bottomAnchor: safeAreaLayoutGuide.bottomAnchor, leadingAnchor: nil, trailingAnchor: safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 8, width: 20, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
