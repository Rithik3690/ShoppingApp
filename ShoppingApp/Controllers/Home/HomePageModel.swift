//
//  HomePageModel.swift
//

import UIKit

enum ItemStyle {
    case styleOne, styleTwo
}

struct HomePageModel {
    let brand: String?
    let name: String?
    let productDesc: String?
    let price: String?
    let offerPrice: String?
    let productUrl: String?
    let itemStyle: ItemStyle?
}


struct RewardModel {
    let text: String?
    let image: UIImage?
}
