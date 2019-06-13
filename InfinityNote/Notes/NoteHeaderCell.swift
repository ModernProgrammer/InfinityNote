//
//  NoteHeader.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/24/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit

class NoteHeaderCell: UICollectionViewCell, UISearchBarDelegate {
    
    let headerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()

    let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search Notes"
        bar.barTintColor = paletteSystemWhite
        bar.searchBarStyle = .minimal
        bar.textColor = paletteSystemGrayBlue
        return bar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = paletteSystemTan
        
        addSubview(headerContainer)
        addSubview(searchBar)
        headerContainer.anchor(topAnchor: topAnchor, bottomAnchor: bottomAnchor, leadingAnchor: leadingAnchor, trailingAnchor: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        searchBar.anchor(topAnchor: headerContainer.topAnchor, bottomAnchor: headerContainer.bottomAnchor, leadingAnchor: headerContainer.leadingAnchor, trailingAnchor: headerContainer.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
