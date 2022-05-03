//
//  HomeViewModel.swift
//  SaryTask
//
//  Created by concarsadmin on 5/3/22.
//

import Foundation
import RxSwift
import RxRelay

class HomeViewModel {
    
    let sections: BehaviorRelay<[SectionViewDataProtocol]> = BehaviorRelay(value: [])
    let isLoading = PublishSubject<Bool>()
   
    // MARK: - CallApi
    func getBanner() {
        self.isLoading.onNext(true)
        HomeRepository.getBanner { [weak self] success, error, result in
            guard let self = self else {return}
            self.isLoading.onNext(false)
            if success , let banner = result {
                self.sections.accept([banner])
            }
            self.getCatalog()
        }
    }
    
    func getCatalog() {
        self.isLoading.onNext(true)
        HomeRepository.getCatalog { [weak self] success, error, result in
            guard let self = self else {return}
            self.isLoading.onNext(false)
            if success, let catalogResponse = result {
                self.sections.accept(self.sections.value + catalogResponse)
            }
        }
    }
    
}
