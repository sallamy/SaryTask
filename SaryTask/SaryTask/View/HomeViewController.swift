//
//  ViewController.swift
//  SaryTask
//
//  Created by concarsadmin on 5/1/22.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import SVProgressHUD

class HomeViewController: UIViewController, UITableViewDelegate {
    
    let disposeBag = DisposeBag()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let  viewModel =  HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        self.view.backgroundColor = UIColor.white
        self.title = "Sary"
        buidUI()
        registerTableView()
        bindTableView()
        observeLoading()
        viewModel.getBanner()
    }
    
    func buidUI() {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.tableView)
        self.tableView.setConstraints(top: self.view.safeAreaLayoutGuide.topAnchor, bottom: self.view.bottomAnchor, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor, paddingTop: 16,paddingLeading: 0, paddingTrailing: 0)
    }
    
    func registerTableView() {
        self.tableView.register(BannerViewCell.self, forCellReuseIdentifier: BannerViewCell.idenetifier)
        self.tableView.register(SmartViewCell.self, forCellReuseIdentifier: SmartViewCell.idenetifier)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section  = viewModel.sections.value[indexPath.row]
        switch section.dataCellViewType {
        case .smart:
            return 120
        case .banner:
            return 210
        case .group:
            return 0
        case .none:
            return 0
        }
        
    }
    
}

// MARK: - RxBinding
extension HomeViewController {
    
    func observeLoading() {
        viewModel.isLoading.asObservable().subscribe { status in
            if let state = status.element, state == true{
                SVProgressHUD.show()
            }else {
                SVProgressHUD.dismiss()
            }
        }.disposed(by: disposeBag)
    }
    
    func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.sections.bind(to: tableView.rx.items){ [weak self] (tv, row, item) -> UITableViewCell in
            guard let self = self else { return UITableViewCell() }
            if item.dataCellViewType == .banner {
                if let cell = tv.dequeueReusableCell(withIdentifier: BannerViewCell.idenetifier ) as? BannerViewCell {
                    cell.configureCell(bannerViewData: item, parent: self)
                    return cell
                }
            }else  if item.dataCellViewType == .smart {
                if let cell = tv.dequeueReusableCell(withIdentifier: SmartViewCell.idenetifier ) as? SmartViewCell {
                    cell.configureCell(viewData: item)
                    return cell
                }
            }
            
            return UITableViewCell()
            
        }.disposed(by: disposeBag)
    }
    
}
