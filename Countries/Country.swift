//
//  Country.swift
//  Countries
//
//  Created by Arber Basha on 30/08/2019.
//  Copyright © 2019 Arber Basha. All rights reserved.
//

import UIKit

class Country: NSObject , Decodable {

    var name: String = ""
    var alpha2Code: String = ""
    var alpha3Code: String = ""
    var callingCodes: [String] = []
    var demonym: String = ""
    var capital: String = ""
    var timezones: [String] = []
    var region: String = ""
    var borders: [String] = []
    var nativeName: String = ""
    var population: Int = 0

    
}

