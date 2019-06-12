//
//  HomeNoteBookCell.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/24/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import Lottie

class NoteBookHeaderCell: UICollectionViewCell {
    
    let label: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "Notebooks", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue])
        label.attributedText = attributedText
        return label
    }()
    
    let addNotebookButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "plusIcon"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleAddNotebookButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleAddNotebookButton() {
    }
    
    let titleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = paletteSystemWhite
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = paletteSystemWhite
        addSubview(titleContainer)
        titleContainer.anchor(topAnchor: safeAreaLayoutGuide.topAnchor, bottomAnchor: safeAreaLayoutGuide.bottomAnchor, leadingAnchor: safeAreaLayoutGuide.leadingAnchor, trailingAnchor: safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(label)
        label.anchor(topAnchor: safeAreaLayoutGuide.topAnchor, bottomAnchor: safeAreaLayoutGuide.bottomAnchor, leadingAnchor: safeAreaLayoutGuide.leadingAnchor, trailingAnchor: nil, paddingTop: 8, paddingBottom: 8, paddingLeft: 8, paddingRight: 8, width: 150, height: 0)
        
        addSubview(addNotebookButton)
        addNotebookButton.anchor(topAnchor: safeAreaLayoutGuide.topAnchor, bottomAnchor: safeAreaLayoutGuide.bottomAnchor, leadingAnchor: nil, trailingAnchor: safeAreaLayoutGuide.trailingAnchor, paddingTop: 8, paddingBottom: 8, paddingLeft: 8, paddingRight: 8, width: 35, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
