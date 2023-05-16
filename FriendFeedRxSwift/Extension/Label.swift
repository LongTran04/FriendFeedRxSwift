//
//  Label.swift
//  FriendFeedRxSwift
//
//  Created by Long Tran on 12/05/2023.
//

import Foundation
import UIKit

extension UILabel {
    func highlightSearchText(_ text: String, in mainText: String) {
        let highlightAttributedString = NSMutableAttributedString(string: mainText)
        let range = (mainText.lowercased().folded as NSString).range(of: text.lowercased().folded)
        highlightAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.customColor, range: range)
        self.attributedText = highlightAttributedString
    }
    
    func highlightText(_ text: String, in mainText: String) {
        let highlightAttributedString = NSMutableAttributedString(string: mainText)
        let range = (mainText.lowercased().folded as NSString).range(of: text.lowercased().folded)
        highlightAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range)
        self.attributedText = highlightAttributedString
    }
}
