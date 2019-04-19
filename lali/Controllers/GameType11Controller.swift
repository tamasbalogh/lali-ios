//
//  GameType10Controller.swift
//  lali
//
//  Created by Balogh Tamas on 2019. 04. 07..
//  Copyright © 2019. Balogh Tamas. All rights reserved.
//

import UIKit
import SwiftyJSON

class GameType11Controller: UIViewController {
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private var controller = UIViewController()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var choosePictureButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var sentencesLabel: UILabel!
    
    
    var globalGames: Array<JSON> = [JSON()]
    var sentences: [String] = []
    var images: [String] = []
    
    private var imagePointer = Int.random(in: 0 ... 2)
    private var sentenceCounter = 0
    private var sentence = ""
    private var answered = false
    
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
        
        choosePictureButton.setTitle("choosepicture".localizableString(lang: Utils.getLanguage()), for: .normal)
        helpButton.setTitle("help".localizableString(lang: Utils.getLanguage()), for: .normal)
        
        let imageData = Data(base64Encoded: images[imagePointer], options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        imageView.image = UIImage(data: imageData)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewPressed)))
        
        sentence = sentences[sentenceCounter]
        sentencesLabel.text = sentence
        
    }
    
    @objc func imageViewPressed(sender:UITapGestureRecognizer) {
        imagePointer = getNext(imagePointer);
        let imageData = Data(base64Encoded: images[imagePointer], options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        imageView.image = UIImage(data: imageData)
        if(answered){
            if(imagePointer == 0){
                choosePictureButton.backgroundColor = UIColor.green
            } else {
                choosePictureButton.backgroundColor = UIColor.red
            }
        }
    }
    
    @IBAction func choosePictureButtonPressed(_ sender: UIButton) {
        answered = true
        choosePictureButton.removeTarget(self, action: #selector(choosePictureButtonPressed), for: .touchUpInside)
        choosePictureButton.isEnabled = false
        
        if(imagePointer == 0){
            Result.singleton.addCorrectPoint(point: 1)
            choosePictureButton.backgroundColor = UIColor.green
        } else {
            Result.singleton.addWrongPoint(point: 1)
            choosePictureButton.backgroundColor = UIColor.red
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "next"), style: .plain, target: self, action: #selector(nextButtonPressed))
        navigationController!.navigationBar.tintColor = Colors.colorButton
    }
    
    @IBAction func helpButtonPressed(_ sender: UIButton) {
        sentenceCounter += 1
        sentence.append("\n\(sentences[sentenceCounter])")
        sentencesLabel.text = sentence
        if(sentenceCounter == (sentences.count - 1)){
            helpButton.removeTarget(self, action: #selector(helpButtonPressed), for: .touchUpInside)
            helpButton.backgroundColor = UIColor.gray
            helpButton.isEnabled = false
        }
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
        let alert = UIAlertController(title: "Information", message: "gametype11".localizableString(lang: Utils.getLanguage()), preferredStyle: .alert)
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
}
