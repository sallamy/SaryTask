//
//  SectionBaseTableViewCell.swift
//  SaryTask
//
//  Created by concarsadmin on 5/3/22.
//

import UIKit
import SDWebImage
import RxSwift
import RxGesture
import RxRelay


class SectionBaseTableViewCell: UITableViewCell {
    let disposeBag = DisposeBag()

    lazy var collectionView = DynamicHeightCollectionView(frame: self.bounds, collectionViewLayout: UICollectionViewFlowLayout())
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black
        label.textAlignment = .justified
        return label
    }()
    
    let items: BehaviorRelay<[CatalogItemViewDataProtocol]> = BehaviorRelay(value: [])
    
    override func prepareForReuse() {
        self.nameLabel.text = ""
    }
    
    
}

class DynamicHeightCollectionView: UICollectionView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    func reloadUI() {
        self.layoutIfNeeded()
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width , height: 100)
        self.reloadData()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        return self.contentSize
    }
    
}
