//
//  Currency.swift
//  Wafer-mobile-messenger
//
//  Created by Thomás Marques Brandão Reis on 24/08/2018.
//  Copyright © 2018 Thomás Marques Brandão Reis. All rights reserved.
//

import UIKit

/**
 Currency model.
 **/
class Currency {
    
    var code: String?
    var name: String?
    var simbol: String?
    
    // Initializes a model of Currency with its respective properties if possible.
    init?(data: Any) {
        guard let values = data as? [String: Any] else { return }
        code = values["code"] as? String
        name = values["name"] as? String
        simbol = values["simbol"] as? String
    }
    
}
