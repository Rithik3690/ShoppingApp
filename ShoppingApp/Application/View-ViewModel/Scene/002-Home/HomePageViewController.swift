//
//  HomePageViewController.swift
//

import UIKit


class HomePageViewController: UIViewController {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    private let dispatchGroup = DispatchGroup()
    
    var viewModel = [Any]()
    var filterModel = [Any]()
    var userAddedToRewardsProgram: Bool = false
    var sortAtoZ: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = App.StringConstants.home
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: App.Theme.current.package.primaryTextColor]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: App.Images.person_fill, style: .plain, target: self, action: #selector(profileButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = App.Theme.current.package.primaryTextColor
        view.backgroundColor = App.Theme.current.package.backgroundColor
        getItemsFromAPI()
        setupCollectionView()
        setupSearchAndSort()
    }
    
    @objc func profileButtonTapped() {
        navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
    
    private func getItemsFromAPI() {
        Router.getHttpServiceForAPI(App.StringConstants.itemsURL) { [weak self] json in
            guard let self = self else { return }
            if let responseData = json as? [String: Any], let data = responseData[App.StringConstants.data] as? [String: Any], let products = data[App.StringConstants.products] as? [[String: Any]] {
                self.viewModel = products
                self.loadCollectionViewData(products)
            }
        } onFailure: { error in
            MessageView.show(error?.localizedDescription ?? App.StringConstants.invalidURLError)
        }
    }
    
    private func loadCollectionViewData(_ products: [Any]) {
        filterModel.removeAll()
        if let items = products as? [[String: Any]] {
            for index in 0..<items.count {
                if UIDevice.isIpad {
                    if index == 4 || index == 5 {
                        filterModel.append(self.getModuleItem(.styleTwo, item: items[index]))
                        continue
                    }
                    filterModel.append(self.getModuleItem(.styleOne, item: items[index]))
                    continue
                }
                if index == 2 || index == 3 || index == 8 {
                    filterModel.append(self.getModuleItem(.styleTwo, item: items[index]))
                    continue
                }
                filterModel.append(self.getModuleItem(.styleOne, item: items[index]))
            }
        } else {
            for index in 0..<products.count {
                if var model = products[index] as? HomePageModel {
                    if UIDevice.isIpad {
                        if index == 4 || index == 5 {
                            model.itemStyle = .styleTwo
                            filterModel.append(model)
                            continue
                        }
                        model.itemStyle = .styleOne
                        filterModel.append(model)
                        continue
                    }
                    if index == 2 || index == 3 || index == 8 {
                        model.itemStyle = .styleTwo
                        filterModel.append(model)
                        continue
                    }
                    model.itemStyle = .styleOne
                    filterModel.append(model)
                }
            }
        }
        if filterModel.count > 3, !userAddedToRewardsProgram {
            filterModel.insert(RewardModel(text: App.StringConstants.rewardsProgramMessage, image: App.Images.reward), at: UIDevice.isIpad ? 4 : 2)
        }
        DispatchQueue.main.async { [weak self] in
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
    
    private func setupSearchAndSort() {
        sortButton.setTitleColor(App.Theme.current.package.primaryTextColor, for: .normal)
        sortButton.backgroundColor = .clear
        sortButton.setTitle("", for: .normal)
        
        searchButton.setTitleColor(App.Theme.current.package.primaryTextColor, for: .normal)
        searchButton.backgroundColor = .clear
        searchButton.setTitle("", for: .normal)
        
        searchField.tintColor = App.Theme.current.package.accentColor
        searchField.textColor = App.Theme.current.package.primaryTextColor
        searchField.returnKeyType = .search
        searchField.backgroundColor = .clear
        searchField.delegate = self
    }
    
    private func filterViewModel(_ searchText: String?) {
        if let text = searchText, text.count > 0 {
            let model = viewModel.filter({ model in
                guard let model = model as? [String: Any] else { return false }
                if let name = model[App.StringConstants.name] as? String, let brand = model[App.StringConstants.brand] as? String, let desc = model[App.StringConstants.productDesc] as? String {
                    return name.containsIgnoresCase(text) || brand.containsIgnoresCase(text) || desc.containsIgnoresCase(text)
                }
                return false
            })
            loadCollectionViewData(model)
        } else {
            loadCollectionViewData(viewModel)
        }
        
    }
    
    @IBAction func sortTapped(_ sender: UIButton) {
        filterModel = filterModel.filter({ $0 is HomePageModel }).sorted(by: { [weak self] first, second in
            guard let model1 = first as? HomePageModel, let name1 = model1.name, let model2 = second as? HomePageModel, let name2 = model2.name, let self = self else { return false }
            return self.sortAtoZ ? name1 < name2 : name1 > name2
        })
        sortAtoZ = !sortAtoZ
        loadCollectionViewData(filterModel)
    }
    
    @IBAction func searchTapped(_ sender: UIButton) {
        filterViewModel(searchField.text)
    }
    
}


extension HomePageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        filterViewModel(String(("\(textField.text ?? "")\(string)").dropLast(range.length)))
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        filterViewModel(textField.text)
        textField.resignFirstResponder()
        return true
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let modelItem = filterModel[indexPath.row] as? HomePageModel {
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
        } else if filterModel[indexPath.row] is RewardModel {
            return CGSize(width: App.ScreenSize.width, height: 60)
        }
            return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let modelItem = filterModel[indexPath.row] as? HomePageModel {
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
        } else if let modelItem = filterModel[indexPath.row] as? RewardModel {
            if let rewardsCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRewardsProgramCell.identifier, for: indexPath) as? HomeRewardsProgramCell {
                rewardsCell.configure(modelItem)
                return rewardsCell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.cellForItem(at: indexPath) is HomeRewardsProgramCell {
            filterModel.remove(at: indexPath.row)
            userAddedToRewardsProgram = true
            collectionView.reloadData()
            AlertView.show(alertItem: AlertViewItem(image: App.Images.reward_success,headerText: App.StringConstants.HURRAY, headerColor: App.Theme.current.package.accentColor, messageText: App.StringConstants.rewardsProgramSuccessMessage, acceptButtonText: App.StringConstants.ok, cancelButtonText: App.StringConstants.dismiss))
            return
        }
        let vc = DetailViewController()
        if let model = filterModel[indexPath.row] as? HomePageModel {
            vc.detailModel = DetailModel(model)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
