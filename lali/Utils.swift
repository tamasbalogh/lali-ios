//
//  Utils.swift
//  lali
//
//  Created by Balogh Tamas on 2019. 03. 03..
//  Copyright © 2019. Balogh Tamas. All rights reserved.
//

import Foundation
import SwiftyJSON

class Utils{
    
    static var GAMETYPE = ""
    static let MIXED = "MIXED"
    static let REGULAR = "REGULAR"
    static var PHENOMENA = -1
    static var LEVEL = -1
    
    static func getLanguage() -> String{
        let userDefaults = UserDefaults.standard
        let language = userDefaults.object(forKey: "language") as? String
        return language ?? Language.ENGLISH
    }
    
    static func shuffleArray(array: [String]) -> [String]{
        var defaultArray = array
        var shuffled = [String]();
        for _ in 0..<defaultArray.count{
            let rand = Int(arc4random_uniform(UInt32(defaultArray.count)))
            shuffled.append(defaultArray[rand])
            defaultArray.remove(at: rand)
        }
        return shuffled
    }
    
    static func showGame(games: Array<JSON>, viewController: UIViewController) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if(games.count == 0 ){
            let result = storyBoard.instantiateViewController(withIdentifier: "result") as! ResultController
            viewController.navigationController?.pushViewController(result, animated: true)
        } else {
            let object = games[0]
            switch object["gametype"].int {
            case 1:
                let gametype1 = storyBoard.instantiateViewController(withIdentifier: "gametype1") as! GameType1Controller
                gametype1.globalGames = games
                gametype1.colorsDefault = object["colors"].arrayValue.map{ $0.stringValue }
                gametype1.definitionsDefault = object["definitions"].arrayValue.map{ $0.stringValue }
                viewController.navigationController?.pushViewController(gametype1, animated: true)
            case 2:
                let gametype2 = storyBoard.instantiateViewController(withIdentifier: "gametype2") as! GameType2Controller
                gametype2.globalGames = games
                gametype2.image = object["image"].string!
                gametype2.answersDefault = object["answers"].arrayValue.map{ $0.stringValue }
                viewController.navigationController?.pushViewController(gametype2, animated: true)
            case 3:
                let gametype3 = storyBoard.instantiateViewController(withIdentifier: "gametype3") as! GameType3Controller
                gametype3.globalGames = games
                gametype3.image = object["image"].string!
                gametype3.sentence = object["sentence"].string!
                gametype3.answers = object["answers"].arrayValue.map{ $0.stringValue }
                viewController.navigationController?.pushViewController(gametype3, animated: true)
            case 4:
                let gametype4 = storyBoard.instantiateViewController(withIdentifier: "gametype4") as! GameType4Controller
                gametype4.globalGames = games
                gametype4.image = object["image"].string!
                gametype4.sentence = object["sentence"].string!
                viewController.navigationController?.pushViewController(gametype4, animated: true)
            case 5:
                let gametype5 = storyBoard.instantiateViewController(withIdentifier: "gametype5") as! GameType5Controller
                gametype5.globalGames = games
                gametype5.image = object["image"].string!
                gametype5.sentences = object["sentences"].arrayValue.map{ $0.stringValue }
                viewController.navigationController?.pushViewController(gametype5, animated: true)
            case 6:
                let gametype6 = storyBoard.instantiateViewController(withIdentifier: "gametype6") as! GameType6Controller
                gametype6.globalGames = games
                gametype6.answers = object["antonyms"].arrayValue.map{ $0.stringValue }
                gametype6.phenomena = object["phenomenon"].string!
                viewController.navigationController?.pushViewController(gametype6, animated: true)
            case 7:
                let gametype7 = storyBoard.instantiateViewController(withIdentifier: "gametype7") as! GameType7Controller
                gametype7.globalGames = games
                gametype7.image = object["image"].string!
                gametype7.sentence = object["sentence"].string!
                gametype7.answers = object["answers"].arrayValue.map{ $0.stringValue }
                viewController.navigationController?.pushViewController(gametype7, animated: true)
            case 8:
                let gametype8 = storyBoard.instantiateViewController(withIdentifier: "gametype8") as! GameType8Controller
                gametype8.globalGames = games
                gametype8.image = object["image"].string!
                gametype8.sentence = object["sentence"].string!
                gametype8.answer = object["true"].int!
                viewController.navigationController?.pushViewController(gametype8, animated: true)
            case 9:
                let gametype9 = storyBoard.instantiateViewController(withIdentifier: "gametype9") as! GameType9Controller
                gametype9.globalGames = games
                gametype9.image = object["image"].string!
                gametype9.answers = object["answers"].arrayValue.map{ $0.stringValue }
                viewController.navigationController?.pushViewController(gametype9, animated: true)
            case 10:
                let gametype10 = storyBoard.instantiateViewController(withIdentifier: "gametype10") as! GameType10Controller
                gametype10.globalGames = games
                gametype10.imagesDefault = object["images"].arrayValue.map{ $0.stringValue }
                gametype10.titlesDefault = object["titles"].arrayValue.map{ $0.stringValue }
                gametype10.descriptionsDefault = object["descriptions"].arrayValue.map{ $0.stringValue }
                viewController.navigationController?.pushViewController(gametype10, animated: true)
            case 11:
                let gametype11 = storyBoard.instantiateViewController(withIdentifier: "gametype11") as! GameType11Controller
                gametype11.globalGames = games
                gametype11.images = object["images"].arrayValue.map{ $0.stringValue }
                gametype11.sentences = object["sentences"].arrayValue.map{ $0.stringValue }
                viewController.navigationController?.pushViewController(gametype11, animated: true)
            default:
                print("gametype\(object["gametype"]) is not implemented yet!")
            }
        }
    }
}

class Language {
    static let ENGLISH = "en"
    static let GERMAN = "de"
    static let FRENCH = "fr"
    static let FINNISH = "fi"
}

extension String{
    func localizableString(lang: String) -> String{
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
