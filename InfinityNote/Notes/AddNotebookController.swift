//
//  AddNoteBookController.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 3/10/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class AddNotebookController: UIViewController {
    
    var notebookController: NoteBookController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = paletteSystemWhite
        setupNavBar()
        setupTextField()
    }
    
    let newNotebookTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Notebook Name"
        textfield.tintColor = paletteSystemGreen
        textfield.textColor = paletteSystemGrayBlue
        textfield.font = UIFont.systemFont(ofSize: 24)
        textfield.textAlignment = .center
        return textfield
    }()
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleCreate() {
        guard let notebookTitle = newNotebookTextField.text, notebookTitle.count > 0 else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child(uid).child("notebooks").child(notebookTitle).setValue("") { (err, ref) in
            if let err = err {
                print("Oops, looks like something went wrong: ", err)
                return
            }
            print("Successful in creating new notebook.")
            let notebook = Notebook(notebookTitle: notebookTitle)
            self.notebookController?.addNotebook(notebook: notebook)
            self.dismiss(animated: true, completion: nil)
        }
    }

    func setupTextField() {
        view.addSubview(newNotebookTextField)
        newNotebookTextField.anchor(topAnchor: view.safeAreaLayoutGuide.topAnchor, bottomAnchor: nil, leadingAnchor: view.safeAreaLayoutGuide.leadingAnchor, trailingAnchor: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 20, paddingBottom: 20, paddingLeft: 20, paddingRight: 20, width: 0, height: 200)
    }
    
    fileprivate func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.title = "New Notebook"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(handleCreate))
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = paletteSystemWhite
    }
    

}
