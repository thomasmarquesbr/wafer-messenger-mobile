//
//  DataManager.swift
//  Wafer-mobile-messenger
//
//  Created by Thomás Marques Brandão Reis on 24/08/2018.
//  Copyright © 2018 Thomás Marques Brandão Reis. All rights reserved.
//

import Foundation

class DataManager {
    
    let strUrl = "https://restcountries.eu/rest/v2/all"

    func getCountries(completion: @escaping([Country])->Void) {
        let url = NSURL(string: strUrl)
        URLSession.shared.dataTask(with: (url as URL?)!) { (data, response, error) in
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [Any] else {
                completion([])
                return
            }
            var countries = [Country]()
            for obj in jsonObj! {
                if let country = Country(data: obj) {
                    countries.append(country)
                }
            }
            completion(countries)
        }.resume()
    }
    
}
