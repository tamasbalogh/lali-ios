//
//  GameType9Controller.swift
//  lali
//
//  Created by Balogh Tamas on 2019. 04. 19..
//  Copyright © 2019. Balogh Tamas. All rights reserved.
//

import UIKit
import SwiftyJSON

class GameType9Controller: UIViewController {
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private var controller = UIViewController()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lowerView: UIView!
    
    let lowerFlexView = UIView()
    
    var globalGames: Array<JSON> = [JSON()]
    var image: String = ""
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
        
        //Decode base64 string and set the image
        let imageData = Data(base64Encoded: image, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        imageView.image = UIImage(data: imageData)
        
        //Save the correct answer
        answer = answers[0]
        
        //Shuffle answers
        let shuffledAnswers = Utils.shuffleArray(array: answers)
        
        shuffledAnswers.forEach ({
            let button = CustomButton()
            button.setTitle($0, for: .normal)
            button.backgroundColor = Colors.colorButton
            button.setTitleColor(.white, for: .normal)
            button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            lowerFlexView.flex.direction(.row).justifyContent(.start).alignItems(.center).alignContent(.center).wrap(.wrap).margin(10).define{ (flex) in
                flex.addItem(button).padding(5).margin(10)
            }
        })
        
        lowerView.addSubview(lowerFlexView)
        
        lowerFlexView.pin.top().bottom().left().right()
        lowerFlexView.flex.layout(mode: .fitContainer)
    }
    
    @objc func buttonPressed(sender : UIButton){
        
        if(sender.titleLabel?.text!.isEqual(answer))!{
            sender.backgroundColor = UIColor.green
            Result.singleton.addCorrectPoint(point: 1)
        } else {
            sender.backgroundColor = UIColor.red
            Result.singleton.addWrongPoint(point: 1)
            
            for view in lowerFlexView.subviews {
                let button = view as! UIButton
                if((button.titleLabel?.text!.isEqual(answer))!){
                    button.backgroundColor = UIColor.green
                }
            }
            
        }
        
        for view in lowerFlexView.subviews {
            let button = view as! UIButton
            button.removeTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        }
        
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
        let alert = UIAlertController(title: "Information", message: "gametype9".localizableString(lang: Utils.getLanguage()), preferredStyle: .alert)
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
