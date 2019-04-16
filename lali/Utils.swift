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
            print("The game array is EMPTY!")
            let main = storyBoard.instantiateViewController(withIdentifier: "main") as! MainController
            //viewController.present(main, animated: true, completion: nil)
            viewController.navigationController?.pushViewController(main, animated: true)
        } else if(games.count == 1){
            let result = storyBoard.instantiateViewController(withIdentifier: "result") as! ResultController
            //viewController.present(result, animated: true, completion: nil)
            viewController.navigationController?.pushViewController(result, animated: true)
        } else {
            var tmp = [JSON()]
            for i in 1..<games.count {
                let game = games[i]
                let gametype = game["gametype"]
                if(gametype == 1 || gametype == 2 || gametype == 3 || gametype == 4 || gametype == 5 || gametype == 6 || gametype == 7 || gametype == 8 || gametype == 9 || gametype == 10){
                    tmp.append(games[i])
                    print("\(i) index added - \(gametype)")
                }
            }
            
            let object = tmp[1]
            print(object["gametype"])
            switch object["gametype"].int {
            case 1:
                let gametype1 = storyBoard.instantiateViewController(withIdentifier: "gametype1") as! GameType1Controller
                gametype1.globalGames = tmp
                gametype1.colorsDefault = object["colors"].arrayValue.map{ $0.stringValue }
                gametype1.definitionsDefault = object["definitions"].arrayValue.map{ $0.stringValue }
                viewController.navigationController?.pushViewController(gametype1, animated: true)
            case 2:
                let gametype2 = storyBoard.instantiateViewController(withIdentifier: "gametype2") as! GameType2Controller
                gametype2.globalGames = tmp
                gametype2.image = object["image"].string!
                gametype2.answersDefault = object["answers"].arrayValue.map{ $0.stringValue }
                viewController.navigationController?.pushViewController(gametype2, animated: true)
            case 3:
                let gametype3 = storyBoard.instantiateViewController(withIdentifier: "gametype3") as! GameType3Controller
                gametype3.globalGames = tmp
                gametype3.image = object["image"].string!
                gametype3.sentence = object["sentence"].string!
                gametype3.answers = object["answers"].arrayValue.map{ $0.stringValue }
                viewController.navigationController?.pushViewController(gametype3, animated: true)
            case 4:
                let gametype4 = storyBoard.instantiateViewController(withIdentifier: "gametype4") as! GameType4Controller
                gametype4.globalGames = tmp
                gametype4.image = object["image"].string!
                gametype4.sentence = object["sentence"].string!
                viewController.navigationController?.pushViewController(gametype4, animated: true)
            case 5:
                let gametype5 = storyBoard.instantiateViewController(withIdentifier: "gametype5") as! GameType5Controller
                gametype5.globalGames = tmp
                gametype5.image = object["image"].string!
                gametype5.sentences = object["sentences"].arrayValue.map{ $0.stringValue }
                viewController.navigationController?.pushViewController(gametype5, animated: true)
            case 6:
                let gametype6 = storyBoard.instantiateViewController(withIdentifier: "gametype6") as! GameType6Controller
                gametype6.globalGames = tmp
                gametype6.answers = object["antonyms"].arrayValue.map{ $0.stringValue }
                gametype6.phenomena = object["phenomenon"].string!
                viewController.navigationController?.pushViewController(gametype6, animated: true)
            case 7:
                let gametype7 = storyBoard.instantiateViewController(withIdentifier: "gametype7") as! GameType7Controller
                gametype7.globalGames = tmp
                gametype7.image = object["image"].string!
                gametype7.sentence = object["sentence"].string!
                gametype7.answers = object["answers"].arrayValue.map{ $0.stringValue }
                viewController.navigationController?.pushViewController(gametype7, animated: true)
            case 8:
                let gametype8 = storyBoard.instantiateViewController(withIdentifier: "gametype8") as! GameType8Controller
                gametype8.globalGames = tmp
                gametype8.image = object["image"].string!
                gametype8.sentence = object["sentence"].string!
                gametype8.answer = object["true"].int!
                viewController.navigationController?.pushViewController(gametype8, animated: true)
            case 9:
                let gametype9 = storyBoard.instantiateViewController(withIdentifier: "gametype9") as! GameType9Controller
                gametype9.globalGames = tmp
                gametype9.image = object["image"].string!
                gametype9.answers = object["answers"].arrayValue.map{ $0.stringValue }
                viewController.navigationController?.pushViewController(gametype9, animated: true)
            case 10:
                let gametype10 = storyBoard.instantiateViewController(withIdentifier: "gametype10") as! GameType10Controller
                gametype10.globalGames = tmp
                gametype10.imagesDefault = object["images"].arrayValue.map{ $0.stringValue }
                gametype10.titlesDefault = object["titles"].arrayValue.map{ $0.stringValue }
                gametype10.descriptionsDefault = object["descriptions"].arrayValue.map{ $0.stringValue }
                viewController.navigationController?.pushViewController(gametype10, animated: true)
            /*case 11:
                let gametype11 = storyBoard.instantiateViewController(withIdentifier: "gametype11") as! GameType11Controller
                gametype11.globalGames = tmp
                gametype11.images = object["images"].arrayValue.map{ $0.stringValue }
                gametype11.sentences = object["sentences"].arrayValue.map{ $0.stringValue }
                viewController.navigationController?.pushViewController(gametype11, animated: true)*/
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

class GamePointer{
    
    static let singleton = GamePointer()
    
    private var gamePointer: Int
    
    private init(){
        self.gamePointer = 0
    }
    
    func incrementGamePointer(){
        self.gamePointer+=1
    }
    
    func getGamePointer() -> Int {
        return self.gamePointer
    }
    
    func reInit(){
        self.gamePointer = 0
    }
    
}
