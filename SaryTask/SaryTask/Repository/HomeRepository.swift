//
//  FourSquareRepository.swift
//  Task
//
//  Created by  mohamed salah
//

import Foundation
import UIKit
import Alamofire

final class HomeRepository {

    class func getBanner(complete: @escaping(_ success: Bool,
                                            _ error: String?,
                                            _ result: SectionViewDataProtocol?)->Void) {
        AF.request(APIRouter.getBanners).validate().responseDecodable { (response: DataResponse<BannerResponse?, AFError>) in
            
            switch response.result {
            case .success(let response):
               
                complete(true,nil,response)
                break
            case .failure(let error):
               
                complete(false, error.errorDescription, nil)
                break
            }
        }
    }
    
    class func getCatalog(complete: @escaping(_ success: Bool,
                                            _ error: String?,
                                            _ result: [SectionViewDataProtocol]?)->Void) {
        AF.request(APIRouter.getCatalog).validate().responseDecodable { (response: DataResponse<CatalogResult?, AFError>) in
            
            switch response.result {
            case .success(let response):
               
                complete(true,nil,response?.result)
                break
            case .failure(let error):
               
                complete(false, error.errorDescription, nil)
                break
            }
        }
    }
}

