//
//  SaryTaskTests.swift
//  SaryTaskTests
//
//  Created by concarsadmin on 5/2/22.
//

import XCTest
@testable import SaryTask

class SaryTaskTests: XCTestCase {

    
    func testDecodingModel()  {
        let jsonBanner = [
            "id": 117,
                        "title": "هلا والله بشريكنا الغالي ! 🚀",
                        "description": "ابشر بـ خصم ٥٪ يوصل إلى ٥٠ ريال على اول طلب وعليها توصيل مجاني. استخدم كود الخصم: Hala",
                        "button_text": "اطلب الان ⬅️",
                        "expiry_status": false,
                        "created_at": "2020-06-09",
                        "start_date": "09/06/2020",
                        "expiry_date": "31/12/2020",
                        "image": "https://devcdn.sary.co/banners/2020/06/09/June_Banners-02.png",
                        "priority": 5000,
                        "photo": "https://devcdn.sary.co/June_Banners-04.png",
                        "link": "sary://sary.com/discount?promocode=hala",
                        "level": "global",
                        "is_available": true,
                        "branch": 5 ] as [String : Any]
      
        do {
            let bannerData = try jsonBanner.toData(options: .prettyPrinted)
            let bannerModel = try JSONDecoder().decode(BannerModel.self, from: bannerData)
            XCTAssertNotNil(bannerModel)
        } catch (let error)  {
        print(error)
        }
    }
    
    func testApi() {
//        let expectation = self.expectation(description: "Response Come")
//        var resultViewData: SectionViewDataProtocol?
//        HomeRepository.getBanner { success, error, result in
//            resultViewData = result
//            expectation.fulfill()
//        }
//        waitForExpectations(timeout: 5, handler: nil)
//        XCTAssertNotNil(resultViewData)
        
        
        let expectation = self.expectation(description: "Response Come")
        var resultViewData: [SectionViewDataProtocol]?
        HomeRepository.getCatalog { success, error, result in
            resultViewData = result
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(resultViewData)
    }

}

extension Dictionary {
    func toData(options: JSONSerialization.WritingOptions = []) throws -> Data {
        return try JSONSerialization.data(withJSONObject: self, options: options)
    }
}
