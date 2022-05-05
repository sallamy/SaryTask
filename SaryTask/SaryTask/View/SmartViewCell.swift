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
        collectionView.isPagingEnabled = true
        collectionView.clipsToBounds = true
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        backgroundColor  = UIColor.white
        selectionStyle = .none
        contentView.addSubview(nameLabel)
        contentView.addSubview(collectionView)
        nameLabel.setConstraints(top: contentView.topAnchor,trailing: contentView.trailingAnchor,paddingTrailing: 16,height: 24)
        collectionView.setConstraints(top: nameLabel.bottomAnchor,bottom: contentView.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor,paddingTop: 15,paddingBottom: 30,paddingLeading: 15,paddingTrailing: 15)
    }
    
    func configureCell(viewData: SectionViewDataProtocol) {
        guard let bannerItems = viewData.items  else { return  }
        if let title = viewData.title , !title.isEmpty , let showTitle = viewData.showTitle, showTitle {
            self.nameLabel.text = title
        }
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        if let rowCount = viewData.rowCount {
            let width = (Int(UIScreen.main.bounds.width - 30))/rowCount
            layout.itemSize = CGSize(width: width, height: width)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
        self.items.accept(bannerItems)
        collectionView.layoutIfNeeded()
        collectionView.frame = CGRect(x: collectionView.frame.origin.x, y: collectionView.frame.origin.y, width: collectionView.frame.width , height: 100)
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
    }
    
    func configureGroupCell(viewData: SectionViewDataProtocol) {
        
        guard let bannerItems = viewData.items  else { return  }
        
        if let title = viewData.title , !title.isEmpty , let showTitle = viewData.showTitle, showTitle {
            self.nameLabel.text = title
        }
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        if viewData.collectionViewType == .grid  {
            layout.scrollDirection = .vertical
        }else  if viewData.collectionViewType == .slider || viewData.collectionViewType == .linear {
            layout.scrollDirection = .horizontal
            collectionView.isScrollEnabled = true
        }
        
        if let rowCount = viewData.rowCount {
            let width = (Int(UIScreen.main.bounds.width - 30))/rowCount
            layout.itemSize = CGSize(width: width, height: width)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
        self.items.accept(bannerItems)
        self.collectionView.reloadUI()
    }
    
    private  func registerCollectionView(){
        self.collectionView.register(SmartCollectionViewCell.self, forCellWithReuseIdentifier: "SmartCollectionViewCell")
    }
    
    private  func bindCollectionViewCell() {
        self.items.bind(to:self.collectionView.rx.items(cellIdentifier: "SmartCollectionViewCell", cellType: SmartCollectionViewCell.self)) { row, data, cell in
            cell.imageView.sd_setImage(with: URL(string:  data.imageUrl ?? "" ),placeholderImage: UIImage(named: "placeholder"))
            cell.nameLabel.text = data.itemName
        }.disposed(by: disposeBag)
    }
}
