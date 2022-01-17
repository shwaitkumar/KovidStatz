//
//  CountrywiseCovidDetailsViewController.swift
//  KovidStatz
//
//  Created by Shwait Kumar on 08/01/22.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class CountrywiseCovidDetailsViewController: UIViewController {

    @IBOutlet weak var tblCountryData: UITableView!
    
    var country = ""
    var responseData : JSON = []
    var responseData0Index : JSON = []
    var casesData : JSON = []
    var deathData : JSON = []
    var testsData : JSON = []
    var population = ""
    var continent = ""
    var currentDate = ""

    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tblCountryData?.delegate = self
        self.tblCountryData?.dataSource = self
        
        getCovidDataForToday(country: country)
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tblCountryData.addSubview(refreshControl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor(named: "Dark Blue")
    }
    
    @objc func refresh(_ sender: AnyObject) {
        
       // Code to refresh table view
        getCovidDataForToday(country: country)
        
        refreshControl.endRefreshing()
        tblCountryData.reloadData()
    }
    
    //MARK: getCovidDataForToday HIT
    func getCovidDataForToday(country : String) {
        
        if NetworkManeger.isConnectedToNetwork(){
            
            NetworkManeger.get2Request(country: country, day: currentDate, isLoaderShow: true, sendHeader: true) { (response,data)  in
                
                debugPrint("response - ",response)
                debugPrint("data - ",data)
                
                self.responseData = response["response"] //All data
                self.responseData0Index = self.responseData[0] //data at 0 index
                //Cases Data
                self.casesData = self.responseData0Index["cases"] //cases data json at 0th index
                //Death Data
                self.deathData = self.responseData0Index["deaths"] //death data json at 0th index
                self.testsData = self.responseData0Index["tests"] //tests data json at 0th index
                self.population = self.responseData0Index["population"].stringValue
                self.continent = self.responseData0Index["continent"].stringValue
                self.tblCountryData.reloadData()
                
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

extension CountrywiseCovidDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountrywiseCovidDetailsTableViewCell", for: indexPath) as! CountrywiseCovidDetailsTableViewCell
        
        let casesInfo = casesData[]
        let deathInfo = deathData[]
        let testsInfo = testsData[]
        
        cell.lblCountryName.text = country
        cell.lblContinent.text = continent
        cell.lblPopulation.text = population
        
        if casesInfo["total"].stringValue != "" {
            cell.lblTotalCases.text = casesInfo["total"].stringValue
        }
        else {
            cell.lblTotalCases.text = "0"
        }
        
        if casesInfo["active"].stringValue != "" {
            cell.lblActiveCases.text = casesInfo["active"].stringValue
        }
        else {
            cell.lblActiveCases.text = "0"
        }
      
        if casesInfo["new"].stringValue != "" {
            cell.lblNewCases.text = casesInfo["new"].stringValue
        }
        else {
            cell.lblNewCases.text = "0"
        }
        
        if casesInfo["critical"].stringValue != "" {
            cell.lblCriticalCases.text = casesInfo["critical"].stringValue
        }
        else {
            cell.lblCriticalCases.text = "0"
        }
        
        if casesInfo["recovered"].stringValue != "" {
            cell.lblRecovered.text = casesInfo["recovered"].stringValue
        }
        else {
            cell.lblRecovered.text = "0"
        }
        
        if deathInfo["total"].stringValue != "" {
            cell.lblTotalDeaths.text = deathInfo["total"].stringValue
        }
        else {
            cell.lblTotalDeaths.text = "0"
        }
        
        if deathInfo["new"].stringValue != "" {
            cell.lblNewDeaths.text = deathInfo["new"].stringValue
        }
        else {
            cell.lblNewDeaths.text = "0"
        }
        
        if testsInfo["total"].stringValue != "" {
            cell.lblTotalTests.text = testsInfo["total"].stringValue
        }
        else {
            cell.lblTotalTests.text = "0"
        }
        
        return cell
        
    }
    
}

class CountrywiseCovidDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewTotalCasesTitle: UIView!
    @IBOutlet weak var viewTotalCasesData: UIView!
    @IBOutlet weak var viewTotalDeathsTitle: UIView!
    @IBOutlet weak var viewTotalDeathsData: UIView!
    @IBOutlet weak var viewTests: UIView!
    
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var lblContinent: UILabel!
    @IBOutlet weak var lblPopulation: UILabel!
    @IBOutlet weak var lblTotalCases: UILabel!
    @IBOutlet weak var lblActiveCases: UILabel!
    @IBOutlet weak var lblCriticalCases: UILabel!
    @IBOutlet weak var lblNewCases: UILabel!
    @IBOutlet weak var lblRecovered: UILabel!
    @IBOutlet weak var lblTotalDeaths: UILabel!
    @IBOutlet weak var lblNewDeaths: UILabel!
    @IBOutlet weak var lblTotalTests: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        setViewShadow(view: viewTotalCasesTitle)
        setViewShadow(view: viewTotalCasesData)
        setViewShadow(view: viewTotalDeathsTitle)
        setViewShadow(view: viewTotalDeathsData)
        setViewShadow(view: viewTests)
        
    }
    
    func setViewShadow(view : UIView) {
        view.layer.shadowRadius = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowOpacity = 0.33
        view.layer.shadowColor = UIColor.black.cgColor
    }
    
}
