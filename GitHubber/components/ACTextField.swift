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
    https://medium.com/@aestusLabs/inline-autocomplete-textfields-swift-3-tutorial-for-ios-a88395ca2635
*/
class ACTextField:NSObject, UITextFieldDelegate {
    
    var textField: UITextField!
    private var autoCompleteCharacterCount = 0
    private var timer = Timer()
    
    //The autocomplete possibilities
    private var autoCompletionPossibilities = [String]()
    public var suggestions:[String] {
        get {
            return autoCompletionPossibilities
        }
        set {
            autoCompletionPossibilities = newValue
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //Replace the characters that need replacing
        var subString = (textField.text!.capitalized as NSString).replacingCharacters(in: range, with: string)
        //format the substring by dropping the
        subString = formatSubstring(subString: subString)
        
        print("Chagne")
        print(subString)
        print(subString.count)
        
        if(subString.count > 1) {
            weak var weakSelf = self
            DataManager.instance.getUsernameSuggestions(substring: subString, complete: {(temp:[String]) in
                weakSelf?.autoCompletionPossibilities = temp
                weakSelf?.possibilitiesUpdated()
            })
        }
        
        
        
        if subString.count == 0 {
            self.resetValues()
        } else {
            self.searchAutocompleteEntriesWIthSubstring(substring: subString)
        }
        
        
        return true
    }
    
    /**
        A callback from
    */
    public func possibilitiesUpdated() {
        print("Updated")
        print(self.autoCompletionPossibilities)
    }
    
    /**
        Format the string by dropping the last autoCompleteCharacterCount characters
    */
    func formatSubstring(subString: String) -> String {
        let formatted = String(subString.dropLast(autoCompleteCharacterCount)).lowercased().capitalized
        return formatted
    }
    
    /**
        Reset the autocomplete characters and the textField text
    */
    func resetValues() {
        autoCompleteCharacterCount = 0
        textField.text = ""
    }
    
    /**
        If suggestions exist,
        @param substring:String - The substring to search for
    */
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
    
    /**
        Get an autocomplete suggestion for the user provided text
        @param userText:String - the text to auto complete
    */
    func getAutocompleteSuggestions(userText: String) -> [String]{
        var possibleMatches: [String] = []
        //For all the posibilities
        for item in autoCompletionPossibilities {
            
            //if the user text is a substring of the possibility append it to the list of possibilities
            let myString:NSString! = item as NSString
            let substringRange :NSRange! = myString.range(of: userText)
            if (substringRange.location == 0)
            {
                possibleMatches.append(item)
            }
            
        }
        return possibleMatches
    }
    
    /**
     Get the first autocomplete result and remove the first substing.count letters
     */
    func formatAutocompleteResult(substring: String, possibleMatches: [String]) -> String {
        var autoCompleteResult = possibleMatches[0]
        //Make sure there are more characters in the result then the substring otherwise the program will crash
        if(autoCompleteResult.count >= substring.count) {
            let range = autoCompleteResult.startIndex..<autoCompleteResult.index(autoCompleteResult.startIndex, offsetBy: substring.count)
            autoCompleteResult.removeSubrange(range)
        }
        autoCompleteCharacterCount = autoCompleteResult.count
        return autoCompleteResult
    }
    
    
    /**
        Create an attributed string, where the user text is black and the suggestion text is colored
    */
    func putColourFormattedTextInTextField(autocompleteResult: String, userQuery : String) {
        let colouredString: NSMutableAttributedString = NSMutableAttributedString(string: userQuery + autocompleteResult)
        colouredString.addAttribute(NSAttributedStringKey.foregroundColor,
                                    value: UIColor.cyan,
                                    range: NSRange(location: userQuery.count,length:autocompleteResult.count))
        self.textField.attributedText = colouredString
    }
    
    /**
        Move the cursor to the end of where the user was typing
    */
    func moveCaretToEndOfUserQueryPosition(userQuery : String) {
        if let newPosition = self.textField.position(from: self.textField.beginningOfDocument, offset: userQuery.count) {
            self.textField.selectedTextRange = self.textField.textRange(from: newPosition, to: newPosition)
        }
        let selectedRange: UITextRange? = textField.selectedTextRange
        textField.offset(from: textField.beginningOfDocument, to: (selectedRange?.start)!)
    }
    
    
}
