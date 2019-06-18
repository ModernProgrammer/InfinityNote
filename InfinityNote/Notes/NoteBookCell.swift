//
//  HomeNoteBookBodyCell.swift
//  InfinityNote
//
//  Created by Diego  Bustamante on 2/24/18.
//  Copyright © 2018 Diego Bustamante. All rights reserved.
//

import UIKit
import UICollectionViewParallaxCell

class NoteBookCell: UICollectionViewParallaxCell, UIGestureRecognizerDelegate {
    let contraint: CGFloat = 20
    let cornerRadius: CGFloat = 20
    var notebook: Notebook? {
        didSet{
            guard let notebookTitle = notebook?.notebookTitle else { return }
            let attributedText = NSMutableAttributedString(string: notebookTitle, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .bold),NSAttributedString.Key.foregroundColor: paletteSystemWhite])
            self.notebookTitle.attributedText = attributedText
            let image = UIImage(named: "pic8")
            notebookImage.image = image
            setupbackgroundParallax(imageView: notebookImage, cornerRadius: cornerRadius, paddingOffset: paddingOffset, topConstraint: contraint, bottomConstraint: contraint, leadingConstraint: contraint, trailingConstraint: contraint)
            setupCellUI()
        }
    }
    

    let gradientTop : CAGradientLayer = {
        let gradient = CAGradientLayer()
        return gradient
    }()

    let gradientBottom : CAGradientLayer = {
        let gradient = CAGradientLayer()
        return gradient
    }()

    let container: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    let menuButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icons8-menu"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let notebookImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let notebookLineSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = paletteSystemLineSeparatorColor
        return view
    }()
    
    let notebookTitle: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Title", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: paletteSystemWhite])
        label.attributedText = attributedText
        label.textAlignment = .center
        return label
    }()
    
    let nextArrow: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "rightArrow")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var gradientContrainer : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleButtonPress() {
        print("BUTTON PRESS")
    }
    
    func setupGradient() {
        gradientContrainer.frame = CGRect(x: 0, y: 0, width: frame.width-(contraint * 2), height: frame.height-(contraint * 2))
        gradientBottom.frame = gradientContrainer.bounds
        gradientBottom.cornerRadius = cornerRadius
        gradientBottom.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
    }
    
    override func layoutSubviews() {
        setupGradient()
    }
    
    func setupCellUI() {
        addSubview(gradientContrainer)
        gradientContrainer.anchor(topAnchor: topAnchor, bottomAnchor: bottomAnchor, leadingAnchor: leadingAnchor, trailingAnchor: trailingAnchor, paddingTop: contraint, paddingBottom: contraint, paddingLeft: contraint, paddingRight: contraint, width: 0, height: 0)
        gradientContrainer.layer.insertSublayer(gradientBottom, at: 0)

        let stackView = UIStackView(arrangedSubviews: [notebookTitle, UIView(), menuButton])
        addSubview(stackView)
        menuButton.addTarget(self, action: #selector(handleButtonPress), for: .touchUpInside)
        menuButton.alpha = 0.8
        stackView.anchor(topAnchor: nil, bottomAnchor: bottomAnchor, leadingAnchor: leadingAnchor, trailingAnchor: trailingAnchor, paddingTop: 0, paddingBottom: 20, paddingLeft: 30, paddingRight: 25, width: 0, height: 44)
    }
    
    func setupShadow() {
        addSubview(container)
        container.anchor(topAnchor: topAnchor, bottomAnchor: bottomAnchor, leadingAnchor: leadingAnchor, trailingAnchor: trailingAnchor, paddingTop: contraint, paddingBottom: contraint, paddingLeft: contraint, paddingRight: contraint, width: 0, height: 0)
        container.layer.cornerRadius = cornerRadius
        let shadowView = UIView(frame: CGRect(x: container.frame.minX, y: container.frame.minY, width: frame.width-(contraint * 2), height: frame.height-(contraint * 2)))
        shadowView.clipsToBounds = false
        shadowView.layer.shadowColor = UIColor(white: 0.0, alpha: 1.0).cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 10)
        shadowView.layer.shadowRadius = 10
        shadowView.layer.shouldRasterize = true
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.frame, cornerRadius: 20).cgPath
        container.addSubview(shadowView)
    }
}
