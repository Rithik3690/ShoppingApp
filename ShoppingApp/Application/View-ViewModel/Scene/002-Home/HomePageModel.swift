//
//  HomePageModel.swift
//

import UIKit

protocol HomeModelProtocol: DetailModelProtocol {
    var itemStyle: ItemStyle? { get set }
}
enum ItemStyle {
    case styleOne, styleTwo
}

struct HomePageModel: HomeModelProtocol {
    var brand: String?
    var name: String?
    var productDesc: String?
    var price: String?
    var offerPrice: String?
    var productUrl: String?
    var itemStyle: ItemStyle?
}
