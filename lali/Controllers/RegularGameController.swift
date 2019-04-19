//
//  RegularGameController.swift
//  lali
//
//  Created by Balogh Tamas on 2019. 02. 09..
//  Copyright © 2019. Balogh Tamas. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class RegularGameController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var phenomenaPickerView: UIPickerView!
    @IBOutlet weak var levelPickerView: UIPickerView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private var controller = UIViewController()
    
    var phenomenas:[String] = []
    var levels:[String] = []
    var phenomena = ""
    var level = ""
    var phenomenaRow = 1
    var levelRow = 1
    
    var selectedPhenomena = Utils.PHENOMENA
    var selectedLevel = Utils.LEVEL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    @objc func backButtonPressed() {
        let main = storyBoard.instantiateViewController(withIdentifier: "main") as! MainController
        controller.navigationController?.pushViewController(main, animated: true)
    }
    
    func setUp(){
        controller = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonPressed))
        navigationController!.navigationBar.tintColor = Colors.colorButton
        
        startButton.setTitle("start".localizableString(lang: Utils.getLanguage()), for: .normal)
        
        switch Utils.getLanguage() {
        case Language.ENGLISH:
            phenomenas=["Food","People","Leisure Time","Interior","Nature","City and Architecture","Stories and Myths"]
            levels=["Basic","Advance"]
        case Language.GERMAN:
            phenomenas=["Lektion 1","Lektion 2","Lektion 3","Lektion 4","Lektion 5","Lektion 6","Lektion 7","Lektion 8","Lektion 9","Lektion 10","Lektion 11","Lektion 12"]
            levels=["AnfängerInnen","Fortgeschrittene"]
        case Language.FRENCH:
            phenomenas=["Leçon 1","Leçon 2","Leçon 3","Leçon 4","Leçon 5","Leçon 6","Leçon 7","Leçon 8","Leçon 9","Leçon 10","Leçon 11","Leçon 12"]
            levels=["Débutant","Avancé"]
        case Language.FINNISH:
            phenomenas=["Oppitunti 1","Oppitunti 2","Oppitunti 3","Oppitunti 4","Oppitunti 5","Oppitunti 6","Oppitunti 7","Oppitunti 8","Oppitunti 9","Oppitunti 10","Oppitunti 11","Oppitunti 12"]
            levels=["Helppo","Vaikea"]
        default:
            phenomenas=["Food","People","Leisure Time","Interior","Nature","City and Architecture","Stories and Myths"]
            levels=["Basic","Advance"]
        }
        
        phenomenaPickerView.delegate = self
        phenomenaPickerView.dataSource = self
        levelPickerView.delegate = self
        levelPickerView.dataSource = self
        
        
        phenomenaPickerView.selectRow(selectedPhenomena, inComponent: 0, animated: false)
        levelPickerView.selectRow(selectedLevel, inComponent: 0, animated: false)
        
        phenomena = phenomenas[selectedPhenomena]
        level = levels[selectedLevel]
    }
    
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.isEqual(phenomenaPickerView)){
            return phenomenas.count
        }
        return levels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.isEqual(phenomenaPickerView)){
            return phenomenas[row]
        }
        return levels[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.isEqual(phenomenaPickerView)){
            phenomena = phenomenas[row]
            phenomenaRow = row + 1
            Utils.PHENOMENA = row
        }
        if(pickerView.isEqual(levelPickerView)){
            level = levels[row]
            levelRow = row + 1
            Utils.LEVEL = row
        }
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        let params: Parameters = [
            "auth": "yTd0Eq6YzDDVQZBL",
            "language": Utils.getLanguage(),
            "lesson": phenomenaRow,
            "level": levelRow
        ]
        
        Alamofire.request("http://imhotep.nyme.hu:9443/ArtApp/regular", method: .post, parameters: params).responseJSON { response in
            response.result.ifSuccess {
                print("Downloading games was SUCCESSFUL!")
                let games = JSON(response.result.value!)
                let list: Array<JSON> = games["games"].arrayValue
                Utils.GAMETYPE = Utils.REGULAR
                Utils.showGame(games: list, viewController:  self)
            }
            
            response.result.ifFailure {
                print("Downloading game was FAILED!")
            }
        }
    }
}
