//
//  HomePageViewController.swift
//

import UIKit


class HomePageViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let dispatchGroup = DispatchGroup()
    
    var viewModel = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = App.StringConstants.home
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: App.Theme.current.package.primaryTextColor]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: App.Images.person_fill, style: .plain, target: self, action: #selector(profileButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = App.Theme.current.package.primaryTextColor
        view.backgroundColor = App.Theme.current.package.backgroundColor
        getItemsFromAPI()
        setupCollectionView()
    }
    
    @objc func profileButtonTapped() {
        navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
    
    private func getItemsFromAPI() {
        viewModel.removeAll()
        dispatchGroup.enter()
        Router.getHttpServiceForAPI(App.StringConstants.itemsURL) { [weak self] json in
            guard let self = self else { return }
            if let responseData = json as? [String: Any], let data = responseData[App.StringConstants.data] as? [String: Any], let products = data[App.StringConstants.products] as? [[String: Any]] {
                for index in 0..<products.count {
                    if UIDevice.isIpad {
                        if index == 4 || index == 5 {
                            self.viewModel.append(self.getModuleItem(.styleTwo, item: products[index]))
                            continue
                        }
                        self.viewModel.append(self.getModuleItem(.styleOne, item: products[index]))
                        continue
                    }
                   if index == 2 || index == 3 || index == 8 {
                       self.viewModel.append(self.getModuleItem(.styleTwo, item: products[index]))
                       continue
                    }
                    self.viewModel.append(self.getModuleItem(.styleOne, item: products[index]))
                }
                self.viewModel.insert(RewardModel(text: App.StringConstants.rewardsProgramMessage, image: App.Images.reward), at: UIDevice.isIpad ? 4 : 2)
            }
            self.dispatchGroup.leave()
        } onFailure: { [weak self] error in
            MessageView.show(error?.localizedDescription ?? App.StringConstants.invalidURLError)
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func getModuleItem(_ style: ItemStyle, item: [String: Any]) -> HomePageModel {
        return HomePageModel(brand: item[App.StringConstants.brand] as? String, name: item[App.StringConstants.name] as? String, productDesc: item[App.StringConstants.productDesc] as? String, price: item[App.StringConstants.price] as? String, offerPrice: item[App.StringConstants.offerPrice] as? String, productUrl: item[App.StringConstants.productUrl] as? String, itemStyle: style)
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
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let modelItem = viewModel[indexPath.row] as? HomePageModel {
            switch modelItem.itemStyle {
            case .styleOne:
                if UIDevice.isIpad {
                    return CGSize(width: App.ScreenSize.width/4, height: 320)
                }
                return CGSize(width: App.ScreenSize.width/2, height: 320)
            case .styleTwo:
                if UIDevice.isIpad {
                    return CGSize(width: App.ScreenSize.width/2, height: 190)
                }
                return CGSize(width: App.ScreenSize.width, height: 190)
            case .none:
                return CGSize.zero
            }
        } else if viewModel[indexPath.row] is RewardModel {
            return CGSize(width: App.ScreenSize.width, height: 60)
        }
            return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let modelItem = viewModel[indexPath.row] as? HomePageModel {
            switch modelItem.itemStyle {
            case .styleOne:
                if let styleOneCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeStyleOneCell.identifier, for: indexPath) as? HomeStyleOneCell {
                    styleOneCell.configure(ItemModel(modelItem))
                    return styleOneCell
                }
            case .styleTwo:
                if let styleTwoCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeStyleTwoCell.identifier, for: indexPath) as? HomeStyleTwoCell {
                    styleTwoCell.configure(ItemModel(modelItem))
                    return styleTwoCell
                }
                break
            case .none:
                break
            }
        } else if let modelItem = viewModel[indexPath.row] as? RewardModel {
            if let rewardsCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRewardsProgramCell.identifier, for: indexPath) as? HomeRewardsProgramCell {
                rewardsCell.configure(modelItem)
                return rewardsCell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.cellForItem(at: indexPath) is HomeRewardsProgramCell {
            viewModel.remove(at: indexPath.row)
            collectionView.reloadData()
            AlertView.show(alertItem: AlertViewItem(image: App.Images.reward_success,headerText: App.StringConstants.HURRAY, headerColor: App.Theme.current.package.accentColor, messageText: App.StringConstants.rewardsProgramSuccessMessage, acceptButtonText: App.StringConstants.ok, cancelButtonText: App.StringConstants.dismiss))
            return
        }
        let vc = DetailViewController()
        if let model = viewModel[indexPath.row] as? HomePageModel {
            vc.detailModel = DetailModel(model)
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
