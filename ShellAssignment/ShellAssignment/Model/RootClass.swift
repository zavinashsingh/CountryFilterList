import Foundation

struct RootClass : Codable {

        let alpha2Code : String?
        let alpha3Code : String?
        let altSpellings : [String]?
        let area : Int?
        let borders : [String]?
        let callingCodes : [String]?
        let capital : String?
        let cioc : String?
        let currencies : [Currency]?
        let demonym : String?
        let flag : String?
        let gini : Float?
        let languages : [Language]?
        let latlng : [Float]?
        let name : String?
        let nativeName : String?
        let numericCode : String?
        let population : Int?
        let region : String?
        let regionalBlocs : [RegionalBloc]?
        let subregion : String?
        let timezones : [String]?
        let topLevelDomain : [String]?
        let translations : Translation?
    
}
