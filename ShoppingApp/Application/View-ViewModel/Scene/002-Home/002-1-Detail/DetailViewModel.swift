//
//  DetailModel.swift
//

import Foundation

protocol DetailModelProtocol: ItemModelProtocol {
    var productDesc: String? { get set }
}

struct DetailModel: DetailModelProtocol {
    var brand: String?
    var name: String?
    var productDesc: String?
    var price: String?
    var offerPrice: String?
    var productUrl: String?
    
    init(_ viewModel: HomePageModel) {
        brand = viewModel.brand
        name = viewModel.name
        productDesc = viewModel.productDesc
        price = viewModel.price
        offerPrice = viewModel.offerPrice
        productUrl = viewModel.productUrl
    }
}
