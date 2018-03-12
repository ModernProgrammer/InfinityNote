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
        
        let attributedText = NSMutableAttributedString(string: "Notebooks", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 24), NSAttributedStringKey.foregroundColor: paletteSystemGrayBlue])
        label.attributedText = attributedText
        
        return label
    }()
    
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
        label.anchor(topAnchor: safeAreaLayoutGuide.topAnchor, bottomAnchor: safeAreaLayoutGuide.bottomAnchor, leadingAnchor: safeAreaLayoutGuide.leadingAnchor, trailingAnchor: safeAreaLayoutGuide.trailingAnchor, paddingTop: 8, paddingBottom: 8, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
