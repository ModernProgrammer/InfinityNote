//
//  SearchController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/16/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit

class SearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    lazy var searchBar: UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.placeholder = "Search Notebook, Note, or Notes"
        return searchbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = paletteSystemWhite
        navigationController?.navigationBar.addSubview(searchBar)
        collectionView?.keyboardDismissMode = .onDrag

        let navbar = navigationController?.navigationBar
        searchBar.anchor(topAnchor: navbar?.topAnchor, bottomAnchor: navbar?.bottomAnchor, leadingAnchor: navbar?.leadingAnchor, trailingAnchor: navbar?.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
    }
    
    // For CollectionView You Need...
    // ----------------------
    // numberOfItemsInSection
    // cellForItemAt
    // sizeForItemAt: Requires an extension of UICollectionViewDelegateFlowLayout
    // didSelectItemAt: Checks to see if you clicked on a cell
    
}
