//
//  GameType2Controller.swift
//  lali
//
//  Created by Balogh Tamas on 2019. 03. 31..
//  Copyright © 2019. Balogh Tamas. All rights reserved.
//

import UIKit
import SwiftyJSON

class GameType2Controller: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var numberTableView: UITableView!
    @IBOutlet weak var answerTableView: UITableView!
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private var controller = UIViewController()
    
    var globalGames: Array<JSON> = [JSON()]
    var image: String = ""
    
    var answersDefault: [String] = []
    private var answers: [String] = []
    var numbers: [String] = []
    
    var isNumberSelected = false
    var isAnswerSelected = false
    
    var selectedNumberRow = -1
    var selectedAnswerRow = -1
    
    var answersDictionary = Dictionary<String, String>()
    var createdDictionary = Dictionary<String, String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp(){
        
        controller = self
        navigationItem.setHidesBackButton(true, animated:true);
        navigationItem.title = ""
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "information"), style: .plain, target: self, action: #selector(informationButtonPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeButtonPressed))
        navigationController!.navigationBar.tintColor = Colors.colorButton
        
        //Decode base64 string and set the image
        let imageData = Data(base64Encoded: image, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        imageView.image = UIImage(data: imageData)
        
        //Save the correct answers
        for (index, answer) in answersDefault.enumerated(){
            let key = index + 1
            answersDictionary.updateValue(answer, forKey: String(key))
        }
        
        //Suffle arrays
        answers = Utils.shuffleArray(array: answersDefault)
        
        for i in 0..<answers.count {
            let key = i + 1
            numbers.append(String(key))
        }
        numberTableView.dataSource = self
        numberTableView.delegate = self
        
        answerTableView.dataSource = self
        answerTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?
        if tableView == self.numberTableView {
            count = numbers.count
        }
        if tableView == self.answerTableView {
            count =  answers.count
        }
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        if tableView == self.numberTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "numberCell", for: indexPath)
            let number = numbers[indexPath.row]
            cell!.textLabel!.text = String(number)
        }
        if tableView == self.answerTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath)
            let answer = answers[indexPath.row]
            cell!.textLabel!.text = answer
        }
        cell!.textLabel!.font = .boldSystemFont(ofSize: 14)
        cell!.textLabel!.lineBreakMode = .byWordWrapping
        cell!.textLabel!.numberOfLines = 0
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == numberTableView){
            isNumberSelected = true
            selectedNumberRow = indexPath.row
            if(isAnswerSelected){
                createdDictionary.updateValue(answers.remove(at: selectedAnswerRow), forKey: numbers.remove(at: selectedNumberRow))
                isNumberSelected = false
                isAnswerSelected = false
                numberTableView.reloadData()
                answerTableView.reloadData()
                if(numbers.count == 0 && answers.count == 0){
                    checkAnswers()
                }
            }
        }
        
        if(tableView == answerTableView){
            isAnswerSelected = true
            selectedAnswerRow = indexPath.row
            if(isNumberSelected){
                createdDictionary.updateValue(answers.remove(at: selectedAnswerRow), forKey: numbers.remove(at: selectedNumberRow))
                isNumberSelected = false
                isAnswerSelected = false
                numberTableView.reloadData()
                answerTableView.reloadData()
                if(numbers.count == 0 && answers.count == 0){
                    checkAnswers()
                }
            }
        }
    }
    
    private func checkAnswers(){
        var coloredAnswers = Dictionary<String, UIColor>()
        for key in createdDictionary.keys.sorted() {
            numbers.append(key)
            answers.append(answersDictionary[key]!)
            if(createdDictionary[key] == answersDictionary[key]){
                coloredAnswers.updateValue(UIColor.green, forKey: key)
                Result.singleton.addCorrectPoint(point: 1)
            } else {
                coloredAnswers.updateValue(UIColor.red, forKey: key)
                Result.singleton.addWrongPoint(point: 1)
            }
        }
        
        numberTableView.reloadData()
        answerTableView.reloadData()
        
        for i in 0..<numbers.count{
            let key = numbers[i]
            let numberCell = numberTableView.cellForRow(at: IndexPath(row: i, section: 0))
            let answerCell = answerTableView.cellForRow(at: IndexPath(row: i, section: 0))
            numberCell!.backgroundColor = coloredAnswers[key]
            answerCell!.backgroundColor = coloredAnswers[key]
        }
        
        
        numberTableView.delegate = nil
        numberTableView.allowsSelection = false
        answerTableView.delegate = nil
        answerTableView.allowsSelection = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "next"), style: .plain, target: self, action: #selector(nextButtonPressed))
        navigationController!.navigationBar.tintColor = Colors.colorButton
    }
    
    @objc func nextButtonPressed() {
        var tmp = globalGames
        tmp.removeFirst()
        Utils.showGame(games: tmp, viewController: self)
    }
    
    @objc func homeButtonPressed() {
        let main = storyBoard.instantiateViewController(withIdentifier: "main") as! MainController
        controller.navigationController?.pushViewController(main, animated: true)
    }
    
    @objc func informationButtonPressed() {
        let alert = UIAlertController(title: "Information", message: "gametype2".localizableString(lang: Utils.getLanguage()), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
