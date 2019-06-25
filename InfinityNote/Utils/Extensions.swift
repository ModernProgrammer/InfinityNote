//
//  Extensions.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/10/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import Firebase

// App Palette Coolers
var paletteSystemWhite = UIColor.rgb(red: 253, green: 255, blue: 252)
var paletteSystemBlue = UIColor.rgb(red: 54, green: 75, blue: 110)
var paletteSystemGreen = UIColor.rgb(red: 38, green: 196, blue: 133)
var paletteSystemGrayBlue = UIColor.rgb(red: 39, green: 40, blue: 34)
var paletteSystemTan = UIColor.rgb(red: 241, green: 247, blue: 237)
var paletteSystemLineSeparatorColor = UIColor(white: 0.0, alpha: 0.1)

extension UIColor{
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIApplication {
    static func mainTabBarController() -> MainTabBarController? {
        return shared.keyWindow?.rootViewController as? MainTabBarController
    }
    
}

extension UIView {
    func anchor(topAnchor: NSLayoutYAxisAnchor?, bottomAnchor: NSLayoutYAxisAnchor?, leadingAnchor: NSLayoutXAxisAnchor?, trailingAnchor: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingBottom: CGFloat, paddingLeft: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop).isActive = true
        }
        if let bottomAnchor = bottomAnchor {
            self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -paddingBottom).isActive = true
        }
        
        if let leadingAnchor = leadingAnchor {
            self.leadingAnchor.constraint(equalTo: leadingAnchor, constant: paddingLeft).isActive = true
        }
        
        if let trailingAnchor = trailingAnchor {
            self.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func fadeIn(_ duration: TimeInterval = 0.3, delay: TimeInterval = 0.3, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 0.3, delay: TimeInterval = 0.3, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}

extension UIViewController {
    func sortNotebookByDate(notebooks: [Notebook]) ->[Notebook] {
        let sortedNotebooks = notebooks.sorted{
            let d1 = $0.date, d2 = $1.date
            return d1 > d2
        }
        return sortedNotebooks
    }
    
    func sortNoteByDate(notes: [Note]) ->[Note] {
        let sortedNotes = notes.sorted{
            let d1 = $0.date, d2 = $1.date
            return d1 > d2
        }
        return sortedNotes
    }
    
    func sortBookmarkByDate(notes: [Note]) ->[Note] {
        let sortedNotes = notes.sorted{
            let d1 = $0.bookmarkDate, d2 = $1.bookmarkDate
            return d1 > d2
        }
        return sortedNotes
    }
    
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func setupNavBar(barTintColor : UIColor, tintColor: UIColor, textColor: UIColor, clearNavBar: Bool, largeTitle: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = largeTitle
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationBar.barTintColor = barTintColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:textColor]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:textColor]
        if clearNavBar {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.isTranslucent = true
        } else {
            navigationController?.navigationBar.isTranslucent = true
        }
        
    }
}

extension Database{
    static func setNoteBookmark(note: Note, bookmarkBool: Bool, bookmarkDate: String){
        let uid = note.uid
        let notebookTitle = note.notebookTitle
        let noteTitle = note.noteTitle
        let dictionaryValues = ["bookmark": bookmarkBool, "bookmarkDate": bookmarkDate] as [String : Any]
        Database.database().reference().child(uid).child("notebooks").child(notebookTitle).child(noteTitle).updateChildValues(dictionaryValues, withCompletionBlock: { (err, ref) in
            if let err = err {
                print("Oops... looks like something went wrong: ", err)
                return
            }
        })
    }
}



extension UISearchBar {
    var textColor:UIColor? {
        get {
            if let textField = self.value(forKey: "searchField") as?
                UITextField  {
                return textField.textColor
            } else {
                return nil
            }
        }
        
        set (newValue) {
            if let textField = self.value(forKey: "searchField") as?
                UITextField  {
                textField.textColor = newValue
            }
        }
    }
}







