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


class BannerViewCell: UITableViewCell, UIScrollViewDelegate {
    
    static let idenetifier = "BannerViewCell"
    let disposeBag = DisposeBag()
    var parentController: UIViewController?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.clipsToBounds = true
        scrollView.layer.cornerRadius = 20
        return scrollView
    }()
    
    lazy var  pageControl: UIPageControl = {
        let pageControl  = UIPageControl()
        return pageControl
    }()
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }
           
        
    
    func buildUI(){
        self.backgroundColor  = UIColor.white
        self.selectionStyle = .none
        self.addSubview(scrollView)
        self.addSubview(pageControl)
        
        scrollView.setConstraints(top: self.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor,paddingLeading: 25,paddingTrailing: 25,  height: 160)
        pageControl.setConstraints(bottom: scrollView.bottomAnchor,  paddingBottom: 50, height: 20)
        pageControl.makeItCentered(centerX: self.centerXAnchor)
    }
    
    func setupScrollCarImages(bannerViewData: SectionViewDataProtocol) {
        guard let bannerItems = bannerViewData.items else { return  }
        pageControl.numberOfPages = bannerItems.count
       
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        for index in 0..<bannerItems.count {
            frame.origin.x = self.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            let imageView = UIImageView(frame: frame)
            imageView.contentMode = .scaleAspectFit
            imageView.sd_setImage(with: URL(string:  bannerItems[index].imageUrl ?? "" ))
            self.scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(bannerItems.count), height: scrollView.frame.size.height)
        scrollView.delegate = self
    
      
        scrollView.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return  }
            if let parent = self.parentController, let link  = bannerItems[self.scrollView.currentPage].itemLink  {
                UIAlertController.show(link, from: parent )
            }
        }).disposed(by: disposeBag)

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            pageControl.currentPage = self.scrollView.currentPage
    
    }
}


extension UIScrollView {
    var currentPage:Int{
        return Int((self.contentOffset.x+(0.5*self.frame.size.width))/self.frame.width)
    }
}
