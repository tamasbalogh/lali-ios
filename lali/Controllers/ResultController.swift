//
//  ResultController.swift
//  lali
//
//  Created by Balogh Tamas on 2019. 03. 18..
//  Copyright © 2019. Balogh Tamas. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import SwiftyJSON

class ResultController: UIViewController {
    
    
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var correctAnswersLabel: UILabel!
    @IBOutlet weak var wrongAsnwersLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    var correctDataEntry = PieChartDataEntry(value: Double(Result.singleton.getCorrect()))
    var wrongDataEntry = PieChartDataEntry(value: Double(Result.singleton.getWrong()))
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private var controller = UIViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp(){
        controller = self
        navigationItem.setHidesBackButton(true, animated:true);
        
        customizeChart()
        
        correctAnswersLabel.layer.masksToBounds = true
        correctAnswersLabel.layer.cornerRadius = 10
        wrongAsnwersLabel.layer.masksToBounds = true
        wrongAsnwersLabel.layer.cornerRadius = 10
        
        correctAnswersLabel.text = "correctanswers".localizableString(lang: Utils.getLanguage()) + " - \(Result.singleton.getCorrect())"
        wrongAsnwersLabel.text = "wronganswers".localizableString(lang: Utils.getLanguage()) + " - \(Result.singleton.getWrong())"
        
    }
    
    private func customizeChart(){
        pieChart.chartDescription?.text = ""
        
        let chartDataSet = PieChartDataSet(entries: [wrongDataEntry,correctDataEntry], label: nil)
        chartDataSet.drawValuesEnabled = false
        let chartData = PieChartData(dataSet: chartDataSet)
        chartDataSet.colors = [Colors.colorButton,Colors.colorButtonBrighter]
        pieChart.data = chartData
        pieChart.animate(yAxisDuration: 2)
        pieChart.chartDescription?.enabled = false
        pieChart.drawEntryLabelsEnabled = false
        pieChart.legend.enabled = false
        pieChart.drawCenterTextEnabled = true
        
        let myAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18) ]
        let centerText = NSAttributedString(string: "\(calculatePercentage()) %", attributes: myAttribute)
        pieChart.centerAttributedText = centerText
    }
    
    @IBAction func homeButtonPressed(_ sender: UIButton) {
        openHome()
    }
    
    @IBAction func newGameButtonPressed(_ sender: UIButton) {
        Result.singleton.reInit()
        
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        if(Utils.GAMETYPE == Utils.MIXED){
            Alamofire.request("http://imhotep.nyme.hu:9443/ArtApp/mix", method: .post, parameters: ["auth": "yTd0Eq6YzDDVQZBL","language": Utils.getLanguage()]).responseJSON { response in
                response.result.ifSuccess {
                    let games = JSON(response.result.value!)
                    let list: Array<JSON> = games["games"].arrayValue
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if(list.count > 0){
                        Utils.GAMETYPE = Utils.MIXED
                        Utils.showGame(games: list, viewController:  self)
                    } else {
                        let alert = UIAlertController(title: "", message: "empty_regular_game".localizableString(lang: Utils.getLanguage()), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in self.openHome()}))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                response.result.ifFailure {
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    let alert = UIAlertController(title: "", message: "server".localizableString(lang: Utils.getLanguage()), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in self.openHome()}))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        if(Utils.GAMETYPE == Utils.REGULAR){
            let regular = storyBoard.instantiateViewController(withIdentifier: "regular") as! RegularGameController
            controller.navigationController?.pushViewController(regular, animated: true)
        }
    }
    
    private func openHome(){
        let main = storyBoard.instantiateViewController(withIdentifier: "main") as! MainController
        controller.navigationController?.pushViewController(main, animated: true)
    }
    
    
    private func calculatePercentage() -> Double{
        let correct = Double(Result.singleton.getCorrect())
        let wrong = Double(Result.singleton.getWrong())
        let max =  correct + wrong
        let result = correct * 100.0 / max
        return Double(round(10*result)/10)
    }
    
}
