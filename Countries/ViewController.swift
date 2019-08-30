//
//  ViewController.swift
//  Countries
//
//  Created by Arber Basha on 29/08/2019.
//  Copyright © 2019 Arber Basha. All rights reserved.
//

import UIKit
import iOSDropDown
import SVProgressHUD
import SDWebImage



class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UITextFieldDelegate {

    var countries = [Country]()
    var index = IndexPath(row: 0, section: 0)
    var blurEffectView: UIView!
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var dropDown: DropDown!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCustomBlur()
        createDropDown()
        registerTable()
        textSearchRounderCorner()
        fetchJSON()
        txtSearch.delegate = self

    }
    

    
    @IBAction func btnSearchPressed(_ sender: Any) {
        SVProgressHUD.show()
        let parameter = txtSearch.text ?? ""
        checkParameter(parameter: parameter)
        txtSearch.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.returnKeyType==UIReturnKeyType.go)
        {
            let parameter = txtSearch.text ?? ""
            checkParameter(parameter: parameter)
            txtSearch.resignFirstResponder()
        }
        return true
    }
    
    func createDropDown(){
        
        dropDown.optionArray = ["State", "City","ISO"]
        dropDown.selectedRowColor = UIColor.clear
        dropDown.isSearchEnable = false
        dropDown.text = "State"
        dropDown.selectedIndex = 0
        dropDown.didSelect{(selectedText , index ,id) in
            self.dropDown.text = "\(selectedText)"
        }
    }
    
    func registerTable(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: "countryCell")
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 5
    }
    
    func textSearchRounderCorner(){
        txtSearch.layer.masksToBounds = true
        txtSearch.layer.cornerRadius = 5
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! CountryCell
        
        let country = countries[indexPath.row]
        
        cell.lblName.text = country.name
        cell.lblCapital.text = country.capital
        cell.lblRegion.text = country.region
        let largeNumber = country.population
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber))
        cell.lblPopulation.text = formattedNumber
        cell.lblISO.text = country.alpha3Code
        cell.imgFlag.sd_setImage(with: URL(string: "https://www.countryflags.io/\(country.alpha2Code)/shiny/64.png"))
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsVC = storyBoard.instantiateViewController(withIdentifier: "detailVC") as! DetailsViewController
        SVProgressHUD.show()
        let country = countries[indexPath.row]
        detailsVC.parameter = country.alpha3Code
        self.present(detailsVC, animated: true, completion: nil)
        
    }
    
    
    fileprivate func fetchJSON(){
        SVProgressHUD.show()
        let urlString = "https://restcountries.eu/rest/v2/all"
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            DispatchQueue.main.async {
                if let error = error{
                    print("something failed", error)
                }
                
                guard let data = data else {return}
                
                do {
                    let decoder = JSONDecoder()
                    self.countries = try decoder.decode([Country].self, from: data)
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: self.index, at: .top, animated: true)
                    SVProgressHUD.dismiss()
                    self.blurEffectView.removeFromSuperview()
                }catch let jsonErr{
                    print("failder",jsonErr)
                }
            }
            }.resume()
    }
    
    fileprivate func fetchJSONwithParameterState(parameter: String){
        let urlString = "https://restcountries.eu/rest/v2/name/\(parameter)"
        
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            DispatchQueue.main.async {
                if let error = error{
                    print("something failed",error)
                }
                
                guard let data = data else {return}
                
                do{
                    let decoder = JSONDecoder()
                    self.countries = try decoder.decode([Country].self, from: data)
                    self.tableView.reloadData()
                     self.tableView.scrollToRow(at: self.index, at: .top, animated: true)
                    SVProgressHUD.dismiss()
                }catch let jsonErr{
                    self.showErrorWith(message: "State with that text doesn't exist")
                    print("failed",jsonErr)
                }
            }
        }.resume()
    }
    
    fileprivate func fetchJSONwithParameterCity(parameter: String){
        let urlString = "https://restcountries.eu/rest/v2/capital/\(parameter)"
        
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            DispatchQueue.main.async {
                if let error = error{
                    print("something failed",error)
                }
                
                guard let data = data else {return}
                
                do{
                    let decoder = JSONDecoder()
                    self.countries = try decoder.decode([Country].self, from: data)
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: self.index, at: .top, animated: true)
                    SVProgressHUD.dismiss()
                }catch let jsonErr{
                    self.showErrorWith(message: "City with that text doesn't exist")
                    print("failed",jsonErr)
                }
            }
            }.resume()
    }
    
    fileprivate func fetchJSONwithParameterISO(parameter: String){
        let urlString = "https://restcountries.eu/rest/v2/alpha?codes=\(parameter)"
        
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            DispatchQueue.main.async {
                if let error = error{
                    print("something failed",error)
                }
                
                guard let data = data else {return}
                
                do{
                    let decoder = JSONDecoder()
                    self.countries = try decoder.decode([Country].self, from: data)
                    self.tableView.reloadData()
                     self.tableView.scrollToRow(at: self.index, at: .top, animated: true)
                    SVProgressHUD.dismiss()
                }catch let jsonErr{
                    self.showErrorWith(message: "ISO with that text doesn't exist")
                    print("failed",jsonErr)
                }
            }
            }.resume()
    }
    
    
    func showErrorWith(message: String){
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
    
    func checkParameter(parameter: String){
        if txtSearch.text == "" {
            fetchJSON()
        }else{
            if dropDown.text == "State"{
                fetchJSONwithParameterState(parameter: parameter)
            }
            if dropDown.text == "City"{
                fetchJSONwithParameterCity(parameter: parameter)
            }
            if dropDown.text == "ISO"{
                fetchJSONwithParameterISO(parameter: parameter)
            }
        }
    }
    
    func createCustomBlur(){
        let blurEffect = UIBlurEffect(style: .regular) // .extraLight or .dark
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        view.addSubview(blurEffectView)
    }
    
}

