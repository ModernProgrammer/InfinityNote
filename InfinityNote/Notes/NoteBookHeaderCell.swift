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
    let username = "Diego Bustamante"
    
    let animatedBackground: LOTAnimationView = {
        let background = LOTAnimationView(name: "animated_background")
        background.play()
        background.loopAnimation = true
        return background
    }()
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "Welcome, ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 24), NSAttributedStringKey.foregroundColor: paletteSystemWhite])
        attributedText.append(NSMutableAttributedString(string: "Diego Bustamante", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 24), NSAttributedStringKey.foregroundColor: paletteSystemWhite]))
        label.attributedText = attributedText
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = paletteSystemBlue
        addSubview(animatedBackground)
        animatedBackground.anchor(topAnchor: topAnchor, bottomAnchor: bottomAnchor, leadingAnchor: leadingAnchor, trailingAnchor: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(welcomeLabel)
        welcomeLabel.anchor(topAnchor: topAnchor, bottomAnchor: nil, leadingAnchor: leadingAnchor, trailingAnchor: trailingAnchor, paddingTop: 8, paddingBottom: 8, paddingLeft: 8, paddingRight: 8, width: 0, height: 48)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
