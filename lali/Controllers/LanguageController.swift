//
//  LanguageController.swift
//  lali
//
//  Created by Balogh Tamas on 2019. 02. 12..
//  Copyright © 2019. Balogh Tamas. All rights reserved.
//

import UIKit

class LanguageController: UIViewController {
    
    @IBOutlet weak var selectYourLanguage: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var frenchLabel: UILabel!
    @IBOutlet weak var germanLabel: UILabel!
    @IBOutlet weak var finnishLabel: UILabel!
    @IBOutlet weak var chooseButton: UIButton!
    
 
    @IBOutlet weak var englishSwith: UISwitch!
    @IBOutlet weak var frenchSwith: UISwitch!
    @IBOutlet weak var germanSwitch: UISwitch!
    @IBOutlet weak var finnishSwitch: UISwitch!
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private var controller = UIViewController()
    
    let userDefaults = UserDefaults.standard
    var language:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller = self
            
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonPressed))
        navigationController!.navigationBar.tintColor = Colors.colorButton
        
        selectYourLanguage.text = "selectyourlanguage".localizableString(lang: Utils.getLanguage())
        englishLabel.text = "english".localizableString(lang: Utils.getLanguage())
        frenchLabel.text = "french".localizableString(lang: Utils.getLanguage())
        germanLabel.text = "german".localizableString(lang: Utils.getLanguage())
        finnishLabel.text = "finnish".localizableString(lang: Utils.getLanguage())
        chooseButton.setTitle("choose".localizableString(lang: Utils.getLanguage()), for: .normal)
        
        language = userDefaults.object(forKey: "language") as? String
        
        switch language {
        case Language.ENGLISH:
            englishSwith.isOn = true
        case Language.GERMAN:
            germanSwitch.isOn = true
        case Language.FRENCH:
            frenchSwith.isOn = true
        case Language.FINNISH:
            finnishSwitch.isOn = true
        default:
            language = Language.ENGLISH
            englishSwith.isOn = true
        }
    }
    
    @IBAction func englishAction(_ sender: UISwitch) {
        if(sender.isOn){
            frenchSwith.isOn = false
            germanSwitch.isOn = false
            finnishSwitch.isOn = false
        }
    }
    @IBAction func frenchAction(_ sender: UISwitch) {
        if(sender.isOn){
            englishSwith.isOn = false
            germanSwitch.isOn = false
            finnishSwitch.isOn = false
        }
    }
    @IBAction func germanAction(_ sender: UISwitch) {
        if(sender.isOn){
            englishSwith.isOn = false
            frenchSwith.isOn = false
            finnishSwitch.isOn = false
        }
    }
    @IBAction func finnishAction(_ sender: UISwitch) {
        if(sender.isOn){
            englishSwith.isOn = false
            frenchSwith.isOn = false
            germanSwitch.isOn = false
        }
    }
        
    @objc func backButtonPressed() {
        let main = storyBoard.instantiateViewController(withIdentifier: "main") as! MainController
        controller.navigationController?.pushViewController(main, animated: true)
    }
    
    @IBAction func choosePressed(_ sender: UIButton) {
        if(englishSwith.isOn){
            language = Language.ENGLISH
        }
        if(frenchSwith.isOn){
            language = Language.FRENCH
        }
        if(germanSwitch.isOn){
            language = Language.GERMAN
        }
        if(finnishSwitch.isOn){
            language = Language.FINNISH
        }
        
        userDefaults.set(language, forKey: "language")
        
        let main = storyBoard.instantiateViewController(withIdentifier: "main") as! MainController
        controller.navigationController?.pushViewController(main, animated: true)
    }
    
}
