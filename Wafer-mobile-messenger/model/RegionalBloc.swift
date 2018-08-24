//
//  RegionalBlock.swift
//  Wafer-mobile-messenger
//
//  Created by Thomás Marques Brandão Reis on 24/08/2018.
//  Copyright © 2018 Thomás Marques Brandão Reis. All rights reserved.
//

import UIKit

class RegionalBloc {
    
    var acronym: String?
    var name: String?
    var otherAcronyms: String?
    var otherNames: [String]?
    
    init?(data: Any) {
        guard let values = data as? [String: Any] else { return nil }
        acronym = values["acronym"] as? String
        name = values["name"] as? String
        otherAcronyms = values["otherAcronyms"] as? String
        otherNames = values["otherNames"] as? [String]
    }
    
}
