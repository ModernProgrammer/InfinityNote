//
//  Notebook.swift
//  InfinityNote
//
//  Created by Diego Bustamante on 6/20/19.
//  Copyright © 2019 Diego Bustamante. All rights reserved.
//

import UIKit

struct Notebook {
    let notebookTitle: String
    let dictionary: String
    init(notebookTitle: String, dictionary: [String: Any]){
        self.notebookTitle = notebookTitle
        self.dictionary = dictionary["date"] as? String ?? ""
    }
}
