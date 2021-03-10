//
//  HomeViewController.swift
//  MyPokedex
//
//  Created by Pedro  Rey Simons on 01/03/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator and edited by Pedro Rey Simons.
//

import UIKit

final class HomeViewController: UIViewController{
    var presenter: HomePresenterInterface!
    private var collectionView:UICollectionView!
    //Filtering collectionView
    private var searchController = UISearchController(searchResultsController: nil)
    private var pokemonInstancesReal:[PokemonEntity] = []
    private var pokemonInstancesFiltered:[PokemonEntity] = []
    private var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    private var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    //Resets data base
    private var refreshBarButton: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(rightBarButtonPressed))
    }
    //Replace button while resetting
    private var activityBarButton:UIBarButtonItem {
        let activity = UIActivityIndicatorView(style:.medium)
        activity.startAnimating()
        return UIBarButtonItem(customView: activity)
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupSearchController()
        setupCollectionView()
        presenter.viewDidLoad()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.invalidateLayout()
    }
    
    func setupNavigationItem(){
        navigationItem.title = "Pokedex"
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.titleView?.tintColor = ThemeManager.currentTheme().titleTextColor
        navigationItem.setRightBarButton(refreshBarButton, animated: true)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    func setupSearchController(){
        edgesForExtendedLayout = [.top]
        extendedLayoutIncludesOpaqueBars = true
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Pokemons"
        searchController.definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              leading: view.safeAreaLayoutGuide.leadingAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              trailing: view.safeAreaLayoutGuide.trailingAnchor,
                              centerX: nil,
                              centerY: nil)
        
        collectionView.backgroundColor = ThemeManager.currentTheme().quaternaryColor
        collectionView.allowsSelection = true
    }
}

//MARK:- User actions -
extension HomeViewController{
    @objc func rightBarButtonPressed(){
        presenter.rightBarButtonPressed()
    }
}


// MARK: - UICollectionViewDelegate -
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let instance: PokemonEntity
        if isFiltering {
            instance = pokemonInstancesFiltered[indexPath.row]
        } else {
            instance = pokemonInstancesReal[indexPath.row]
        }
        presenter.didSelect(instance)
    }
}

// MARK: - UICollectionViewDataSource -
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
          return pokemonInstancesFiltered.count
        }
        return pokemonInstancesReal.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
        let instance: PokemonEntity
        if isFiltering {
            instance = pokemonInstancesFiltered[indexPath.row]
        } else {
            instance = pokemonInstancesReal[indexPath.row]
        }
        cell.imageView.image = UIImage(data: instance.image ?? Data())
        cell.labelName.text = instance.resourceName?.capitalized
        cell.labelId.text = "#\(instance.id)"
        cell.imageViewPokeball.isHidden = !instance.isCaptured
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout -
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    //Changes layout if device rotates
    private var numberOfItemsInRow:CGFloat {
        let itemsInRowPortrait:CGFloat = 3
        let itemsInRowLandscape:CGFloat = 6
        
        let windowInterfaceOrientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        if windowInterfaceOrientation!.isLandscape {
            return itemsInRowLandscape
        } else {
            return itemsInRowPortrait
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width)/numberOfItemsInRow, height: (view.frame.width)/numberOfItemsInRow)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension HomeViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
    
    func filterContentForSearchText(_ searchText: String) {
        pokemonInstancesFiltered = pokemonInstancesReal.filter({ (instance) -> Bool in
            if let name = instance.resourceName {
                return (name.lowercased().contains(searchText.lowercased()))
            }
            return true
        })
      collectionView.reloadData()
    }
}

// MARK: - HomeViewInterface -
extension HomeViewController: HomeViewInterface {
    func push(data: [PokemonEntity]) {
        pokemonInstancesReal = data
        pokemonInstancesFiltered = data
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func startActivity() {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            self.navigationItem.setRightBarButton(self.activityBarButton, animated: true)
        }
    }
    
    func stopActivity() {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            self.navigationItem.setRightBarButton(self.refreshBarButton, animated: true)
        }
    }
}
