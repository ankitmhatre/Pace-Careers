//
//  XMLParserDelegateImpl.swift
//  Pace Careers Notification
//
//  Created by Ankit Mhatre on 7/6/23.
//

import Foundation


class XMLParserDelegateImpl: NSObject, XMLParserDelegate {
    var currentElement: String = ""
    var entries: [Entry] = []
    var currentEntry: Entry?
    
    func parseXMLData(data: Data) {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "entry" {
            currentEntry = Entry()
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "entry" {
            if let entry = currentEntry {
                entries.append(entry)
                currentEntry = nil
            }
        }
        currentElement = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let parsedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if !parsedString.isEmpty {
            if currentElement == "id" {
                currentEntry?.id = parsedString
            } else if currentElement == "title" {
                currentEntry?.title = parsedString
            } else if currentElement == "updated" {
                currentEntry?.updated = parsedString
            }
            else if currentElement == "published" {
                currentEntry?.published = parsedString
           }
            else if currentElement == "content" {
                currentEntry?.content = parsedString
           }
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("XML Parsing Error: \(parseError.localizedDescription)")
    }
}

struct Entry {
    var id: String = ""
    var title: String = ""
    var updated: String = ""
    var published: String = ""
    var content: String = ""
}




