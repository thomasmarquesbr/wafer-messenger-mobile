//
//  Country.swift
//  Wafer-mobile-messenger
//
//  Created by Thomás Marques Brandão Reis on 24/08/2018.
//  Copyright © 2018 Thomás Marques Brandão Reis. All rights reserved.
//

import UIKit

class Country {
    
    var name: String?
    var topLevelDomain: [String]?
    var alpha2Code: String?
    var alpha3Code: String?
    var callingCodes: [Int]?
    var capital: String?
    var altSpellings: [String]?
    var region: String?
    var subregion: String?
    var population: Int?
    var latlng: [Float]?
    var demonym: String?
    var area: Float?
    var gini: Float?
    var timezones: [String]?
    var borders: [String]?
    var nativeName: String?
    var numericCode: Int?
    var currencies: [Currency]?
    //    var languages: [Language]?
    var translations: [String: String]?
    var flag: String?
    //    let regionalBlocs: [RegionalBlock]?
    var cioc: String?
    
    init(data: Any) {
        guard let values = data as? [String: Any] else { return }
        name = values["name"] as? String
        topLevelDomain = values["topLevelDomain"] as? [String]
        alpha2Code = values["alpha2Code"] as? String
        alpha3Code = values["alpha3Code"] as? String
        callingCodes = values["callingCodes"] as? [Int]
        capital = values["capital"] as? String
        altSpellings = values["altSpellings"] as? [String]
        region = values["region"] as? String
        subregion = values["subregion"] as? String
        population = values["population"] as? Int
        latlng = values["latlng"] as? [Float]
        demonym = values[""] as? String
        area = values["area"] as? Float
        gini = values["gini"] as? Float
        timezones = values["timezones"] as? [String]
        borders = values["borders"] as? [String]
        nativeName = values["nativeName"] as? String
        numericCode = values["numericCode"] as? Int
        currencies = getCurrencies(data: values["currencies"] as Any)
        //languages
        translations = values["translations"] as? [String: String]
        flag = values["flag"] as? String
        //regionalblocks
        cioc = values["cioc"] as? String
    }
    
    func getCurrencies(data: Any) -> [Currency]? {
        guard let values = data as? [Any] else { return nil }
        var currenciesArray = [Currency]()
        for curr in values {
            if let currency = Currency(data: curr) {
                currenciesArray.append(currency)
            }
        }
        return currenciesArray
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
