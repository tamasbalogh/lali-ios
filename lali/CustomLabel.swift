//
//  CustomLabel.swift
//  lali
//
//  Created by Balogh Tamas on 2019. 04. 07..
//  Copyright © 2019. Balogh Tamas. All rights reserved.
//

import UIKit

class CustomLabel : UILabel{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp(){
        textColor = .black
        font = .boldSystemFont(ofSize: 16)
        textAlignment = .center
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
    }
}
