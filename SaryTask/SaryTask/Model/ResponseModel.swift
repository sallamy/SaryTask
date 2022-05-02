//
//  BannerResponseModel.swift
//  SaryTask
//
//  Created by concarsadmin on 5/1/22.
//

import Foundation

enum UIType: String {
    case grid = "grid"
    case linear = "linear"
    case slider = "slider"
}

enum DataCellType: String {
    case smart = "smart"
    case group = "group"
    case banner = "banner"
}

protocol CatalogItemViewDataProtocol {
    var itemName: String? { get  }
    var imageUrl: String? { get  }
    var itemLink: String? { get  }
}

protocol SectionViewDataProtocol {
    var title: String? { get  }
    var showTitle: Bool? { get  }
    var collectionViewType: UIType? { get  }
    var dataCellViewType: DataCellType? { get  }
    var rowCount: Int? { get }
    var items: [CatalogItemViewDataProtocol]? { get }
}

struct BannerResponse: Codable {
   private var result: [BannerModel]?
}

extension BannerResponse: SectionViewDataProtocol {
    var title: String? {
        return nil
    }
    
    var showTitle: Bool? {
        return false
    }
    
    var collectionViewType: UIType? {
        return UIType.slider
    }
    
    var dataCellViewType: DataCellType? {
        return DataCellType.banner
    }
    
    var rowCount: Int? {
        return nil
    }
    
    var items: [CatalogItemViewDataProtocol]? {
        return result
    }
    
}

struct CatalogResult: Codable {
    var result: [CatalogModel]?
}

struct CatalogModel: Codable {
    private var id: Int?
    private var data: [CatalogItemModel]?
    internal var title: String?
    private var data_type: String?
    private var show_title: Bool?
    private var ui_type: String?
    private var row_count: Int?
}

extension CatalogModel: SectionViewDataProtocol {
    var showTitle: Bool? {
        return show_title ?? false
    }
    
    var collectionViewType: UIType? {
        return UIType.init(rawValue:  ui_type ?? "")
    }
    
    var dataCellViewType: DataCellType? {
        return DataCellType.init(rawValue: data_type ?? "")
    }
    
    var rowCount: Int? {
        return row_count
    }
    
    var items: [CatalogItemViewDataProtocol]? {
        return data
    }
    
    
}

struct CatalogItemModel: Codable {
    private var group_id: Int?
    private var name: String?
    private var image: String?
    private var deep_link: String?
    private var empty_content_image: String?
    private var empty_content_Message: String?
    private var has_data: Bool?
    private var show_unavailable_items: Bool?
    private var show_in_brochure_link: Bool?
}

extension CatalogItemModel: CatalogItemViewDataProtocol {
    var itemName: String? {
        return name
    }
    
    var imageUrl: String? {
     return image
    }
    
    var itemLink: String? {
        return deep_link
    }
}

struct BannerModel: Codable {
    private var id: Int?
    private var title: String?
    private var description: String?
    private var button_text: String?
    private var expiry_status: Bool?
    private var created_at: String?
    private var start_date: String?
    private var expiry_date: String?
    private var image: String?
    private var priority: Int?
    private var photo: String?
    internal var link: String?
    private var level: String?
    private var is_available: Bool?
    private var branch: Int?
}

extension BannerModel: CatalogItemViewDataProtocol {
    var itemName: String? {
        return title
    }
   
    var itemLink: String? {
        return link
    }
    
    var imageUrl: String? {
        return image
    }
}
