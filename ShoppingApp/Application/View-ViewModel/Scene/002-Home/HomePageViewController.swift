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
        dispatchGroup.enter()
        Router.getHttpServiceForAPI(App.StringConstants.itemsURL) { [weak self] json in
            guard let self = self else { return }
            if let responseData = json as? [String: Any], let data = responseData[App.StringConstants.data] as? [String: Any], let products = data[App.StringConstants.products] as? [[String: Any]] {
                self.filterModel = self.loadCollectionViewData(products)
                self.viewModel = self.loadCollectionViewData(products)
            }
            self.dispatchGroup.leave()
        } onFailure: { [weak self] error in
            MessageView.show(error?.localizedDescription ?? App.StringConstants.invalidURLError)
            self?.dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            self?.reloadCollectionView()
        }
    }
    
    private func reloadCollectionView() {
        if viewModel.count > 2, !userAddedToRewardsProgram {
            viewModel.insert(RewardModel(text: App.StringConstants.rewardsProgramMessage, image: App.Images.reward), at: 2)
        }
        collectionView.reloadData()
    }
    
    private func loadCollectionViewData(_ products: [[String: Any]]) -> [Any] {
        var model = [Any]()
        products.forEach { item in
            model.append(getModuleItem(item))
        }
        return model
    }
    
    private func getModuleItem(_ item: [String: Any]) -> HomePageModel {
        return HomePageModel(brand: item[App.StringConstants.brand] as? String, name: item[App.StringConstants.name] as? String, productDesc: item[App.StringConstants.productDesc] as? String, price: item[App.StringConstants.price] as? String, offerPrice: item[App.StringConstants.offerPrice] as? String, productUrl: item[App.StringConstants.productUrl] as? String)
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
        
        searchField.layer.borderColor = App.Theme.current.package.accentColor.cgColor
        searchField.layer.borderWidth = 0.2
        searchField.tintColor = App.Theme.current.package.accentColor
        searchField.textColor = App.Theme.current.package.primaryTextColor
        searchField.returnKeyType = .search
        searchField.backgroundColor = .clear
        searchField.delegate = self
    }
    
    private func filterViewModel(_ searchText: String?) {
        if let text = searchText, text.count > 0 {
            viewModel = filterModel.filter({ model in
                guard let model = model as? HomePageModel else { return false }
                if let name = model.name, let brand = model.brand, let desc = model.productDesc {
                    return name.containsIgnoresCase(text) || brand.containsIgnoresCase(text) || desc.containsIgnoresCase(text)
                }
                return false
            })
            reloadCollectionView()
        } else {
            viewModel = filterModel
            reloadCollectionView()
        }
    }
    
    @IBAction func sortTapped(_ sender: UIButton) {
        viewModel = viewModel.lazy.sorted (by: ({ [weak self] first, second in
            guard let modelOne = first as? HomePageModel, let modelTwo = second as? HomePageModel, let self = self, let nameOne = modelOne.name, let nameTwo = modelTwo.name else { return false }
            return self.sortAtoZ ? (nameOne < nameTwo) : (nameOne > nameTwo)
        }))
        sortAtoZ = !sortAtoZ
        reloadCollectionView()
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
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if viewModel[indexPath.row] is HomePageModel {
            return CGSize(width: App.ScreenSize.width/2, height: UIDevice.isIpad ? 190 : 320)
        } else if viewModel[indexPath.row] is RewardModel {
            return CGSize(width: App.ScreenSize.width, height: 60)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let modelItem = viewModel[indexPath.row] as? HomePageModel {
            if UIDevice.isIpad {
                if let styleTwoCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeStyleTwoCell.identifier, for: indexPath) as? HomeStyleTwoCell {
                    styleTwoCell.configure(ItemModel(modelItem))
                    return styleTwoCell
                }
            }
            if let styleOneCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeStyleOneCell.identifier, for: indexPath) as? HomeStyleOneCell {
                styleOneCell.configure(ItemModel(modelItem))
                return styleOneCell
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
            userAddedToRewardsProgram = true
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
