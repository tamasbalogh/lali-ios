//
//  ResultController.swift
//  lali
//
//  Created by Balogh Tamas on 2019. 03. 18..
//  Copyright © 2019. Balogh Tamas. All rights reserved.
//

import UIKit
import Charts

class ResultController: UIViewController {
    
    
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var correctAnswersLabel: UILabel!
    @IBOutlet weak var wrongAsnwersLabel: UILabel!
    
    
    
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
        let myAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 32) ]
        let centerText = NSAttributedString(string: "\(calculatePercentage()) %", attributes: myAttribute)
        pieChart.centerAttributedText = centerText
    }
    
    @IBAction func homeButtonPressed(_ sender: UIButton) {
        let main = storyBoard.instantiateViewController(withIdentifier: "main") as! MainController
        controller.navigationController?.pushViewController(main, animated: true)
    }
    
    @IBAction func newGameButtonPressed(_ sender: UIButton) {
        
    }
    
    
    private func calculatePercentage() -> Double{
        let correct = Double(Result.singleton.getCorrect())
        let wrong = Double(Result.singleton.getWrong())
        let max =  correct + wrong
        let result = correct * 100.0 / max
        return Double(round(10*result)/10)
    }
    
}
