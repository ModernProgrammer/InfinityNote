//
//  Note.swift
//  InfinityNote
//
//  Created by Diego Bustamante on 6/20/19.
//  Copyright © 2019 Diego Bustamante. All rights reserved.
//

import UIKit

struct Note {
    let noteTitle: String
    let date: String
    let body: String
    let bookmark: Bool
    let bookmarkDate: String
    let notebookTitle: String
    let uid:String
    
    init(dictionary: [String: Any], noteTitle: String, notebookTitle: String, uid: String){
        self.uid = uid
        self.noteTitle = noteTitle
        self.date =  dictionary["date"] as? String ?? ""
        self.body =  dictionary["body"] as? String ?? ""
        self.notebookTitle = notebookTitle
        self.bookmark = dictionary["bookmark"] as? Bool ?? false
        self.bookmarkDate = dictionary["bookmarkDate"] as? String ?? ""
    }
}
