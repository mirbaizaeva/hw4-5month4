//
//  ViewController.swift
//  hw4,5month4
//
//  Created by Nurjamal Mirbaizaeva on 24/4/23.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UITextFieldDelegate {

    private var controller: MainController?
    
//    private lazy var searchTextField: UITextField = {
//        let view = UITextField()
//        view.placeholder = "поиск"
//        view.backgroundColor = .white
//        view.layer.cornerRadius = 12
//        view.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
//        return view
//    }()

    private var serchcontroller = UISearchController(searchResultsController: nil)
    
    private var filtProduct = [Product(id: <#T##Int#>, title: <#T##String#>, description: <#T##String#>, price: <#T##Int#>, thumbnail: <#T##String#>)]
    
     var filt = [Product]()
    private var serchbarIsEmty:Bool{
        guard let text = serchcontroller.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var IsFilltre:Bool{
        return serchcontroller.isActive && !serchbarIsEmty
    }
    
    lazy var productsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseId)
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .cyan
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        serchcontroller.searchResultsUpdater = self
        serchcontroller.obscuresBackgroundDuringPresentation = false
        serchcontroller.searchBar.placeholder = "Поиск"
        navigationItem.searchController = serchcontroller
        definesPresentationContext = true
        
        controller = MainController(view: self)
        setupSubviews()
        view.backgroundColor = .cyan
        controller?.fetchProducts()
    }
    
    @objc func editingChanged() {
        getUserProduct()
//        print(searchTextField.text!)
    }
    func getUserProduct(){
//       controller?.findProducts(searchText: searchTextField.text ?? "")
//        return searchTextField.text ?? ""
    }
    private func setupSubviews() {
//        view.addSubview(searchTextField)
//        searchTextField.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.left.equalToSuperview().offset(20)
//            make.right.equalToSuperview().offset(-20)
//            make.height.equalTo(44)
//        }
        
        view.addSubview(productsCollectionView)
        productsCollectionView.snp.makeConstraints { make in
//            make.top.equalTo(searchTextField.snp.bottom).offset(20)
            make.top.equalToSuperview().offset(60)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
        }
    }
    
    func reloadProductsCollectionView() {
        DispatchQueue.main.async {
            self.productsCollectionView.reloadData()
        }
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if IsFilltre{
            return filt.count
        }
        return controller?.getProducts().count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.reuseId, for: indexPath) as! ProductCell
        cell.fill(product: (controller?.getProducts()[indexPath.row])!)
        var product:Product
        if IsFilltre {
            product = filt[indexPath.row]
        }else{
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Alert title", message: "Alert message", preferredStyle: .alert)
        let action2 = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action2)
        
        let action3 = UIAlertAction(title: "Хотите перейти", style: .destructive) { [self] result in
            let vc = DetailViewController()
            vc.titleNameChangec = self.controller?.getProducts()[indexPath.row].title
            vc.imagePhone.kf.setImage(with: URL(string: (controller?.getProducts()[indexPath.row].thumbnail)!))
            vc.descriptionChange = self.controller?.getProducts()[indexPath.row].description
            self.present(vc, animated: true)
        }
        alert.addAction(action3)
        self.present(alert, animated: true)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 2) - 20, height: 290)
    }
}
extension ViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController){
        filrtProduct(serchcontroller.searchBar.text!)
    }
    
    
    private func filrtProduct(_ search:String){
        filt = filtProduct.filter({ (Product1:Product ) -> Bool in
            return Product1.title.lowercased().contains(search.lowercased())
        })
        productsCollectionView.reloadData()
    }
}

