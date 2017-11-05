//
//  Parser.swift
//  Subway_Air_Project
//
//  Created by 한연규 on 2017. 11. 5..
//
//

import UIKit

class Parser: NSObject, XMLParserDelegate {
    var currentElement = ""
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        //print("currentElement = \(currentElement)")
        
        if elementName == "items" {
            items = []
        } else if elementName == "item" {
            item = [:]
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        item[currentElement] = data
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            items.append(item)
            
            
        }
    }
}
