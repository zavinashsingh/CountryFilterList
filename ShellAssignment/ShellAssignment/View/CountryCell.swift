//
//  CountryCell.swift
//  ShellAssignment
//
//  Created by Avinash on 1/31/19.
//  Copyright © 2019 Learning. All rights reserved.
//

import UIKit
import Alamofire

class CountryCell: UITableViewCell {
    
    var imageCache = [String:UIImage]()
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    
    var country: Country! {
        didSet {
            countryNameLabel.text = country.name
            if internetAvailable{
                if let image = imageCache[country.flagURL!]{
                    self.flagImageView.image = image
                }else{
                    guard let url = URL(string: country.flagURL!) else { return }
                    let anSVGImage = SVGKImage(contentsOf: url)
                    imageCache[country.flagURL!] = anSVGImage?.uiImage
                    self.flagImageView.image = anSVGImage?.uiImage
                }
            }else{
                self.flagImageView.image = APIService.shared.countryFlagImage(countryName: country.name!)
            }
        }
    }
}
