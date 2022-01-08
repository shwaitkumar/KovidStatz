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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        scrollView.contentInsetAdjustmentBehavior = .never
        
        navigationController?.navigationBar.isHidden = true
        
        setViewShadow(view: viewTitle)
        setViewShadow(view: viewCases)
        setViewShadow(view: viewDeaths)
        
        viewTblShadow.layer.shadowRadius = 3
        viewTblShadow.layer.shadowOffset = .zero
        viewTblShadow.layer.shadowOpacity = 0.33
        viewTblShadow.layer.shadowColor = UIColor.black.cgColor
        
        self.tblCountries?.delegate = self
        self.tblCountries?.dataSource = self
        
        getCountriesList()
        
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
    
//                debugPrint("response - ",response)
//                debugPrint("data - ",data)
                
                self.countriesData = response["response"]
                print("Count is \(self.countriesData.count)")
                self.tblCountries.reloadData()

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
