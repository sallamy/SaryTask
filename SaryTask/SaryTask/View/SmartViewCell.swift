//
//  SmartCollectionViewCell.swift
//  SaryTask
//
//  Created by concarsadmin on 5/3/22.
//

import UIKit


class SmartViewCell: SectionBaseTableViewCell {
    
    static let idenetifier = "SmartViewCell"
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
        registerCollectionView()
        bindCollectionViewCell()
    }
    
     func buildUI(){
        backgroundColor  = UIColor.white
        selectionStyle = .none
        contentView.addSubview(nameLabel)
        contentView.addSubview(collectionView)
        nameLabel.setConstraints(top: contentView.topAnchor,trailing: contentView.trailingAnchor,paddingTrailing: 16,height: 24)
        collectionView.setConstraints(top: nameLabel.bottomAnchor,bottom: contentView.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor,paddingTop: 15,paddingBottom: 30,paddingLeading: 15,paddingTrailing: 15,  height: 100)
    }
    
    func configureCell(viewData: SectionViewDataProtocol) {
        
        guard let bannerItems = viewData.items  else { return  }
        
        if let title = viewData.title , !title.isEmpty , let showTitle = viewData.showTitle, showTitle {
            self.nameLabel.text = title
        }
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        if viewData.collectionViewType == .grid && viewData.dataCellViewType == .group {
            layout.scrollDirection = .vertical
        }else {
            layout.scrollDirection = .horizontal
        }
        
        collectionView.isPagingEnabled = true
        collectionView.clipsToBounds = true
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        if let rowCount = viewData.rowCount {
            let width = (Int(UIScreen.main.bounds.width - 30))/rowCount
            layout.itemSize = CGSize(width: width, height: width)
            layout.minimumLineSpacing = 0
        }
        self.items.accept(bannerItems)
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
