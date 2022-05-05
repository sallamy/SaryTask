//
//  SmartCollectionViewCell.swift
//  SaryTask
//
//  Created by concarsadmin on 5/3/22.
//

import UIKit

class SmartCollectionViewCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black
        label.textAlignment = .justified
        return label
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    func buildUI(){
 
       
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        imageView.setConstraints(top: contentView.topAnchor,bottom: contentView.bottomAnchor,  leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, paddingTop: 10,paddingBottom: 40, paddingLeading: 2, paddingTrailing: 2)
        nameLabel.setConstraints(top: imageView.bottomAnchor, centerX: contentView.centerXAnchor,  height: 20)
       
    }
}
