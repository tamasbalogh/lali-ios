//
//  GameType10Controller.swift
//  lali
//
//  Created by Balogh Tamas on 2019. 04. 07..
//  Copyright © 2019. Balogh Tamas. All rights reserved.
//

import UIKit
import SwiftyJSON

class GameType10Controller: UIViewController {
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private var controller = UIViewController()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionScrollView: UIScrollView!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var globalGames: Array<JSON> = [JSON()]
    var titlesDefault: [String] = [""]
    var imagesDefault: [String] = [""]
    var descriptionsDefault: [String] = [""]
    
    private var titles = [""]
    private var images = [""]
    private var descriptions = [""]
    private var answersDefault: [GameType10Object] = []
    private var answersCreated: [Bool] = [true,true,true]
    
    private var titlePointer = Int.random(in: 0 ... 2)
    private var imagePointer = Int.random(in: 0 ... 2)
    private var descriptionPointer = Int.random(in: 0 ... 2)
    private var buttonClickCounter = 0
    
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
        
        if(titlesDefault.count == imagesDefault.count && titlesDefault.count == descriptionsDefault.count){
            for i in 0..<titlesDefault.count{
                let object = GameType10Object(title: titlesDefault[i],image: imagesDefault[i],description: descriptionsDefault[i])
                answersDefault.insert(object, at: i)
            }
        }
        
        titles = Utils.shuffleArray(array: titlesDefault)
        images = Utils.shuffleArray(array: imagesDefault)
        descriptions = Utils.shuffleArray(array: descriptionsDefault)
        
        let imageData = Data(base64Encoded: images[imagePointer], options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        imageView.image = UIImage(data: imageData)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewPressed)))
        
        titleLabel.text = titles[titlePointer]
        titleLabel.isUserInteractionEnabled = true
        titleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(titleLabelPressed)))
        
        descriptionLabel.text = descriptions[descriptionPointer]
        descriptionLabel.isUserInteractionEnabled = true
        descriptionLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(descriptionLabelPressed)))
        
    }
    
    private func getNext(_ pointer: Int) -> Int{
        var p = 0
        switch pointer {
        case 0:
            p = 1
        case 1:
            p = 2
        case 2:
            p = 0
        default:
            p = 0
        }
        return p
    }
    
    @objc func titleLabelPressed(sender:UITapGestureRecognizer) {
        titlePointer = getNext(titlePointer);
        while(titles[titlePointer] == " "){
            titlePointer = getNext(titlePointer);
        }
        
        titleLabel.text = titles[titlePointer]
        print("title: \(titlePointer)")
    }
    
    @objc func imageViewPressed(sender:UITapGestureRecognizer) {
        imagePointer = getNext(imagePointer);
        while(images[imagePointer] == " "){
            imagePointer = getNext(imagePointer);
        }
        
        let imageData = Data(base64Encoded: images[imagePointer], options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        imageView.image = UIImage(data: imageData)
        
        print("image: \(imagePointer)")
    }
    
    @objc func descriptionLabelPressed(sender:UITapGestureRecognizer) {
        descriptionPointer = getNext(descriptionPointer);
        while(descriptions[descriptionPointer] == " "){
            descriptionPointer = getNext(descriptionPointer);
        }
        
        descriptionLabel.text = descriptions[descriptionPointer]
        print("description: \(descriptionPointer)")
    }
    
    @IBAction func chooseButtonPressed(_ sender: UIButton) {
        print("title: \(titlePointer), image: \(imagePointer), description: \(descriptionPointer) ")
        
        buttonClickCounter += 1
        
        if(buttonClickCounter > 2){
            if(titlePointer == imagePointer && titlePointer == descriptionPointer){
                answersCreated[titlePointer]=true;
                Result.singleton.addCorrectPoint(point: 1)
            } else {
                answersCreated[titlePointer]=false;
                Result.singleton.addWrongPoint(point: 1)
            }
            
            chooseButton.setTitle("Check Result", for: .normal)
            titleLabel.isUserInteractionEnabled = false
            imageView.isUserInteractionEnabled = false
            descriptionLabel.isUserInteractionEnabled = false
            chooseButton.removeTarget(self, action: #selector(chooseButtonPressed), for: .touchUpInside)
            chooseButton.addTarget(self, action: #selector(checkResultButtonPressed), for: .touchUpInside)
            
            titlePointer = 0
            imagePointer = 0
            descriptionPointer = 0
            
            titleLabel.text = answersDefault[titlePointer].title
            let imageData = Data(base64Encoded: answersDefault[imagePointer].image, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
            imageView.image = UIImage(data: imageData)
            descriptionLabel.text = answersDefault[descriptionPointer].description
            
            if(answersCreated[titlePointer]){
                titleLabel.backgroundColor = UIColor.green
            } else {
                titleLabel.backgroundColor = UIColor.red
            }
        } else {
            if(titlePointer == imagePointer && titlePointer == descriptionPointer){
                answersCreated[titlePointer]=true;
                Result.singleton.addCorrectPoint(point: 1)
            } else {
                answersCreated[titlePointer]=false;
                Result.singleton.addWrongPoint(point: 1)
            }
            
            titles[titlePointer]=" "
            images[imagePointer]=" "
            descriptions[descriptionPointer]=" "
            
            titlePointer = Int.random(in: 0 ... 2)
            while(titles[titlePointer] == " "){
                titlePointer = getNext(titlePointer);
            }
            imagePointer = Int.random(in: 0 ... 2)
            while(images[imagePointer] == " "){
                imagePointer = getNext(imagePointer);
            }
            descriptionPointer = Int.random(in: 0 ... 2)
            while(descriptions[descriptionPointer] == " "){
                descriptionPointer = getNext(descriptionPointer);
            }
            
            titleLabel.text = titles[titlePointer]
            let imageData = Data(base64Encoded: images[imagePointer], options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
            imageView.image = UIImage(data: imageData)
            descriptionLabel.text = descriptions[descriptionPointer]
            
        }
    }
    
    @objc func checkResultButtonPressed(_ sender: UIButton!) {
        titlePointer = getNext(titlePointer);
        imagePointer = titlePointer;
        descriptionPointer = titlePointer;
        
        titleLabel.text = answersDefault[titlePointer].title
        let imageData = Data(base64Encoded: answersDefault[imagePointer].image, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        imageView.image = UIImage(data: imageData)
        descriptionLabel.text = answersDefault[descriptionPointer].description
        
        if(answersCreated[titlePointer]){
            titleLabel.backgroundColor = UIColor.green
        } else {
            titleLabel.backgroundColor = UIColor.red
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
        let alert = UIAlertController(title: "Information", message: "gametype10".localizableString(lang: Utils.getLanguage()), preferredStyle: .alert)
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

struct GameType10Object {
    var title: String
    var image: String
    var description : String
}
