//
//  CountryDetails.swift
//  ShellAssignment
//
//  Created by Avinash Singh on 06/02/19.
//  Copyright © 2019 Learning. All rights reserved.
//

import Foundation
//import CoreData

class CountryDetailsModel : NSObject {
    var callingCode : String?
    var capital : String?
    var currencies : String?
    var flagURL : String?
    var languages : String?
    var name : String?
    var region : String?
    var subRegion : String?
    var timezones : String?
}
/*
class CountryDetails: NSManagedObject, Codable {
    
    // MARK: - Core Data Managed Object
    @NSManaged var name: String?
    @NSManaged var flagURL: String?
    @NSManaged var callingCode : String?
    @NSManaged var capital : String?
    @NSManaged var currencies : String?
    @NSManaged var languages : String?
    @NSManaged var region : String?
    @NSManaged var subRegion : String?
    @NSManaged var timezones : String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case flagURL = "flag"
        case callingCode
        case capital
        case currencies
        case languages
        case region
        case subRegion
        case timezones
    }
    //MARK:Decodable
    required convenience init(from decoder:Decoder) throws{
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "CountryDetails", in: managedObjectContext) else {
                return
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.flagURL = try container.decodeIfPresent(String.self, forKey: .flagURL)
        self.callingCode = try container.decodeIfPresent(String.self, forKey: .callingCode)
        self.capital = try container.decodeIfPresent(String.self, forKey: .capital)
        self.languages = try container.decodeIfPresent(String.self, forKey: .languages)
        self.currencies = try container.decodeIfPresent(String.self, forKey: .currencies)
        self.timezones = try container.decodeIfPresent(String.self, forKey: .timezones)
        self.region = try container.decodeIfPresent(String.self, forKey: .region)
        self.subRegion = try container.decodeIfPresent(String.self, forKey: .subRegion)
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(flagURL, forKey: .flagURL)
        try container.encode(capital, forKey: .capital)
        try container.encode(callingCode, forKey: .callingCode)
        try container.encode(languages, forKey: .languages)
        try container.encode(currencies, forKey: .currencies)
        try container.encode(region, forKey: .region)
        try container.encode(subRegion, forKey: .subRegion)
        try container.encode(timezones, forKey: .timezones)

    }
}
public extension CodingUserInfoKey {
    // Helper property to retrieve the context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}*/

