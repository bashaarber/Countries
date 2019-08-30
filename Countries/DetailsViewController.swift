//
//  DetailsViewController.swift
//  Countries
//
//  Created by Arber Basha on 30/08/2019.
//  Copyright © 2019 Arber Basha. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class DetailsViewController: UIViewController {
    
    var parameter: String = ""
    
    var countries = [Country]()
    var country: Country!
    var blurEffectView: UIView!
    
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNativeName: UILabel!
    @IBOutlet weak var lblCapital: UILabel!
    @IBOutlet weak var lblDemonym: UILabel!
    @IBOutlet weak var lblRegion: UILabel!
    @IBOutlet weak var lblCallingCode: UILabel!
    @IBOutlet weak var lblTimeZone: UILabel!
    @IBOutlet weak var lblISO2: UILabel!
    @IBOutlet weak var lblISO3: UILabel!
    @IBOutlet weak var lblPopulation: UILabel!
    @IBOutlet weak var lblBorders: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCustomBlur()
        fetchJSONwithParameterISO(parameter: parameter)
        
    }

    
    @IBAction func btnBackPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
                    self.country = self.countries[0]
                    self.imgFlag.sd_setImage(with: URL(string: "https://www.countryflags.io/\(self.country.alpha2Code)/shiny/64.png"))
                    self.lblName.text = self.country.name
                    self.lblNativeName.text = self.country.nativeName
                    self.lblCapital.text = self.country.capital
                    self.lblDemonym.text = self.country.demonym
                    self.lblRegion.text = self.country.region
                    self.lblCallingCode.text = self.country.callingCodes.joined()
                    self.lblTimeZone.text = self.country.timezones[0]
                    self.lblISO2.text = self.country.alpha2Code
                    self.lblISO3.text = self.country.alpha3Code
                    let largeNumber = self.country.population
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber))
                    self.lblPopulation.text = formattedNumber
                    self.lblBorders.text = self.country.borders.joined(separator: "-")
                    SVProgressHUD.dismiss()
                    self.blurEffectView.removeFromSuperview()
                }catch let jsonErr{
                    print("failed",jsonErr)
                }
            }
            }.resume()
    }
    
    func createCustomBlur(){
        let blurEffect = UIBlurEffect(style: .regular) // .extraLight or .dark
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        view.addSubview(blurEffectView)
    }

}
