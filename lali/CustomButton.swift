//
//  CustomButton.swift
//  lali
//
//  Created by Balogh Tamas on 2019. 03. 20..
//  Copyright © 2019. Balogh Tamas. All rights reserved.
//

import UIKit

class CustomButton : UIButton{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp(){
        setShadow()
        setTitleColor(.white, for: .normal)
        titleLabel?.font     = .boldSystemFont(ofSize: 14)
        titleLabel!.lineBreakMode = .byWordWrapping
        titleLabel!.textAlignment = .center
        backgroundColor      = Colors.colorButton
        layer.cornerRadius   = 10
        layer.borderWidth    = 2.5
        layer.borderColor    = UIColor(red:0.22, green:0.54, blue:0.78, alpha:1.0).cgColor
    }
    
    
    private func setShadow() {
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius  = 8
        layer.shadowOpacity = 0.5
        clipsToBounds       = true
        layer.masksToBounds = false
    }
}
