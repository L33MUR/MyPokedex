//
//  HomeCollectionViewCell.swift
//  MyPokedex
//
//  Created by Pedro  Rey Simons on 10/03/2021.
//

import Foundation

// MARK: - HomeCollectionViewCell -
class HomeCollectionViewCell: UICollectionViewCell {
    static let identifier  = "HomeCollectionViewCell"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
        setupSelectedBackgroundView()
        
    }
    
    func setupSelectedBackgroundView(){
        let bckgrView = UIView()
        bckgrView.layer.cornerRadius = 8
        bckgrView.backgroundColor = ThemeManager.currentTheme().secondaryColor.withAlphaComponent(0.75)
        self.selectedBackgroundView = bckgrView
        self.selectedBackgroundView!.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,centerX: nil,centerY: nil  ,padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    func setupContentView(){
        contentView.addSubview(imageView)
        contentView.addSubview(labelName)
        contentView.addSubview(labelId)
        contentView.addSubview(imageViewPokeball)
        contentView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,centerX: nil,centerY: nil,
                           padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = ThemeManager.currentTheme().primaryColor.cgColor
        contentView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.anchor(top: contentView.topAnchor,
                         leading: contentView.leadingAnchor,
                         bottom: nil,
                         trailing: contentView.trailingAnchor,
                         centerX: nil,
                         centerY: nil)
        
        labelName.anchor(top: imageView.bottomAnchor,
                         leading: contentView.leadingAnchor,
                         bottom: contentView.bottomAnchor,
                         trailing: contentView.trailingAnchor,
                         centerX: nil,
                         centerY: nil)
        
        labelId.topAnchor.constraint      (equalTo: contentView.topAnchor,constant: -4).isActive = true
        labelId.leadingAnchor.constraint  (equalTo: contentView.leadingAnchor,constant: 2).isActive = true
        labelId.widthAnchor.constraint    (equalTo: contentView.widthAnchor, multiplier: 0.25).isActive = true
        labelId.heightAnchor.constraint   (equalTo: contentView.heightAnchor, multiplier: 0.25).isActive = true
        
        
        imageViewPokeball.bottomAnchor.constraint   (equalTo: imageView.bottomAnchor,constant: -2).isActive = true
        imageViewPokeball.trailingAnchor.constraint (equalTo: imageView.trailingAnchor,constant: -2).isActive = true
        imageViewPokeball.widthAnchor.constraint    (equalTo: contentView.widthAnchor, multiplier: 0.15).isActive = true
        imageViewPokeball.heightAnchor.constraint   (equalTo: contentView.heightAnchor, multiplier: 0.15).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = ThemeManager.currentTheme().tertiaryColor.withAlphaComponent(0.25)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let labelName:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = ThemeManager.currentTheme().primaryColor
        label.textColor = ThemeManager.currentTheme().titleTextColor
        label.textAlignment = .center
        label.font = .systemFont(ofSize:12)
        label.adjustsFontSizeToFitWidth = true
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    let imageViewPokeball:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.init(named: Constants.Images.pokeball)
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    let labelId:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text =  "#000"
        label.backgroundColor = UIColor.clear
        label.font = .systemFont(ofSize: 8)
        label.textColor = ThemeManager.currentTheme().primaryColor
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
}
