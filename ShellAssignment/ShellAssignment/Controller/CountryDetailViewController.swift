//
//  CountryDetailViewController.swift
//  ShellAssignment
//
//  Created by Avinash on 1/31/19.
//  Copyright © 2019 Learning. All rights reserved.
//

import UIKit
import CoreData
import SVGKit

class CountryDetailViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var capital: UILabel!
    @IBOutlet weak var callingCode: UILabel!
    @IBOutlet weak var region: UILabel!
    @IBOutlet weak var subRegion: UILabel!
    @IBOutlet weak var timeZone: UILabel!
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var language: UILabel!
    var countryDetail  = CountryDetailsModel()
    @IBOutlet weak var scrollview: UIScrollView!
    
    var country: Country? {
        didSet {
            if internetAvailable{
                APIService.shared.fetchCountryDetails(countryName: (country?.name)!) { (response) in
                    DispatchQueue.main.async { [weak self] in
                        self?.activityIndicator.startAnimating()
                        self?.title = self?.country?.name
                        self?.scrollview.isHidden = false
                        
                        self?.countryDetail.name =  response.first!.name
                        self?.countryDetail.capital =  response.first!.capital
                        self?.countryDetail.callingCode =  response.first!.callingCodes?.joined(separator: ", ")
                        self?.countryDetail.region =  response.first!.region
                        self?.countryDetail.subRegion =  response.first!.subregion
                        self?.countryDetail.timezones =  response.first!.timezones?.joined(separator: ", ")
                        let currencies : [Currency]  = response.first!.currencies!
                        var currencyList = ""
                        for each in currencies{
                            currencyList =  "\(each.name!), \(currencyList)"
                        }
                        currencyList.removeLast()
                        currencyList.removeLast()
                        let languages : [Language]  = response.first!.languages!
                        var languageList = ""
                        for each in languages{
                            languageList =  "\(each.name!), \(languageList)"
                        }
                        languageList.removeLast()
                        languageList.removeLast()
                        self?.countryDetail.currencies = currencyList
                        self?.countryDetail.languages =  languageList
                        self?.countryDetail.flagURL = response.first?.flag
                        self?.scrollview.isHidden = false
                        self?.updateView(countryDetail: (self?.countryDetail)!)
                    }
                }
            }
        }
    }
    
    func loadOffline(countryName: String){
        
        _ = self.readFromCoreData(countryName: countryName)
    }
    func readFromCoreData(countryName:String) -> Bool{
        let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CountryDetails")
        let predicate = NSPredicate(format: "name contains[c] %@",(country?.name)!)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        do {
            let result : [CountryDetails] = try context.fetch(request) as! [CountryDetails]
            for each in result{
                self.countryDetail.name =  each.name
                self.countryDetail.capital =  each.capital
                self.countryDetail.callingCode =  each.callingCode
                self.countryDetail.region =  each.region
                self.countryDetail.subRegion =  each.subRegion
                self.countryDetail.timezones =  each.timezones
                self.countryDetail.currencies =  each.currencies
                self.countryDetail.languages =  each.languages
                self.updateView(countryDetail: self.countryDetail)
                return true
            }
        } catch(let e) {
            debugPrint("Error: \(e)")
            return true
        }
        return false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(CountryDetailViewController.save))

        scrollview.isHidden = true
        saveButton.isEnabled = false
        
        self.navigationItem.rightBarButtonItem = saveButton
        if internetAvailable{
            saveButton.isEnabled = true
        }else{
            saveButton.isEnabled = false
        }
        if !internetAvailable{
            self.loadOffline(countryName: (country?.name)!)
        }
    }
    
    @objc func save(){
        let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        let context = persistentContainer.viewContext
        let entity  = CountryDetails(context:context)
        
        entity.name = self.countryName.text
        entity.callingCode = self.callingCode.text
        entity.capital = self.capital.text
        entity.region = self.region.text
        entity.subRegion = self.subRegion.text
        entity.currencies = self.currency.text
        entity.timezones = self.timeZone.text
        entity.languages = self.language.text
        self.downloadCountryFlag()
        
        do{
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func updateView(countryDetail: CountryDetailsModel){
        self.countryName.text = self.countryDetail.name
        self.callingCode.text = self.countryDetail.callingCode
        self.capital.text =  self.countryDetail.capital
        self.region.text = self.countryDetail.region
        self.subRegion.text = self.countryDetail.subRegion
        self.currency.text = self.countryDetail.currencies
        self.language.text = self.countryDetail.languages
        self.timeZone.text = self.countryDetail.timezones
        if internetAvailable{
            guard let url = URL(string: self.countryDetail.flagURL!) else { return }
            let anSVGImage = SVGKImage(contentsOf: url)
            imageView.image = anSVGImage?.uiImage
        }else{
            self.imageView.image = APIService.shared.countryFlagImage(countryName: country?.name!)
        }
        self.scrollview.isHidden =  false
        self.activityIndicator.stopAnimating()
    }
    
    private func downloadCountryFlag(){
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            guard let url = URL(string: self.countryDetail.flagURL!) else { return }
            let data : Data = try Data(contentsOf: url)
            let fileURL = documentDirectory.appendingPathComponent("\(self.countryDetail.name!)")
            do {
                _ = try data.write(to: fileURL)
                print("Hurray!!! \(self.countryDetail.name!) has been successfully saved for Offline :)")
            }catch(let e) {
                debugPrint("Error: \(e)")
            }
        }
        catch (let e){
            debugPrint("Error:\(e)")
        }
    }
}
