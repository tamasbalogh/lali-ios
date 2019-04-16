//
//  GameType4Controller.swift
//  lali
//
//  Created by Balogh Tamas on 2019. 03. 24..
//  Copyright © 2019. Balogh Tamas. All rights reserved.
//

import UIKit
import SwiftyJSON
import FlexLayout
import PinLayout

class GameType4Controller: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var lowerView: UIView!
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private var controller = UIViewController()
    
    var globalGames: Array<JSON> = [JSON()]
    var image: String = ""
    var sentence: String = ""
    
    let upperFlexView = UIView()
    let lowerFlexView = UIView()
    
    var correctAnswers: [String] = []
    var upperAnswers: [String] = []
    var lowerAnswers: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller = self
        navigationItem.setHidesBackButton(true, animated:true);
        navigationItem.title = ""
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "information"), style: .plain, target: self, action: #selector(informationButtonPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeButtonPressed))
        navigationController!.navigationBar.tintColor = Colors.colorButton
        
        //Decode base64 string and set the image
        let imageData = Data(base64Encoded: image, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        imageView.image = UIImage(data: imageData)
        
        //Shuffle answers
        upperAnswers = Utils.shuffleArray(array: sentence.split(separator: " ").map(String.init))
        
        //Save the correct order of buttons
        correctAnswers = sentence.split(separator: " ").map(String.init)
        
        upperAnswers.forEach ({
            let button = CustomButton()
            button.setTitle($0, for: .normal)
            button.backgroundColor = Colors.colorButton
            button.setTitleColor(.white, for: .normal)
            button.addTarget(self, action: #selector(add), for: .touchUpInside)
            upperFlexView.flex.direction(.row).justifyContent(.start).alignItems(.center).alignContent(.center).wrap(.wrap).margin(10).define{ (flex) in
                flex.addItem(button).padding(5).margin(10)
            }
        })
        
        upperView.addSubview(upperFlexView)
        
        upperFlexView.pin.top().bottom().left().right()
        upperFlexView.flex.layout(mode: .fitContainer)
    }
    
    @objc func add(sender : UIButton){
        let title = sender.titleLabel?.text
        sender.removeFromSuperview()
        
        if let index = upperAnswers.index(where: {$0 == title}) {
            upperAnswers.remove(at: index)
        }
        
        upperFlexView.pin.top().bottom().left().right()
        upperFlexView.flex.layout(mode: .fitContainer)
        
        lowerAnswers.append(title!)
        sender.removeTarget(self, action: #selector(add), for: .touchUpInside)
        sender.addTarget(self, action: #selector(remove), for: .touchUpInside)
        lowerFlexView.flex.direction(.row).justifyContent(.start).alignItems(.center).alignContent(.center).wrap(.wrap).margin(10).define{ (flex) in
            flex.addItem(sender).padding(5).margin(10)
        }
        
        lowerView.addSubview(lowerFlexView)
        lowerFlexView.pin.top().bottom().left().right()
        lowerFlexView.flex.layout(mode: .fitContainer)
        
        if(upperAnswers.count == 0){
            checkResult()
        }
    }
    
    @objc func remove(sender : UIButton){
        
        let title = sender.titleLabel?.text
        sender.removeFromSuperview()
        
        if let index = lowerAnswers.index(where: {$0 == title}) {
            lowerAnswers.remove(at: index)
        }
        
        lowerFlexView.pin.top().bottom().left().right()
        lowerFlexView.flex.layout(mode: .fitContainer)
        
        upperAnswers.append(title!)
        sender.removeTarget(self, action: #selector(remove(sender:)), for: .touchUpInside)
        sender.addTarget(self, action: #selector(add), for: .touchUpInside)
        upperFlexView.flex.direction(.row).justifyContent(.start).alignItems(.center).alignContent(.center).wrap(.wrap).margin(10).define{ (flex) in
            flex.addItem(sender).padding(5).margin(10)
        }
        
        upperView.addSubview(upperFlexView)
        upperFlexView.pin.top().bottom().left().right()
        upperFlexView.flex.layout(mode: .fitContainer)
    }
    
    private func checkResult(){
        
        correctAnswers.forEach({
            let button = CustomButton()
            button.setTitle($0, for: .normal)
            button.backgroundColor = Colors.colorButton
            button.setTitleColor(.white, for: .normal)
            
            upperFlexView.flex.direction(.row).justifyContent(.start).alignItems(.center).alignContent(.center).wrap(.wrap).margin(10).define{ (flex) in
                flex.addItem(button).padding(5).margin(10)
            }
            
            upperView.addSubview(upperFlexView)
            upperFlexView.pin.top().bottom().left().right()
            upperFlexView.flex.layout(mode: .fitContainer)
        })
        
        for view in lowerFlexView.subviews {
            view.removeFromSuperview()
        }
        
        var correctAnswer = true
        
        for (index, _) in lowerAnswers.enumerated() {
            let button = CustomButton()
            button.setTitle(lowerAnswers[index], for: .normal)
            
            if( lowerAnswers[index] == correctAnswers[index]){
                button.backgroundColor = .green
            } else {
                button.backgroundColor = .red
                correctAnswer = false
            }
            button.setTitleColor(.white, for: .normal)
            
            lowerFlexView.flex.direction(.row).justifyContent(.start).alignItems(.center).alignContent(.center).wrap(.wrap).margin(10).define{ (flex) in
                flex.addItem(button).padding(5).margin(10)
            }
            
            lowerView.addSubview(lowerFlexView)
            lowerFlexView.pin.top().bottom().left().right()
            lowerFlexView.flex.layout(mode: .fitContainer)
        }
        
        if(correctAnswer){
            Result.singleton.addCorrectPoint(point: 1)
        } else {
            Result.singleton.addWrongPoint(point: 1)
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
        let alert = UIAlertController(title: "Information", message: "gametype4".localizableString(lang: Utils.getLanguage()), preferredStyle: .alert)
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
