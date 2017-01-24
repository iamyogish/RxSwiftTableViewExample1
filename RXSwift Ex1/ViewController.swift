//
//  ViewController.swift
//  RXSwift Ex1
//
//  Created by Yogish on 1/24/17.
//  Copyright © 2017 TnE. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var cityTableView: UITableView!
    
    let allCities = ["Bengalooru", "Chennai", "Hyderabad", "Trivandrum", "Panaji", "Mumbai", "Bhopal", "Delhi", "Patna"]
    let disposeBag = DisposeBag()
    
    //We are making the shownCities as Variable containing the array of String, this will allow us to use this for binding with the cityTableView
    var shownCities: Variable<[String]> = Variable([])
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        
        setupSearchController()
        setupSearchObservation()
        setupTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        cityTableView.tableHeaderView = searchController.searchBar
    }
    
    //Rx Functions
    func setupSearchObservation() {
        //Setting observer to observe the text of search bar of search controller
        searchController
            .searchBar
            .rx
            .text
            .orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .asObservable()
            .filter {!$0.isEmpty}
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] (searchText) in
                self?.shownCities.value = self?.allCities.filter {$0.lowercased().hasPrefix(searchText.lowercased())} ?? []
            })
            .addDisposableTo(disposeBag)
        
        //Setting up observer to observe the cancelling of search bar
        //When user cancels the search, we will clear the shownCities
        //Uncomment the following, if you want to clear the tableview when the user presses cancel and dismiss the searchbar
        
//        searchController
//            .searchBar
//            .rx
//            .cancelButtonClicked
//            .subscribe(onNext: { [weak self] (_) in
//                self?.shownCities.value = []
//            })
//            .addDisposableTo(disposeBag)
    }
    
    func setupTableView() {
        //Here we make use of shownCities as observable and we will bind that observable to cityTableView
        //bindTo() function will say that for every element in the shownCities there should be a cell in the cityTableView.
        //At the end we will configure the each cell such that the textLabel of Cell will be binded with the city element of shownCities
        shownCities
            .asObservable()
            .bindTo(cityTableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) {
                row, city, cell in
                cell.textLabel?.text = city
            }
            .addDisposableTo(disposeBag)
    }
}

