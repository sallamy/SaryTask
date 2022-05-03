//
//  SmartCollectionViewCell.swift
//  SaryTask
//
//  Created by concarsadmin on 5/3/22.
//

import UIKit
import SDWebImage
import RxSwift
import RxGesture
import RxRelay
import SVProgressHUD

class SmartViewCell: UITableViewCell {
    
    static let idenetifier = "SmartViewCell"
    private let disposeBag = DisposeBag()
    private  lazy var collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: UICollectionViewFlowLayout())
    private  let items: BehaviorRelay<[CatalogItemViewDataProtocol]> = BehaviorRelay(value: [])
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black
        label.textAlignment = .justified
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
        registerCollectionView()
        bindCollectionViewCell()
    }

    
    private func buildUI(){
        self.backgroundColor  = UIColor.white
        self.selectionStyle = .none
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(collectionView)

        nameLabel.setConstraints(top: self.topAnchor,trailing: self.trailingAnchor,paddingTrailing: 16)
        collectionView.setConstraints(top: nameLabel.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor,paddingTop: 15,paddingBottom: 30,paddingLeading: 15,paddingTrailing: 15,  height: 100)
    }
    
    func configureCell(viewData: SectionViewDataProtocol) {

        guard let bannerItems = viewData.items  else { return  }

        if let title = viewData.title , !title.isEmpty , let showTitle = viewData.showTitle, showTitle {
            self.nameLabel.text = title
        }
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true
        collectionView.clipsToBounds = true
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        self.items.accept(bannerItems)
        if let rowCount = viewData.rowCount {
            let width = (Int(UIScreen.main.bounds.width - 30))/rowCount
            layout.itemSize = CGSize(width: width, height: width)
            layout.minimumLineSpacing = 0
        }
    }
    
    
    private  func registerCollectionView(){
        self.collectionView.register(SmartCollectionViewCell.self, forCellWithReuseIdentifier: "SmartCollectionViewCell")
    }
    
    private  func bindCollectionViewCell() {
        self.items.bind(to:self.collectionView.rx.items(cellIdentifier: "SmartCollectionViewCell", cellType: SmartCollectionViewCell.self)) { row, data, cell in
            cell.imageView.sd_setImage(with: URL(string:  data.imageUrl ?? "" ))
            cell.nameLabel.text = data.itemName
        }.disposed(by: disposeBag)
    }
}
