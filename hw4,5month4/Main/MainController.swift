//
//  MainController.swift
//  hw4,5month4
//
//  Created by Nurjamal Mirbaizaeva on 24/4/23.
//

import Foundation

class MainController {
     weak var view: ViewController!
    
    private var model: MainModel?
    
    init(view: ViewController) {
        self.view = view
        self.model = MainModel(controller: self)
    }
    
    func fetchProducts() {
        model?.fetchProducts()
    }
    
    func getProducts() -> [Product] {
        let products = model?.getProducts()
        return products ?? []
    }
    
    func collectionViewReloaded() {
        view.reloadProductsCollectionView()
    }
    func findProducts(searchText: String){
        model?.findProducts(searchText: searchText)
    }
}
