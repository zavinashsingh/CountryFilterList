//
//  CountryListController.swift
//  ShellAssignment
//
//  Created by Avinash on 1/31/19.
//  Copyright © 2019 Learning. All rights reserved.
//

import UIKit
import CoreData
var internetAvailable =  false
class CountryListController: UITableViewController {
    var reachability = Reachability()
    let cellId = "cellId"
    var countries = [Country]()
    var timer: Timer?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var countriesSearchView = Bundle.main.loadNibNamed("CountriesSearchingView", owner: self, options: nil)?.first as? UIView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title  = "Country List"
        searchController.searchBar.placeholder  = "Country"
        
        NotificationCenter.default.addObserver( self, selector: #selector(self.rechabilityChanged),name: Notification.Name.reachabilityChanged, object:  reachability)
        
        do {
            try reachability?.startNotifier()
        }catch (let e){
            print("Error: \(e)")
        }
        
        setupSearchBar()
        setupTableView()
        if !internetAvailable{
            self.loadCountryWhenOffline(searchText: "")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.becomeFirstResponder()
    }
    
    @objc private func rechabilityChanged(notification: NSNotification){
        
        guard let reachability = notification.object as? Reachability else{
            return
        }
        if reachability.connection ==  .none{
            self.loadCountryWhenOffline(searchText: "")
            internetAvailable =  false
        }else{
            internetAvailable = true
        }
    }
    
    fileprivate func setupSearchBar() {
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    fileprivate func setupTableView() {
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "CountryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    func loadCountryWhenOffline(searchText: String){
        let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CountryDetails")
        if !searchText.isEmpty{
            let predicate = NSPredicate(format: "name contains[c] %@",searchText)
            request.predicate = predicate
        }
        request.returnsObjectsAsFaults = false
        do {
            let result : [CountryDetails] = try context.fetch(request) as! [CountryDetails]
            self.countries.removeAll()
            for each in result{
                let country =  Country.init(name: each.name, flagURL: each.flagURL)
                self.countries.append(country)
            }
        } catch(let e) {
            print("Error: \(e)")
        }
        self.tableView.reloadData()
    }
    
}

extension CountryListController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CountryCell
        
        let country = self.countries[indexPath.row]
        cell.country = country
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let countryDetailVC = CountryDetailViewController()
        countryDetailVC.country = self.countries[indexPath.row]
        self.navigationController?.pushViewController(countryDetailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter a Search Term"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.countries.isEmpty && searchController.searchBar.text?.isEmpty == true ? 250 : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return countriesSearchView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return countries.isEmpty && searchController.searchBar.text?.isEmpty == false ? 200 : 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchController.searchBar.resignFirstResponder()
    }
    
}


extension CountryListController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if internetAvailable{
            self.getCountryList(searchText)
            
        }else{
            self.loadCountryWhenOffline(searchText: searchText)
        }
    }
    
    func getCountryList(_ searchStr:String){
        timer?.invalidate()
        countries = []
        tableView.reloadData()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            APIService.shared.fetchCountries(searchText: searchStr) { (countries) in
                DispatchQueue.main.async {
                    self.countries = countries
                    self.tableView.reloadData()
                }
            }
        })
    }
}
