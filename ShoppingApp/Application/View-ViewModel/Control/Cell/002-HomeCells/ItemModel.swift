//
//  ItemModel.swift
//

import Foundation

protocol ItemModelProtocol {
    var brand: String? { get set }
    var name: String? { get set }
    var price: String? { get set }
    var offerPrice: String? { get set }
    var productUrl: String? { get set }
}

struct ItemModel: ItemModelProtocol {
    var brand: String?
    var name: String?
    var price: String?
    var offerPrice: String?
    var productUrl: String?
    
    init(_ viewModel: HomePageModel) {
        brand = viewModel.brand
        name = viewModel.name
        price = viewModel.price
        offerPrice = viewModel.offerPrice
        productUrl = viewModel.productUrl
    }
}
