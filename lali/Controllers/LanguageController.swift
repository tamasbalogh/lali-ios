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
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var centerView: UIView!
    
    let englishSwitch = UISwitch()
    let frenchSwitch = UISwitch()
    let germanSwitch = UISwitch()
    let finnishSwitch = UISwitch()
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private var controller = UIViewController()
    
    let userDefaults = UserDefaults.standard
    var language:String?
    
    let centerFlexView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller = self
            
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonPressed))
        navigationController!.navigationBar.tintColor = Colors.colorButton
        
        selectYourLanguage.text = "selectyourlanguage".localizableString(lang: Utils.getLanguage())
        chooseButton.setTitle("choose".localizableString(lang: Utils.getLanguage()), for: .normal)
        
        language = userDefaults.object(forKey: "language") as? String
        
        centerFlexView.flex.define{ (flex) in
            
            flex.addItem().direction(.row).justifyContent(.center).define{ (flex) in
                flex.addItem(englishSwitch).margin(10)
                let engLabel = UILabel()
                engLabel.text = "english".localizableString(lang: Utils.getLanguage())
                flex.addItem(engLabel).margin(10)
            }
            
            flex.addItem().direction(.row).justifyContent(.center).define{ (flex) in
                flex.addItem(frenchSwitch).margin(10)
                let engLabel = UILabel()
                engLabel.text = "french".localizableString(lang: Utils.getLanguage())
                flex.addItem(engLabel).margin(10)
            }
            
            flex.addItem().direction(.row).justifyContent(.center).define{ (flex) in
                flex.addItem(germanSwitch).margin(10)
                let engLabel = UILabel()
                engLabel.text = "german".localizableString(lang: Utils.getLanguage())
                flex.addItem(engLabel).margin(10)
            }
            
            flex.addItem().direction(.row).justifyContent(.center).define{ (flex) in
                flex.addItem(finnishSwitch).margin(10)
                let engLabel = UILabel()
                engLabel.text = "finnish".localizableString(lang: Utils.getLanguage())
                flex.addItem(engLabel).margin(10)
            }
        }
        
        centerView.addSubview(centerFlexView)
        
        centerFlexView.pin.all()
        centerFlexView.flex.layout(mode: .fitContainer)
        
        switch language {
        case Language.ENGLISH:
            englishSwitch.isOn = true
        case Language.GERMAN:
            germanSwitch.isOn = true
        case Language.FRENCH:
            frenchSwitch.isOn = true
        case Language.FINNISH:
            finnishSwitch.isOn = true
        default:
            language = Language.ENGLISH
            englishSwitch.isOn = true
        }
        
        englishSwitch.addTarget(self, action: #selector(englishAction(_:)), for: .valueChanged)
        frenchSwitch.addTarget(self, action: #selector(frenchAction), for: .valueChanged)
        germanSwitch.addTarget(self, action: #selector(germanAction), for: .valueChanged)
        finnishSwitch.addTarget(self, action: #selector(finnishAction), for: .valueChanged)
    }
    
    @objc func englishAction(_ sender: UISwitch) {
        if(sender.isOn){
            frenchSwitch.isOn = false
            germanSwitch.isOn = false
            finnishSwitch.isOn = false
        }
    }
    @objc func frenchAction(_ sender: UISwitch) {
        if(sender.isOn){
            englishSwitch.isOn = false
            germanSwitch.isOn = false
            finnishSwitch.isOn = false
        }
    }
    @objc func germanAction(_ sender: UISwitch) {
        if(sender.isOn){
            englishSwitch.isOn = false
            frenchSwitch.isOn = false
            finnishSwitch.isOn = false
        }
    }
    @objc func finnishAction(_ sender: UISwitch) {
        if(sender.isOn){
            englishSwitch.isOn = false
            frenchSwitch.isOn = false
            germanSwitch.isOn = false
        }
    }
        
    @objc func backButtonPressed() {
        let main = storyBoard.instantiateViewController(withIdentifier: "main") as! MainController
        controller.navigationController?.pushViewController(main, animated: true)
    }
    
    @IBAction func choosePressed(_ sender: UIButton) {
        if(englishSwitch.isOn){
            language = Language.ENGLISH
        }
        if(frenchSwitch.isOn){
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
