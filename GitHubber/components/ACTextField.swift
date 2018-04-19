//
//  ACTextField.swift
//  GitHubber
//
//  Created by user on 3/31/18.
//  Copyright © 2018 Shalom Friss. All rights reserved.
//

import Foundation
import UIKit

/**
    ACTextField or Auto Complete text field is just that, a text field that autocompletes.
*/
class ACTextField:NSObject, UITextFieldDelegate {
    
    var textField: UITextField!
    
    private var autoCompletionPossibilities = ["Shalomfriss", "Facebook", "Apple"]
    public var suggestions:[String] {
        get {
            return autoCompletionPossibilities
        }
        set {
            autoCompletionPossibilities = newValue
        }
    }
    
    private var autoCompleteCharacterCount = 0
    private var timer = Timer()
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var subString = (textField.text!.capitalized as NSString).replacingCharacters(in: range, with: string) // 2
        subString = formatSubstring(subString: subString)
        
        
        weak var weakSelf = self
        DataManager.instance.getUsernameSuggestion(substring: subString, complete: {(temp:String?) in
            
            let name:String = temp ?? ""
            if(name == "") {
                weakSelf?.autoCompletionPossibilities = []
            }
            else {
                weakSelf?.autoCompletionPossibilities = [name]
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "possibilitiesUpdated"), object: nil, userInfo: ["value": subString])
            
        })
        
        /*
        if subString.count == 0 {
            self.resetValues()
        } else {
            self.searchAutocompleteEntriesWIthSubstring(substring: subString)
        }
        */
        
        return true
    }
    
    
    public func possibilitiesUpdated(notfication: NSNotification) {
        let subString = notfication.userInfo?["value"] as! String
        if subString.count == 0 {
            self.resetValues()
        } else {
            self.searchAutocompleteEntriesWIthSubstring(substring: subString)
        }
    }
    
    
    func formatSubstring(subString: String) -> String {
        let formatted = String(subString.dropLast(autoCompleteCharacterCount)).lowercased().capitalized
        return formatted
    }
    
    
    func resetValues() {
        autoCompleteCharacterCount = 0
        textField.text = ""
    }
    
    func searchAutocompleteEntriesWIthSubstring(substring: String) {
        
        let userQuery = substring
        //var suggestions = getAutocompleteSuggestions(userText: substring)
        let suggestions = self.autoCompletionPossibilities
        if suggestions.count > 0 {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in
                
                let autocompleteResult = self.formatAutocompleteResult(substring: substring, possibleMatches: suggestions)
                self.putColourFormattedTextInTextField(autocompleteResult: autocompleteResult, userQuery : userQuery)
                self.moveCaretToEndOfUserQueryPosition(userQuery: userQuery)
                
            })
        } else {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in //7
                self.textField.text = substring
            })
            autoCompleteCharacterCount = 0
        }
        
    }
    
    func getAutocompleteSuggestions(userText: String) -> [String]{
        var possibleMatches: [String] = []
        for item in autoCompletionPossibilities { //2
            let myString:NSString! = item as NSString
            let substringRange :NSRange! = myString.range(of: userText)
            
            if (substringRange.location == 0)
            {
                possibleMatches.append(item)
            }
        }
        return possibleMatches
    }
    
    func putColourFormattedTextInTextField(autocompleteResult: String, userQuery : String) {
        let colouredString: NSMutableAttributedString = NSMutableAttributedString(string: userQuery + autocompleteResult)
        colouredString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.cyan, range: NSRange(location: userQuery.count,length:autocompleteResult.count))
        self.textField.attributedText = colouredString
    }
    
    func moveCaretToEndOfUserQueryPosition(userQuery : String) {
        if let newPosition = self.textField.position(from: self.textField.beginningOfDocument, offset: userQuery.count) {
            self.textField.selectedTextRange = self.textField.textRange(from: newPosition, to: newPosition)
        }
        let selectedRange: UITextRange? = textField.selectedTextRange
        textField.offset(from: textField.beginningOfDocument, to: (selectedRange?.start)!)
    }
    
    func formatAutocompleteResult(substring: String, possibleMatches: [String]) -> String {
        var autoCompleteResult = possibleMatches[0]
        autoCompleteResult.removeSubrange(autoCompleteResult.startIndex..<autoCompleteResult.index(autoCompleteResult.startIndex, offsetBy: substring.count))
        autoCompleteCharacterCount = autoCompleteResult.count
        return autoCompleteResult
    }
    
}
