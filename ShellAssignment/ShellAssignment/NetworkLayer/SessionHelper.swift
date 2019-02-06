//
//  WebClient.swift
//  ShellAssignment
//
//  Created by Avinash on 1/31/19.
//  Copyright © 2019 Learning. All rights reserved.
//

import UIKit

struct SessionHelper {
    
    private init(){
        
    }
    
    //This method will make service call to get the country list by accepting the string as parameter
    static func getCountryList(searchSting:String, completionHandler: @escaping (([RootClass],Bool)->Void)){
        
        let request = NSMutableURLRequest(url: URL(string: "https://restcountries.eu/rest/v2/name/\(searchSting)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 30.0)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                //MARK: to be fixed when we handle alert
                print(error?.localizedDescription as Any)
            } else {
                //let httpResponse = response as? HTTPURLResponse
                do{
                    let root : [RootClass] = try JSONDecoder().decode([RootClass].self, from: data!)
                    completionHandler(root, true)
                }catch{
                    print(error)
                }
                
            }
        })
        
        dataTask.resume()
    }
    
}
