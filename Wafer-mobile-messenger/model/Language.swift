//
//  Language.swift
//  Wafer-mobile-messenger
//
//  Created by Thomás Marques Brandão Reis on 24/08/2018.
//  Copyright © 2018 Thomás Marques Brandão Reis. All rights reserved.
//

import UIKit

/**
 Language model.
 **/
class Language {
    
    var iso639_1: String?
    var iso639_2: String?
    var name: String?
    var nativeName: String?
    
    // Initializes a model of Language with its respective properties if possible.
    init?(data: Any) {
        guard let values = data as? [String: Any] else { return nil }
        iso639_1 = values["iso639_1"] as? String
        iso639_2 = values["iso639_2"] as? String
        name = values["name"] as? String
        nativeName = values["nativeName"] as? String
    }
    
}
