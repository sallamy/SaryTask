//
//  BannerCollectionViewCell.swift
//  SaryTask
//
//  Created by concarsadmin on 5/3/22.
//

import UIKit
import SDWebImage
import RxSwift
import RxGesture
import RxRelay

class BannerViewCell: UITableViewCell, UIScrollViewDelegate {
    
    static let idenetifier = "BannerViewCell"
    private let disposeBag = DisposeBag()
    private var parentController: UIViewController?
    private  lazy var collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: UICollectionViewFlowLayout())
    private  let items: BehaviorRelay<[CatalogItemViewDataProtocol]> = BehaviorRelay(value: [])
    var timer = Timer()
    var currentItem: Int = 0
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black
        label.textAlignment = .justified
        return label
    }()
    
    private  lazy var  pageControl: UIPageControl = {
        let pageControl  = UIPageControl()
        return pageControl
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
        self.contentView.addSubview(pageControl)
        nameLabel.setConstraints(top: self.topAnchor,trailing: self.trailingAnchor,paddingTrailing: 16)
        collectionView.setConstraints(top: nameLabel.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor,paddingTop: 15,paddingBottom: 30,paddingLeading: 15,paddingTrailing: 15,  height: 160)
        pageControl.setConstraints(bottom: collectionView.bottomAnchor,  paddingBottom: 10, height: 20)
        pageControl.makeItCentered(centerX: self.centerXAnchor)
    }
    
    func configureCell(bannerViewData: SectionViewDataProtocol, parent: UIViewController) {
        self.parentController = parent
        guard let bannerItems = bannerViewData.items  else { return  }
        pageControl.numberOfPages = bannerItems.count
        if let title = bannerViewData.title , !title.isEmpty , let showTitle = bannerViewData.showTitle, showTitle {
            self.nameLabel.text = title
        }
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true
        collectionView.clipsToBounds = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        self.items.accept(bannerItems)
        if let rowCount = bannerViewData.rowCount {
            if rowCount == 1 {
                collectionView.layer.cornerRadius = 25
            }
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            let width = (Int(self.frame.width) - 30)/rowCount
            layout.itemSize = CGSize(width: width, height: width)
        }else {
            collectionView.layer.cornerRadius = 25
            let width = (Int(self.frame.width) - 30)
            layout.itemSize = CGSize(width: width, height: 160)
        }
    }
    
   @objc func updateCounter() {
        if currentItem < self.collectionView.numberOfItems(inSection: 0) {
            self.collectionView.scrollToItem(at: IndexPath(item: currentItem, section: 0), at: .right, animated: true)
            self.currentItem += 1
        } else {
            self.currentItem = 0
        }
    }
    
    private  func registerCollectionView(){
        self.collectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: "BannerCollectionViewCell")
    }
    
    private  func bindCollectionViewCell() {
        self.items.bind(to:self.collectionView.rx.items(cellIdentifier: "BannerCollectionViewCell", cellType: BannerCollectionViewCell.self)) { row, data, cell in
            cell.imageView.sd_setImage(with: URL(string:  data.imageUrl ?? "" ))
        }.disposed(by: disposeBag)
        
        self.collectionView.rx.modelSelected(CatalogItemViewDataProtocol.self).subscribe { [weak self] event in
            guard let self = self else { return  }
            if let parent = self.parentController, let link  = event.element?.itemLink {
                UIAlertController.show(link, from: parent )
            }
        }.disposed(by: disposeBag)
    }
}
