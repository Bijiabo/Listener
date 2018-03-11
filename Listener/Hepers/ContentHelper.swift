//
//  ContentHelper.swift
//  Listener
//
//  Created by Chunbo Hu on 2018/3/11.
//  Copyright © 2018年 Chunbo Hu. All rights reserved.
//

import Foundation

private let shared = ContentHelper()
class ContentHelper {
    class var sharedInstance: ContentHelper {
        return shared
    }
    
    func convertPathToFolderName(path: String) -> String {
        let matchedFolderNames = matches(for: "[^/]+$", in: path)
        if (matchedFolderNames.count > 0) {
            return matchedFolderNames.first!
        }
        return ""
    }
    
    private func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
