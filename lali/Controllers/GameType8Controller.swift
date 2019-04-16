//
//  GameType8Controller.swift
//  lali
//
//  Created by Balogh Tamas on 2019. 03. 21..
//  Copyright © 2019. Balogh Tamas. All rights reserved.
//

import UIKit
import SwiftyJSON

class GameType8Controller: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private var controller = UIViewController()
    
    var globalGames: Array<JSON> = [JSON()]
    var image: String = ""
    var sentence: String = ""
    var answer: Int = 0
    
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
        
        //Set the label text
        label.text = sentence
        
        var answers: [String] = []
        
        switch Utils.getLanguage() {
        case Language.ENGLISH:
            answers = ["True","False"]
        case Language.GERMAN:
            answers = ["Richtig","Falsch"]
        case Language.FRENCH:
            answers = ["Vrai","Faux"]
        case Language.FINNISH:
            answers = ["Oikein","Väärin"]
        default:
            answers = ["True","False"]
        }
        
        //Shuffle answers
        let shuffledAnswers = Utils.shuffleArray(array: answers)
        
        //Set buttons text
        button1.setTitle(shuffledAnswers[0], for: .normal)
        button2.setTitle(shuffledAnswers[1], for: .normal)
        
        button1.tag=1
        button2.tag=2
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        
        var pressedValue = 0
        
        if( (sender.titleLabel?.text!.isEqual("True"))! || (sender.titleLabel?.text!.isEqual("Richtig"))! || (sender.titleLabel?.text!.isEqual("Vrai"))! || (sender.titleLabel?.text!.isEqual("Oikein"))!){
            pressedValue = 1
        }
        
        if(answer == pressedValue){
            sender.backgroundColor = UIColor.green
            Result.singleton.addCorrectPoint(point: 1)
        } else {
            sender.backgroundColor = UIColor.red
            Result.singleton.addWrongPoint(point: 1)
            
            if(button1.tag != sender.tag){
                button1.backgroundColor = UIColor.green
            }
            if(button2.tag != sender.tag){
                button2.backgroundColor = UIColor.green
            }
        }
        
        button1.isEnabled = false
        button2.isEnabled = false
        
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
        let alert = UIAlertController(title: "Information", message: "gametype8".localizableString(lang: Utils.getLanguage()), preferredStyle: .alert)
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
