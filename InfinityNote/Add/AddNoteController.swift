//
//  AddNoteController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/16/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit

class AddNoteController: UIViewController  {
    let addNoteButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSMutableAttributedString(string: "Add Note", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: paletteSystemWhite])
        button.setAttributedTitle(attributedText, for: .normal)
        button.backgroundColor = paletteSystemBlue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleAddNote), for: .touchUpInside)
        return button
    }()
    
    let buttonContainer: UIView = {
        let view = UIView()
        //view.backgroundColor = paletteSystemWhite
        return view
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSMutableAttributedString(string: "Cancel", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: paletteSystemWhite])
        button.setAttributedTitle(attributedText, for: .normal)
        button.backgroundColor = paletteSystemGrayBlue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = paletteSystemGreen
        setupUIButtonLayout()
        
    }
    
    @objc func handleAddNote() {
        print("add note")
        let newNoteController = NewNoteController()
        let newNoteControllerNav = UINavigationController(rootViewController: newNoteController)
        present(newNoteControllerNav, animated: true, completion: nil)
        
    }
    
    
    func setupUIButtonLayout(){
        
        view.addSubview(addNoteButton)
        view.addSubview(cancelButton)
                
        
        let stackView = UIStackView(arrangedSubviews: [addNoteButton,cancelButton])
        view.addSubview(stackView)
        stackView.anchor(topAnchor:nil, bottomAnchor: nil, leadingAnchor: nil, trailingAnchor: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 200, height: 100)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
}
