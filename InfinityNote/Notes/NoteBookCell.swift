//
//  HomeNoteBookBodyCell.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/24/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit

class NoteBookCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var notebook: Notebook? {
        didSet{
            guard let notebookTitle = notebook?.notebookTitle else { return }
            let attributedText = NSMutableAttributedString(string: notebookTitle, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),NSAttributedString.Key.foregroundColor: paletteSystemWhite])
            self.notebookTitle.attributedText = attributedText
        }
    }
    
    
    let notebookImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "pic8")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        return image
    }()
    
    let notebookLineSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = paletteSystemLineSeparatorColor
        return view
    }()
    
    let notebookTitle: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Title", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: paletteSystemWhite])
        label.attributedText = attributedText
        label.textAlignment = .center
        return label
    }()
    
    let nextArrow: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "rightArrow")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    func setupCellUI() {
        
        addSubview(notebookImage)
        notebookImage.anchor(topAnchor: topAnchor, bottomAnchor: bottomAnchor, leadingAnchor: leadingAnchor, trailingAnchor: trailingAnchor, paddingTop: 20, paddingBottom: 20, paddingLeft: 20, paddingRight: 20, width: 0, height: 0)
        
        addSubview(notebookTitle)
        notebookTitle.anchor(topAnchor: topAnchor, bottomAnchor: bottomAnchor, leadingAnchor: leadingAnchor, trailingAnchor: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        

    }
}
