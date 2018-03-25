//
//  HomeNoteBookBodyCell.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/24/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit

class NoteBookCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    var pan: UIPanGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellUI()
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCellUI()
    }
    
    
    var notebook: Notebook? {
        didSet{
            guard let notebookTitle = notebook?.notebookTitle else { return }
            let attributedText = NSMutableAttributedString(string: notebookTitle, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),NSAttributedStringKey.foregroundColor: paletteSystemGrayBlue])
            self.notebookTitle.attributedText = attributedText
        }
    }
    
    let deleteLabel: UILabel = {
        let label = UILabel()
        label.text = "delete"
        label.textColor = paletteSystemWhite
        return label
    }()
    
    let notebookImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "bookIcon")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let notebookLineSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = paletteSystemLineSeparatorColor
        return view
    }()
    
    let notebookTitle: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Title", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14),NSAttributedStringKey.foregroundColor: paletteSystemGrayBlue])
        label.attributedText = attributedText
        return label
    }()
    
    let nextArrow: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "rightArrow")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    func setupCellUI() {
        self.contentView.backgroundColor = paletteSystemWhite
        self.backgroundColor = UIColor.red

        addSubview(notebookImage)
        notebookImage.anchor(topAnchor: contentView.safeAreaLayoutGuide.topAnchor, bottomAnchor: contentView.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: contentView.safeAreaLayoutGuide.leadingAnchor, trailingAnchor: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 15, height: 0)
        
        addSubview(notebookTitle)
        notebookTitle.anchor(topAnchor: contentView.safeAreaLayoutGuide.topAnchor, bottomAnchor: contentView.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: notebookImage.trailingAnchor, trailingAnchor: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 160, height: 0)
        
        addSubview(nextArrow)
        nextArrow.anchor(topAnchor: contentView.safeAreaLayoutGuide.topAnchor, bottomAnchor: contentView.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: nil, trailingAnchor: contentView.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 8, width: 15, height: 0)
        
        addSubview(notebookLineSeperator)
        notebookLineSeperator.anchor(topAnchor: nil, bottomAnchor: contentView.safeAreaLayoutGuide.bottomAnchor, leadingAnchor: contentView.safeAreaLayoutGuide.leadingAnchor, trailingAnchor: contentView.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0.5)
        
        self.insertSubview(deleteLabel, belowSubview: self.contentView)

        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
    }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        if pan.state == UIGestureRecognizerState.began {
            return
        } else if pan.state == UIGestureRecognizerState.changed {
            self.setNeedsLayout()
        } else {
            if abs(pan.velocity(in: self).x) > 500 {
                let collectionView: UICollectionView = self.superview as! UICollectionView
                let indexPath: IndexPath = collectionView.indexPathForItem(at: self.center)!
                collectionView.delegate?.collectionView!(collectionView, performAction: #selector(onPan(_:)), forItemAt: indexPath, withSender: nil)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (pan.state == UIGestureRecognizerState.changed) {
            let p: CGPoint = pan.translation(in: self)
            let width = self.contentView.frame.width
            let height = self.contentView.frame.height
            self.contentView.frame = CGRect(x: p.x,y: 0, width: width, height: height);
            self.deleteLabel.frame = CGRect(x: p.x - deleteLabel.frame.size.width-10, y: 0, width: 100, height: height)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((pan.velocity(in: pan.view)).x) > abs((pan.velocity(in: pan.view)).y)
    }
    
}
