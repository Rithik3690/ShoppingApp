//
//  HomePageViewController.swift
//

import UIKit


class HomePageViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = StringConstants.home
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Theme.primaryTextColor]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: StringConstants.person_fill), style: .plain, target: self, action: #selector(profileButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = Theme.primaryTextColor
        view.backgroundColor = Theme.backgroundColor
        getItemsFromAPI()
        setupCollectionView()
    }
    
    @objc func profileButtonTapped() {
        navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
    
    private func getItemsFromAPI() {
        CoreModel.shared.homePageModelItems.removeAll()
        dispatchGroup.enter()
        HttpUtil.getHttpServiceForAPI("https://run.mocky.io/v3/bc09a745-4346-4025-9611-9da76366dbbc") { [weak self] json in
            guard let self = self else { return }
            if let responseData = json as? [String: Any], let data = responseData["data"] as? [String: Any], let products = data["products"] as? [[String: Any]] {
                for index in 0..<products.count {
                    if UIDevice.isIpad {
                        if index == 4 || index == 5 {
                            CoreModel.shared.homePageModelItems.append(self.getModuleItem(.styleTwo, item: products[index]))
                            continue
                        }
                        CoreModel.shared.homePageModelItems.append(self.getModuleItem(.styleOne, item: products[index]))
                        continue
                    }
                   if index == 2 || index == 3 || index == 8 {
                       CoreModel.shared.homePageModelItems.append(self.getModuleItem(.styleTwo, item: products[index]))
                       continue
                    }
                    CoreModel.shared.homePageModelItems.append(self.getModuleItem(.styleOne, item: products[index]))
                }
                CoreModel.shared.homePageModelItems.insert(RewardModel(text: "CLICK HERE TO JOIN OUR REWARDS PROGRAM", image: UIImage(named: "reward")), at: UIDevice.isIpad ? 4 : 2)
            }
            self.dispatchGroup.leave()
        } onFailure: { [weak self] error in
            MessageView.show(error?.localizedDescription ?? "Invalid URL")
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func getModuleItem(_ style: ItemStyle, item: [String: Any]) -> HomePageModel {
        return HomePageModel(brand: item["brand"] as? String, name: item["name"] as? String, productDesc: item["productDesc"] as? String, price: item["price"] as? String, offerPrice: item["offerPrice"] as? String, productUrl: item["productUrl"] as? String, itemStyle: style)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(HomeStyleOneCell.nib(), forCellWithReuseIdentifier: HomeStyleOneCell.identifier)
        collectionView.register(HomeStyleTwoCell.nib(), forCellWithReuseIdentifier: HomeStyleTwoCell.identifier)
        collectionView.register(HomeRewardsProgramCell.nib(), forCellWithReuseIdentifier: HomeRewardsProgramCell.identifier)
    }
}


extension HomePageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CoreModel.shared.homePageModelItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let modelItem = CoreModel.shared.homePageModelItems[indexPath.row] as? HomePageModel {
            switch modelItem.itemStyle {
            case .styleOne:
                if UIDevice.isIpad {
                    return CGSize(width: App.mainWidth/4, height: 320)
                }
                return CGSize(width: App.mainWidth/2, height: 320)
            case .styleTwo:
                if UIDevice.isIpad {
                    return CGSize(width: App.mainWidth/2, height: 190)
                }
                return CGSize(width: App.mainWidth, height: 190)
            case .none:
                return CGSize.zero
            }
        } else if CoreModel.shared.homePageModelItems[indexPath.row] is RewardModel {
            return CGSize(width: App.mainWidth, height: 60)
        }
            return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let modelItem = CoreModel.shared.homePageModelItems[indexPath.row] as? HomePageModel {
            switch modelItem.itemStyle {
            case .styleOne:
                if let styleOneCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeStyleOneCell.identifier, for: indexPath) as? HomeStyleOneCell {
                    styleOneCell.configure(modelItem)
                    return styleOneCell
                }
            case .styleTwo:
                if let styleTwoCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeStyleTwoCell.identifier, for: indexPath) as? HomeStyleTwoCell {
                    styleTwoCell.configure(modelItem)
                    return styleTwoCell
                }
                break
            case .none:
                break
            }
        } else if let modelItem = CoreModel.shared.homePageModelItems[indexPath.row] as? RewardModel {
            if let rewardsCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRewardsProgramCell.identifier, for: indexPath) as? HomeRewardsProgramCell {
                rewardsCell.configure(modelItem)
                return rewardsCell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.cellForItem(at: indexPath) is HomeRewardsProgramCell {
            CoreModel.shared.homePageModelItems.remove(at: indexPath.row)
            collectionView.reloadData()
            return
        }
        let vc = DetailViewController()
        vc.homePageModel = CoreModel.shared.homePageModelItems[indexPath.row] as? HomePageModel
        navigationController?.pushViewController(vc, animated: true)
    }
}
