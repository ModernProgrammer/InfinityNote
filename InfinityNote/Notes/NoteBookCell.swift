//
//  HomeNoteBookBodyCell.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/24/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit

class NoteBookCell: UICollectionViewCell, UIGestureRecognizerDelegate {

    var pan: UIPanGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCellUI()
    }
    
    var notebook: Notebook? {
        didSet{
            guard let notebookTitle = notebook?.notebookTitle else { return }
            let attributedText = NSMutableAttributedString(string: notebookTitle, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue])
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
    
    func setupCellUI() {
        
        backgroundColor = .blue

        addSubview(notebookImage)
        notebookImage.anchor(topAnchor: contentView.safeAreaLayoutGuide.topAnchor, bottomAnchor: contentView.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: contentView.safeAreaLayoutGuide.leadingAnchor, trailingAnchor: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 16, paddingRight: 0, width: 15, height: 0)
        
        addSubview(notebookTitle)
        notebookTitle.anchor(topAnchor: contentView.safeAreaLayoutGuide.topAnchor, bottomAnchor: contentView.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: notebookImage.trailingAnchor, trailingAnchor: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 16, paddingRight: 0, width: 160, height: 0)
        
        addSubview(nextArrow)
        nextArrow.anchor(topAnchor: contentView.safeAreaLayoutGuide.topAnchor, bottomAnchor: contentView.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: nil, trailingAnchor: contentView.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 8, width: 15, height: 0)
        
        addSubview(notebookLineSeperator)
        notebookLineSeperator.anchor(topAnchor: nil, bottomAnchor: contentView.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: contentView.safeAreaLayoutGuide.leadingAnchor, trailingAnchor: contentView.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0.5)
        

    }
}
