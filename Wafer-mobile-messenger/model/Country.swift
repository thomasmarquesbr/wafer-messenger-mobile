//
//  Country.swift
//  Wafer-mobile-messenger
//
//  Created by Thomás Marques Brandão Reis on 24/08/2018.
//  Copyright © 2018 Thomás Marques Brandão Reis. All rights reserved.
//

import UIKit

/**
 Country model.
 **/
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
    var languages: [Language]?
    var translations: [String: String]?
    var flag: String?
    var regionalBlocs: [RegionalBloc]?
    var cioc: String?
    
    // Initializes a model of Country with its respective properties if possible.
    init?(data: Any) {
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
        demonym = values["demonym"] as? String
        area = values["area"] as? Float
        gini = values["gini"] as? Float
        timezones = values["timezones"] as? [String]
        borders = values["borders"] as? [String]
        nativeName = values["nativeName"] as? String
        numericCode = values["numericCode"] as? Int
        currencies = getCurrencies(data: values["currencies"] as Any)
        languages = getLanguages(data: values["languages"] as Any)
        translations = values["translations"] as? [String: String]
        flag = values["flag"] as? String
        regionalBlocs = getRegionalBlocs(data: values["regionalblocks"] as Any)
        cioc = values["cioc"] as? String
    }
    
    // Create the Currencies list if possible.
    private func getCurrencies(data: Any) -> [Currency]? {
        guard let values = data as? [Any] else { return nil }
        var currenciesArray = [Currency]()
        for curr in values {
            if let currency = Currency(data: curr) {
                currenciesArray.append(currency)
            }
        }
        return currenciesArray
    }
    
    // Create the Languages list if possible.
    private func getLanguages(data: Any) -> [Language]? {
        guard let values = data as? [Any] else { return nil }
        var languagesArray = [Language]()
        for lang in values {
            if let language = Language(data: lang) {
                languagesArray.append(language)
            }
        }
        return languagesArray
    }
    
    // Create the RegionalBlocs list if possible.
    private func getRegionalBlocs(data: Any) -> [RegionalBloc]? {
        guard let values = data as? [Any] else { return nil }
        var regionalBlocsArray = [RegionalBloc]()
        for reg in values {
            if let regionalBloc = RegionalBloc(data: reg) {
                regionalBlocsArray.append(regionalBloc)
            }
        }
        return regionalBlocsArray
    }
    
    // Converts the class properties to an array of strings to make it easier to display its details in the ViewController. Null properties are disregarded.
    func toArray() -> [String] {
        var array = [String]()
        if let name = name { array.append("name:\(name)") }
        if let topLevelDomain = topLevelDomain, topLevelDomain.count > 0 {
            array.append("Top level domain:\(topLevelDomain.joined(separator: ", "))")
        }
        if let alpha2Code = alpha2Code { array.append("Alpha 2 code:\(alpha2Code)") }
        if let alpha3Code = alpha3Code { array.append("Alpha 3 Code:\(alpha3Code)") }
        if let callingCodes = callingCodes, callingCodes.count > 0 {
            array.append("Calling codes:\(callingCodes)")
        }
        if let capital = capital { array.append("Capital:\(capital)") }
        if let altSpellings = altSpellings, altSpellings.count > 0 {
            array.append("Alt spellings:\(altSpellings.joined(separator: ", "))")
        }
        if let region = region { array.append("Region:\(region)") }
        if let subregion = subregion { array.append("Sub region:\(subregion)") }
        if let population = population { array.append("Population:\(population)") }
        if let latlng = latlng, latlng.count > 0 {
            array.append("Lat lng:\(latlng)")
        }
        if let demonym = demonym { array.append("Demonym:\(demonym)") }
        if let area = area { array.append("Area:\(area)") }
        if let gini = gini { array.append("Gini:\(gini)") }
        if let timezones = timezones, timezones.count > 0 {
            array.append("Timezones:\(timezones.joined(separator: ", "))") }
        if let borders = borders, borders.count > 0 {
            array.append("Borders:\(borders.joined(separator: ", "))")
        }
        if let nativeName = nativeName { array.append("Native name:\(nativeName)") }
        if let numericCode = numericCode { array.append("Numeric code:\(numericCode)") }
        if let currencies = currencies, currencies.count > 0 {
            var names = ""
            currencies.forEach({ names.append("\($0.name ?? ""), ") })
            names = String(names.dropLast(2))
            array.append("Currencies:\(names)")
        }
        if let languages = languages, languages.count > 0 {
            var names = ""
            languages.forEach({ names.append("\($0.name ?? ""), ") })
            names = String(names.dropLast(2))
            array.append("Languages:\(names)")
        }
        if let translations = translations, translations.count > 0 {
            let keys = Array(translations.keys)
            array.append("Translations:\(keys.joined(separator: ", "))")
        }
        if let flag = flag { array.append("Flag:\(flag)") }
        if let regionalBlocs = regionalBlocs, regionalBlocs.count > 0 {
            var names = ""
            regionalBlocs.forEach({ names.append("\($0.name ?? ""), ") })
            names = String(names.dropLast(2))
            array.append("Regional blocs:\(names)")
        }
        if let cioc = cioc, !cioc.isEmpty { array.append("Cioc:\(cioc)") }
        return array
    }
    
}
