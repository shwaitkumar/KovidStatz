//
//  BaseUrl.swift
//  KovidStatz
//
//  Created by Shwait Kumar on 08/01/22.
//

import Foundation
import UIKit

class BaseUrl: NSObject {
    
    static let shared = BaseUrl()
    let baseUrl = "https://covid-193.p.rapidapi.com/"
    
    let projectName = "KovidStatz"
    let apiProjectName = "kovidStatz"
    
}

enum ApiEndPoint: CustomStringConvertible {
    
    case countries
    case statistics
    
    var description : String {
        switch self
        {
        case .countries : return "countries"
        case .statistics : return "statistics"
        }
    }
}
