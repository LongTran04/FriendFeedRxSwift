//
//  String.swift
//  FriendFeedRxSwift
//
//  Created by Long Tran on 12/05/2023.
//

import Foundation
import UIKit

extension String {
    var folded: String {
        return self.folding(options: .diacriticInsensitive, locale: nil)
                .replacingOccurrences(of: "đ", with: "d")
                .replacingOccurrences(of: "Đ", with: "D")
    }
}
