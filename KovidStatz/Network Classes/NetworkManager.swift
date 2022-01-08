//
//  NetworkManager.swift
//  KovidStatz
//
//  Created by Shwait Kumar on 08/01/22.
//

import UIKit
import Foundation
import SwiftyJSON
import Alamofire
import SVProgressHUD

class NetworkManeger: NSObject {
    
    //Post Request Method
    class func postRequest(remainingUrl:String, parameters: [String:Any], isLoaderShow:Bool? = true, sendHeader : Bool , completion: @escaping ((_ data: JSON, _ responseData:Foundation.Data) -> Void)) {
        
        let completeUrl = BaseUrl.shared.baseUrl + remainingUrl
        print ("complete url : ", completeUrl)
        
        debugPrint("parameters - ",parameters)
        
        if isLoaderShow == true{
            SVProgressHUD.setForegroundColor(UIColor.black)
            SVProgressHUD.setBackgroundColor(UIColor.white)
            SVProgressHUD.show(withStatus: "Loading...")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
        }
        
        var authHeaders: HTTPHeaders?
        
        authHeaders = []
        
        if sendHeader == true
        {
            authHeaders = [
                "x-rapidapi-host": "covid-193.p.rapidapi.com",
                "x-rapidapi-key": "b1697b9d5dmsheedecc034fcc872p1b19dajsna543bed12b02",
            ]
        }
        else
        {
            authHeaders = [
                "x-rapidapi-host": "covid-193.p.rapidapi.com",
                "x-rapidapi-key": "b1697b9d5dmsheedecc034fcc872p1b19dajsna543bed12b02",
            ]
        }
        
        AF.request(completeUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: authHeaders).responseJSON { response in
            
            debugPrint("testing response - ",response)
            
            SVProgressHUD.dismiss()
            guard let data = response.data else { return }
            if(response.response?.statusCode == 200) {
                
                SVProgressHUD.dismiss()
                let swiftyJsonVar = JSON(response.value ?? "")
                
                if swiftyJsonVar[BaseUrl.shared.apiProjectName]["resCode"].stringValue == "500"
                {
                    NetworkManeger.clearAll()
                    //appDelegate.pushToLoginViewController()
                }
                else
                {
                    completion(swiftyJsonVar, data)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            else
            {
                print("No response")
                SVProgressHUD.showError(withStatus: "Unable to process request. Please try again.")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    
    class func getRequest (remainingUrl:String, isLoaderShow:Bool? = true , sendHeader:Bool? = false , completion: @escaping ((_ data: JSON, _ responseData:Foundation.Data) -> Void)) {
          
          let completeUrl = BaseUrl.shared.baseUrl + remainingUrl
          print ("complete url : ", completeUrl)
          
        if isLoaderShow == true{
            SVProgressHUD.setForegroundColor(UIColor.black)
            SVProgressHUD.setBackgroundColor(UIColor.white)
            SVProgressHUD.show(withStatus: "Loading...")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
        }
    
        var authHeaders: HTTPHeaders?
        
        if sendHeader == true
        {
            authHeaders = [
                "x-rapidapi-host": "covid-193.p.rapidapi.com",
                "x-rapidapi-key": "b1697b9d5dmsheedecc034fcc872p1b19dajsna543bed12b02",
            ]
        }
        else
        {
            authHeaders = [
                "x-rapidapi-host": "covid-193.p.rapidapi.com",
                "x-rapidapi-key": "b1697b9d5dmsheedecc034fcc872p1b19dajsna543bed12b02",
            ]
        }
        
        AF.request(completeUrl, method: .get, encoding: JSONEncoding.default, headers: authHeaders).responseJSON { response in
            
            debugPrint("testing response - ",response)
            
            SVProgressHUD.dismiss()
            guard let data = response.data else { return }
            if(response.response?.statusCode == 200) {
                
                SVProgressHUD.dismiss()
                let swiftyJsonVar = JSON(response.value ?? "")
                completion(swiftyJsonVar, data)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            else
            {
                print("No response")
                SVProgressHUD.showError(withStatus: "Unable to process request. Please try again.")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
          }
      }
    
    //////////////////////////
    class func get2Request (country:String, isLoaderShow:Bool? = true , sendHeader:Bool? = false , completion: @escaping ((_ data: JSON, _ responseData:Foundation.Data) -> Void)) {
          
          let completeUrl = "https://covid-193.p.rapidapi.com/history?country=\(country)&day=2022-01-08"
          print ("complete url : ", completeUrl)
          
        if isLoaderShow == true{
            SVProgressHUD.setForegroundColor(UIColor.black)
            SVProgressHUD.setBackgroundColor(UIColor.white)
            SVProgressHUD.show(withStatus: "Loading...")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
        }
    
        var authHeaders: HTTPHeaders?
        
        if sendHeader == true
        {
            authHeaders = [
                "x-rapidapi-host": "covid-193.p.rapidapi.com",
                "x-rapidapi-key": "b1697b9d5dmsheedecc034fcc872p1b19dajsna543bed12b02",
            ]
        }
        else
        {
            authHeaders = [
                "x-rapidapi-host": "covid-193.p.rapidapi.com",
                "x-rapidapi-key": "b1697b9d5dmsheedecc034fcc872p1b19dajsna543bed12b02",
            ]
        }
        
        AF.request(completeUrl, method: .get, encoding: JSONEncoding.default, headers: authHeaders).responseJSON { response in
            
            debugPrint("testing response - ",response)
            
            SVProgressHUD.dismiss()
            guard let data = response.data else { return }
            if(response.response?.statusCode == 200) {
                
                SVProgressHUD.dismiss()
                let swiftyJsonVar = JSON(response.value ?? "")
                completion(swiftyJsonVar, data)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            else
            {
                print("No response")
                SVProgressHUD.showError(withStatus: "Unable to process request. Please try again.")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
          }
      }
    
    func showLoader()  {
        SVProgressHUD.setForegroundColor(UIColor.black)
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.show(withStatus: "Loading...")
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
    }
    
    func hideLoader()  {
        SVProgressHUD.dismiss()
    }
    
    class func isConnectedToNetwork() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    class func setUserDefault(value: String,key : String){
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getUserDefault(key: String) -> String{
        if let result = UserDefaults.standard.value(forKey: key) {
            return result as! String
        }else{
            return ""
        }
    }
    
    class func getCurrentTime() -> String {
        let currentTime = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let timeInFormat = dateFormatter.string(from: currentTime as Date)
        return timeInFormat
    }
    
    
    class func clearAll()
    {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
    }
}
