//
//  CobidDetailViewController.swift
//  iOS_30Project-Ch.08_Corona19
//
//  Created by youngmo on 2021/12/22.
//

import UIKit

//"korea": {
//     "countryName": "합계",
//     "newCase": "90,443",         신규 확진자
//     "totalCase": "1,552,851",    확진자
//     "recovered": "825,776",      완치자
//     "death": "7,202",            사망자
//     "percentage": "3007",        발생률
//     "newCcase": "90,281",        해외유입 신규 확진자
//     "newFcase": "162"            지역발생 신규 확진자
// },

class CovidDetailViewController: UITableViewController {

    @IBOutlet weak var newCaseCell: UITableViewCell!            //신규확진자
    @IBOutlet weak var totalCaseCell: UITableViewCell!          //확진자
    @IBOutlet weak var recoveredCell: UITableViewCell!          //완치자
    @IBOutlet weak var deathCell: UITableViewCell!              //사망자
    @IBOutlet weak var percentageCell: UITableViewCell!         //발생율
    @IBOutlet weak var overseasInflowCell: UITableViewCell!     //해외유입 신규 확진자
    @IBOutlet weak var regionalOutbreakCell: UITableViewCell!   //지역발생 신규 확진자

    var covidOverview: CovidOverview?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureView()
    }
    
    func configureView() {
        guard let covidOverview = self.covidOverview else {
            return
        }
        
        self.title = covidOverview.countryName
        self.newCaseCell.detailTextLabel?.text = "\(covidOverview.newCase)명"
        self.totalCaseCell.detailTextLabel?.text = "\(covidOverview.totalCase)명"
        self.recoveredCell.detailTextLabel?.text = "\(covidOverview.recovered)명"
        self.deathCell.detailTextLabel?.text = "\(covidOverview.death)명"
        self.percentageCell.detailTextLabel?.text =  "\(covidOverview.percentage)%"
        self.overseasInflowCell.detailTextLabel?.text = "\(covidOverview.newCcase)명"
        self.regionalOutbreakCell.detailTextLabel?.text = "\(covidOverview.newFcase)명"
    }
}
