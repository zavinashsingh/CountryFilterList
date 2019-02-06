//
//  APIService.swift
//  ShellAssignment
//
//  Created by Avinash on 1/31/19.
//  Copyright © 2019 Learning. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    static let shared = APIService()
    
    func fetchCountries(searchText: String, completionHandler: @escaping ([Country]) -> ()) {
        let urlString = "https://restcountries.eu/rest/v2/name/\(searchText)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        Alamofire.request(urlString!).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print(err)
                return
            }
            guard let data = dataResponse.data else { return }
            do {
                let searchResult = try JSONDecoder().decode([Country].self, from: data)
                completionHandler(searchResult)
            } catch let decodeErr {
                print("Failed to decode:", decodeErr)
            }
        }
    }
    
    func fetchCountryDetails(countryName: String, completionHandler: @escaping ([RootClass]) -> ()) {
        let urlString = "https://restcountries.eu/rest/v2/name/\(countryName)?fullText=true".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

        Alamofire.request(urlString!).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print(err)
                return
            }
            guard let data = dataResponse.data else { return }
            do {
                let searchResult = try JSONDecoder().decode([RootClass].self, from: data)
                completionHandler(searchResult)
            } catch let decodeErr {
                print("Failed to decode:", decodeErr)
            }
        }
    }
    
    func countryFlagImage(countryName:String?) -> UIImage {
        let fileManager = FileManager.default
        var flagImage =  UIImage()
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let data = try Data(contentsOf: documentDirectory.appendingPathComponent(countryName!))
            let anSVGImage = SVGKImage(data: data)
            flagImage =  (anSVGImage?.uiImage)!
        }
        catch{
            debugPrint(error.localizedDescription)
        }
        return flagImage
    }
    
}
