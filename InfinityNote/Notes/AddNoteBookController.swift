//
//  AddNoteBookController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 3/10/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import Firebase

class AddNoteBookController: UIViewController {
    
    let cancelButton: UIButton = {
        let button = UIButton()
        let attributedText = NSMutableAttributedString(string: "Cancel", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor:paletteSystemGreen])
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = paletteSystemWhite
        view.addSubview(cancelButton)
        cancelButton.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, bottomAnchor: nil, leadingAnchor: view.safeAreaLayoutGuide.leadingAnchor, trailingAnchor: nil, paddingTop: 8, paddingBottom: 8, paddingLeft: 8, paddingRight: 8, width: 120, height: 30)
    }
}
