//
//  ViewController.swift
//  KovidStatz
//
//  Created by Shwait Kumar on 08/01/22.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var viewCases: UIView!
    @IBOutlet weak var viewDeaths: UIView!
    @IBOutlet weak var viewTblShadow: UIView!
    
    @IBOutlet weak var lblActiveCases: UILabel!
    @IBOutlet weak var lblCriticalCases: UILabel!
    @IBOutlet weak var lblNewCases: UILabel!
    @IBOutlet weak var lblRecoveredCases: UILabel!
    @IBOutlet weak var lblTotalCases: UILabel!
    @IBOutlet weak var lblNewDeaths: UILabel!
    @IBOutlet weak var lblTotalDeaths: UILabel!
    
    @IBOutlet weak var tblCountries: UITableView!
    
    var countriesData : JSON = []
    var responseData : JSON = []
    var responseData0Index : JSON = []
    var casesData : JSON = []
    var deathData : JSON = []
    var country = ""
    
    let formatter : DateFormatter = DateFormatter()
    var currentDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        scrollView.contentInsetAdjustmentBehavior = .never
        
        setViewShadow(view: viewTitle)
        setViewShadow(view: viewCases)
        setViewShadow(view: viewDeaths)
        
        viewTblShadow.layer.shadowRadius = 3
        viewTblShadow.layer.shadowOffset = .zero
        viewTblShadow.layer.shadowOpacity = 0.33
        viewTblShadow.layer.shadowColor = UIColor.black.cgColor
        
        self.tblCountries?.delegate = self
        self.tblCountries?.dataSource = self

        formatter.dateFormat = "yyyy-MM-dd"
        currentDate = formatter.string(from: NSDate.init(timeIntervalSinceNow: 0) as Date)
        
        getCovidDataForToday(country: "All") //country = All for World
        getCountriesList()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    func setViewShadow(view : UIView) {
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowOpacity = 0.33
        view.layer.shadowColor = UIColor.black.cgColor
    }
    
    //MARK: getCountriesList HIT
    func getCountriesList() {
        
        if NetworkManeger.isConnectedToNetwork(){
            
            NetworkManeger.getRequest(remainingUrl: ApiEndPoint.countries.description, isLoaderShow: true,sendHeader: true) { (response,data)  in
                
                self.countriesData = response["response"]
                self.tblCountries.reloadData()

            }
        }else{
            self.showAlert(Message:  "Network Error")
        }
    }
    
    //MARK: getCovidDataForToday HIT
    func getCovidDataForToday(country : String) {
        
        if NetworkManeger.isConnectedToNetwork(){
            
            NetworkManeger.get2Request(country: country, day: currentDate, isLoaderShow: true, sendHeader: true) { (response,data)  in
                
                if response["response"] != [] {
                    
                    debugPrint("response - ",response)
                    debugPrint("data - ",data)
                    
                    self.responseData = response["response"] //All data
                    self.responseData0Index = self.responseData[0] //data at 0 index
                    
                    //Cases Data
                    self.casesData = self.responseData0Index["cases"] //cases data json at 0th index
                    
                    if self.casesData["active"].stringValue != "" {
                        self.lblActiveCases.text = self.casesData["active"].stringValue
                    }
                    else {
                        self.lblActiveCases.text = "0"
                    }
                    
                    if self.casesData["critical"].stringValue != "" {
                        self.lblCriticalCases.text = self.casesData["critical"].stringValue
                    }
                    else {
                        self.lblCriticalCases.text = "0"
                    }
                    
                    if self.casesData["new"].stringValue != "" {
                        self.lblNewCases.text = self.casesData["new"].stringValue
                    }
                    else {
                        self.lblNewCases.text = "0"
                    }
                    
                    if self.casesData["recovered"].stringValue != "" {
                        self.lblRecoveredCases.text = self.casesData["recovered"].stringValue
                    }
                    else {
                        self.lblRecoveredCases.text = "0"
                    }
                 
                    if self.casesData["total"].stringValue != "" {
                        self.lblTotalCases.text = self.casesData["total"].stringValue
                    }
                    else {
                        self.lblTotalCases.text = "0"
                    }
                    
                    //Death Data
                    self.deathData = self.responseData0Index["deaths"] //death data json at 0th index
                    
                    if self.deathData["new"].stringValue != "" {
                        self.lblNewDeaths.text = self.deathData["new"].stringValue
                    }
                    else {
                        self.lblNewDeaths.text = "0"
                    }
                    
                    if self.deathData["total"].stringValue != "" {
                        self.lblTotalDeaths.text = self.deathData["total"].stringValue
                    }
                    else {
                        self.lblTotalDeaths.text = "0"
                    }
                    
                }
                else {
                    
                    self.formatter.dateFormat = "yyyy-MM-dd"
                    self.currentDate = self.formatter.string(from: NSDate.distantPast.dayBefore as Date)
                    self.getCovidDataForToday(country: "All")
                    
                }
                
            }
        }else{
            self.showAlert(Message:  "Network Error")
        }
    }
    
    func showAlert(Message:String){
    
        let alert = UIAlertController (title: BaseUrl.shared.projectName, message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{ (alertOKAction) in }))
        self.present(alert, animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }

}

extension HomeScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountriesTableViewCell", for: indexPath) as! CountriesTableViewCell
        
        let data = countriesData[indexPath.row]
        
        cell.lblCountryName.text = data.stringValue
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let data = countriesData[indexPath.row]
        
        country = data.stringValue
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "CountrywiseCovidDetailsViewController") as! CountrywiseCovidDetailsViewController
        vc.country = country
        vc.currentDate = currentDate
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

class CountriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblCountryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
    
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: NSDate.init(timeIntervalSinceNow: 0) as Date)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
