//
//  GameType6Controller.swift
//  lali
//
//  Created by Balogh Tamas on 2019. 03. 20..
//  Copyright © 2019. Balogh Tamas. All rights reserved.
//

import UIKit
import SwiftyJSON

class GameType6Controller: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private var controller = UIViewController()
    
    var phenomena: String = ""
    var globalGames: Array<JSON> = [JSON()]
    var answers: [String] = []
    private var answer: String = ""
    
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
        
        //Set label text
        label.text = phenomena
        
        //Save the correct answer
        answer = answers[0]
        
        //Shuffle answers
        let shuffledAnswers = Utils.shuffleArray(array: answers)
        
        //Set buttons text
        button1.setTitle(shuffledAnswers[0], for: .normal)
        button2.setTitle(shuffledAnswers[1], for: .normal)
        button3.setTitle(shuffledAnswers[2], for: .normal)
        
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if((sender.titleLabel?.text!.isEqual(answer))!){
            sender.backgroundColor = UIColor.green
            Result.singleton.addCorrectPoint(point: 1)
        } else {
            sender.backgroundColor = UIColor.red
            Result.singleton.addWrongPoint(point: 1)
            
            if(button1.titleLabel?.text!.isEqual(answer))!{
                button1.backgroundColor = UIColor.green
            }
            if(button2.titleLabel?.text!.isEqual(answer))!{
                button2.backgroundColor = UIColor.green
            }
            if(button3.titleLabel?.text!.isEqual(answer))!{
                button3.backgroundColor = UIColor.green
            }
        }
        
        button1.isEnabled = false
        button2.isEnabled = false
        button3.isEnabled = false
        
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
        let alert = UIAlertController(title: "Information", message: "gametype6".localizableString(lang: Utils.getLanguage()), preferredStyle: .alert)
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
