//
//  ViewController.swift
//  lali
//
//  Created by Balogh Tamas on 2019. 02. 05..
//  Copyright © 2019. Balogh Tamas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainController: UIViewController {

    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private var controller = UIViewController()
    @IBOutlet weak var language: UIBarButtonItem!
    @IBOutlet weak var mixedGame: UIButton!
    @IBOutlet weak var regularGame: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp(){
        controller = self
        navigationItem.setHidesBackButton(true, animated:true);
        Result.singleton.reInit()
        Utils.LEVEL = 0
        Utils.PHENOMENA = 0
        
        language.title = "language".localizableString(lang: Utils.getLanguage())
        mixedGame.setTitle("mixedGame".localizableString(lang: Utils.getLanguage()), for: .normal)
        regularGame.setTitle("regularGame".localizableString(lang: Utils.getLanguage()), for: .normal)
    }

    @IBAction func mixedGame(_ sender: UIButton) {
        Alamofire.request("http://imhotep.nyme.hu:9443/ArtApp/mix", method: .post, parameters: ["auth": "yTd0Eq6YzDDVQZBL","language": Utils.getLanguage()]).responseJSON { response in
            response.result.ifSuccess {
                
                let games = JSON(response.result.value!)
                let list: Array<JSON> = games["games"].arrayValue
                
                print("Downloading games was SUCCESSFUL! count: \(list.count)")
                
                Utils.GAMETYPE = Utils.MIXED
                Utils.showGame(games: list, viewController:  self)
            }
            
            response.result.ifFailure {
                print("Downloading game was FAILED!")
            }
        }
    }
    
    @IBAction func regularGame(_ sender: UIButton) {
        let regular = storyBoard.instantiateViewController(withIdentifier: "regular") as! RegularGameController
        controller.navigationController?.pushViewController(regular, animated: true)
    }
    
    @IBAction func language(_ sender: UIBarButtonItem) {
        let language = storyBoard.instantiateViewController(withIdentifier: "language") as! LanguageController
        controller.navigationController?.pushViewController(language, animated: true)
    }
    
}
