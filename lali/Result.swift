//
//  Result.swift
//  lali
//
//  Created by Balogh Tamas on 2019. 03. 03..
//  Copyright © 2019. Balogh Tamas. All rights reserved.
//

import Foundation
class Result{
    
    static let singleton = Result()
    
    private var correct: Int
    private var wrong: Int
    
    private init(){
        self.correct = 0
        self.wrong = 0
    }
    
    func addCorrectPoint(point: Int){
        self.correct+=point
    }
    
    func addWrongPoint(point: Int){
        self.wrong+=point
    }
    
    func getCorrect() -> Int {
        return self.correct
    }
    
    func getWrong() -> Int {
        return self.wrong
    }
    
    func reInit(){
        self.correct = 0
        self.wrong = 0
    }

}
