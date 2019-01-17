//
//  StringExtension.swift
//  Gift
//
//  Created by 张鑫 on 2017/2/11.
//  Copyright © 2017年 CrowForRui. All rights reserved.
//

import Foundation

extension String {
    func subString(_ from:Int,to:Int) -> String {
        guard from < to && to <= self.characters.count else {return ""}
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return self.substring(with: Range(startIndex ..< endIndex))
    }
    
    
    
}



