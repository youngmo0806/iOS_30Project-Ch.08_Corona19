//
//  ViewController.swift
//  iOS_30Project-Ch.08_Corona19
//
//  Created by youngmo on 2021/12/22.
//

import UIKit
import Alamofire
import Charts

//corona19
//굿바이 코로나 api key - youngmo0806@naver.com
//vbFCr78JXWDn1p2eumB6wQTUNG9diIaoP
//1._국내 카운터 요청 주소
//https://api.corona-19.kr/korea/?serviceKey=vbFCr78JXWDn1p2eumB6wQTUNG9diIaoP
//2._시도별 발생동향 요청 주소
//https://api.corona-19.kr/korea/country/new/?serviceKey=vbFCr78JXWDn1p2eumB6wQTUNG9diIaoP



class ViewController: UIViewController {
    @IBOutlet weak var totalCaseLabel: UILabel!
    @IBOutlet weak var newCaseLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var indicaterView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.indicaterView.startAnimating()
        
        
        self.fetchCovidOverview(completionHandler: { [weak self] result in
            guard let self = self else { return }
            
            self.indicaterView.stopAnimating()
            self.indicaterView.isHidden = true
            
            self.labelStackView.isHidden = false
            self.pieChartView.isHidden = false
            
            switch result {
            case let .success(result):
                self.configureStackView(koreaCovidOverview: result.korea)
                let covidOverviewList = self.makeCovidOverviewList(cityCovidOverview: result)
                self.configureChatView(covidOverviewList: covidOverviewList)
                
                debugPrint("success: \(result)")

            case let .failure(error):
                debugPrint("failure: \(error)")
            }
        })
    }
    
    
    func configureStackView(koreaCovidOverview: CovidOverview) {
    
        self.totalCaseLabel.text = "\(koreaCovidOverview.totalCase)명"
        self.newCaseLabel.text = "\(koreaCovidOverview.newCase)명"
        
    }
    
    //request
    func fetchCovidOverview(completionHandler: @escaping (Result<CityCovidoverview, Error>) -> Void) {
        
        let url = "https://api.corona-19.kr/korea/country/new/"
        let param = [
            "serviceKey" : "vbFCr78JXWDn1p2eumB6wQTUNG9diIaoP"
        ]
            
        print("url : \(url)")
        
        AF.request(url, method: .get, parameters: param).responseData(completionHandler: { response in
            switch response.result{
                
                case let .success(data):
                    
                    do{
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CityCovidoverview.self, from: data)
                        completionHandler(.success(result))
                    } catch {
                        completionHandler(.failure(error))
                    }
                
                case let .failure(error):
                
                    completionHandler(.failure(error))
                
            }
        })
     
    }
    
    
    func makeCovidOverviewList(cityCovidOverview: CityCovidoverview) -> [CovidOverview] {
        return [cityCovidOverview.seoul
                ,cityCovidOverview.busan
                ,cityCovidOverview.daegu
                ,cityCovidOverview.incheon
                ,cityCovidOverview.gwangju
                ,cityCovidOverview.daejeon
                ,cityCovidOverview.ulsan
                ,cityCovidOverview.sejong
                ,cityCovidOverview.gyeonggi
                ,cityCovidOverview.chungbuk
                ,cityCovidOverview.chungnam
                ,cityCovidOverview.gyeongbuk
                ,cityCovidOverview.gyeongnam
                ,cityCovidOverview.jeju]
        
    }
    
    //pieChart에 데이터 추가
    func configureChatView(covidOverviewList: [CovidOverview]) {
        
        self.pieChartView.delegate = self
        
        let entries = covidOverviewList.compactMap { [weak self] overview -> PieChartDataEntry? in
            guard let self = self else { return nil}
            
            return PieChartDataEntry(
                value: self.removeFormatString(string: overview.newCase),
                label: overview.countryName,
                data: overview
            )
        }
        
        let dataSet = PieChartDataSet(entries: entries, label: "코로나 발생 현황")
        dataSet.sliceSpace = 1
        dataSet.entryLabelColor = .black
        dataSet.valueTextColor = .black
        dataSet.xValuePosition = .outsideSlice
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.3
        
        
        dataSet.colors = ChartColorTemplates.vordiplom() +
                            ChartColorTemplates.joyful() +
                            ChartColorTemplates.liberty()+ChartColorTemplates.pastel() +
                            ChartColorTemplates.material()
        
        self.pieChartView.data = PieChartData(dataSet: dataSet)
        self.pieChartView.spin(duration: 0.3, fromAngle: self.pieChartView.rotationAngle, toAngle: self.pieChartView.rotationAngle * 80)
        
    }
    
    
    //string을 double로 변형
    func removeFormatString(string: String) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        return formatter.number(from: string)?.doubleValue ?? 0
    }
}

extension ViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let covidDetailViewController = self.storyboard?.instantiateViewController(identifier: "CovidDetailViewController") as? CovidDetailViewController else { return }
        
        guard let covidOverview = entry.data as? CovidOverview else { return }
        
        //데이터를 넣어주고
        covidDetailViewController.covidOverview = covidOverview
        //화면 이동
        self.navigationController?.pushViewController(covidDetailViewController, animated: true)
    }
}
