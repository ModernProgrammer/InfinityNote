//
//  HomeNotebookCell.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/10/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import Lottie

class NoteCell: UITableViewCell {
    
    var note: Note? {
        didSet{
            guard let noteTitle = note?.noteTitle else { return }
            guard let body = note?.body else { return }
            
            let attributedText = NSMutableAttributedString(string: noteTitle, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold),NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue])
            
            attributedText.append(NSMutableAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.foregroundColor: paletteSystemGreen, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))

            attributedText.append(NSMutableAttributedString(string: body, attributes: [NSAttributedString.Key.foregroundColor: paletteSystemGrayBlue, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .thin)]))
            self.noteTitle.attributedText = attributedText
        }
    }
    
    let colorBoarder : UIView = {
        let view = UIView()
        view.backgroundColor = paletteSystemGreen
        return view
    }()
    
    
    let noteTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textAlignment = .left
        label.isUserInteractionEnabled = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(colorBoarder)
        colorBoarder.anchor(topAnchor: topAnchor, bottomAnchor: bottomAnchor, leadingAnchor: leadingAnchor, trailingAnchor: nil, paddingTop: 0, paddingBottom: 1, paddingLeft: 15, paddingRight: 0, width: 4, height: 0)
        
        addSubview(noteTitle)

        noteTitle.anchor(topAnchor: topAnchor, bottomAnchor: bottomAnchor, leadingAnchor: leadingAnchor, trailingAnchor: nil, paddingTop: 8, paddingBottom: 8, paddingLeft: 28, paddingRight: 16, width: frame.width-20, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
