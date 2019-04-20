//
//  GameType1Controller.swift
//  lali
//
//  Created by Balogh Tamas on 2019. 03. 31..
//  Copyright © 2019. Balogh Tamas. All rights reserved.
//

import UIKit
import SwiftyJSON

class GameType1Controller: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var colorTableView: UITableView!
    @IBOutlet weak var definitionTableView: UITableView!
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private var controller = UIViewController()
    
    var globalGames: Array<JSON> = [JSON()]
    private var colors: [String] = []
    private var definitions: [String] = []
    
    var colorsDefault: [String] = []
    var definitionsDefault: [String] = []
    
    var isColorSelected = false
    var isDefinitionSelected = false
    
    var selectedColorRow = -1
    var selectedDefinitionRow = -1
    
    var answersDictionary = Dictionary<String, String>()
    var createdDictionary = Dictionary<String, String>()
    
    var coloredAnswers = Dictionary<String, UIColor>()
    var answered = false
    
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
        
        colors = Utils.shuffleArray(array: colorsDefault)
        definitions = Utils.shuffleArray(array: definitionsDefault)
        
        //Save the correct answers
        if(colorsDefault.count == definitionsDefault.count){
            for i in 0..<colorsDefault.count{
                answersDictionary.updateValue(definitionsDefault[i], forKey: colorsDefault[i])
            }
        }
        
        colorTableView.dataSource = self
        colorTableView.delegate = self
        
        definitionTableView.dataSource = self
        definitionTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?
        if tableView == self.colorTableView {
            count = colors.count
        }
        if tableView == self.definitionTableView {
            count =  definitions.count
        }
        return count!
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        if tableView == self.colorTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "colorCell", for: indexPath)
            let color = colors[indexPath.row]
            cell!.textLabel!.text = color
        }
        if tableView == self.definitionTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "definitionCell", for: indexPath)
            let definition = definitions[indexPath.row]
            cell!.textLabel!.text = definition
        }
        
        if(answered){
            cell!.backgroundColor = coloredAnswers[colors[indexPath.row]]
        }
        
        cell!.textLabel!.font = .boldSystemFont(ofSize: 14)
        cell!.textLabel!.lineBreakMode = .byWordWrapping
        cell!.textLabel!.numberOfLines = 0
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == colorTableView){
            isColorSelected = true
            selectedColorRow = indexPath.row
            if(isDefinitionSelected){
                createdDictionary.updateValue(definitions.remove(at: selectedDefinitionRow), forKey: colors.remove(at: selectedColorRow))
                isColorSelected = false
                isDefinitionSelected = false
                colorTableView.reloadData()
                definitionTableView.reloadData()
                if(colors.count == 0 && definitions.count == 0){
                    checkAnswers()
                }
            }
        }
        
        if(tableView == definitionTableView){
            isDefinitionSelected = true
            selectedDefinitionRow = indexPath.row
            if(isColorSelected){
                createdDictionary.updateValue(definitions.remove(at: selectedDefinitionRow), forKey: colors.remove(at: selectedColorRow))
                isColorSelected = false
                isDefinitionSelected = false
                colorTableView.reloadData()
                definitionTableView.reloadData()
                if(colors.count == 0 && definitions.count == 0){
                    checkAnswers()
                }
            }
        }
    }
    
    private func checkAnswers(){
        
        answered = true
        
        for key in createdDictionary.keys {
            colors.append(key)
            definitions.append(answersDictionary[key]!)
            if(createdDictionary[key] == answersDictionary[key]){
                coloredAnswers.updateValue(UIColor.green, forKey: key)
                Result.singleton.addCorrectPoint(point: 1)
            } else {
                coloredAnswers.updateValue(UIColor.red, forKey: key)
                Result.singleton.addWrongPoint(point: 1)
            }
        }
        
        colorTableView.reloadData()
        definitionTableView.reloadData()
        
        colorTableView.delegate = nil
        colorTableView.allowsSelection = false
        definitionTableView.delegate = nil
        definitionTableView.allowsSelection = false
        
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
        let alert = UIAlertController(title: "Information", message: "gametype1".localizableString(lang: Utils.getLanguage()), preferredStyle: .alert)
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
