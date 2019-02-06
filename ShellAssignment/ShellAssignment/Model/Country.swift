//
//  Country.swift
//  ShellAssignment
//
//  Created by Avinash on 1/31/19.
//  Copyright © 2019 Learning. All rights reserved.
//

import Foundation

struct Country: Decodable {
    let name: String?
    let flagURL: String?
    
    enum CodingKeys: String, CodingKey {
        case flagURL = "flag"
        case name
    }
}
