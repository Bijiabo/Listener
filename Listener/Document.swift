//
//  Document.swift
//  Listener
//
//  Created by Chunbo Hu on 2018/3/11.
//  Copyright © 2018年 Chunbo Hu. All rights reserved.
//

import UIKit

class Document: UIDocument {
    
    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
        return Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
    }
}

