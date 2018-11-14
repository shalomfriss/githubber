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
    
    //MARK:- Properties
    //The text field
    private var _textField: UITextField!
    public var textField:UITextField! {
        get {
            return _textField
        }
        set {
            if(_textField != nil) {
                _textField.gestureRecognizers?.forEach(_textField.removeGestureRecognizer)
            }
            _textField = newValue
            
            //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
            //_textField.addGestureRecognizer(tapGestureRecognizer)
            
            //let longTapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
            //_textField.addGestureRecognizer(longTapGestureRecognizer)
        }
    }
    
    //The number of characters that were added
    private var autoCompleteCharacterCount = 0
    
    //the current text, used to help async functionality
    private var currentText:String = ""
    
    var timer = Timer()
    
    //The autocomplete possibilities (get/set)
    private var autocompletePossibilities = [String]()
    public var suggestions:[String] {
        get {
            return autocompletePossibilities
        }
        set {
            autocompletePossibilities = newValue
        }
    }
    
    override init() {
        super.init()
    }
    
    @objc func tapped(sender: UITapGestureRecognizer)
    {
        if(self.autoCompleteCharacterCount > 0){
            weak var weakself = self
            DispatchQueue.main.async {
                weakself?.textField.typingAttributes = [String:Any]()
                let tx = weakself?.textField.text
                weakself?.textField.text = tx
                weakself?.currentText = tx ?? ""
            }
        }
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer)
    {
        
    }
    
    private func textFieldShouldReturn(textField: UITextField) -> Bool {
        weak var weakself = self
        DispatchQueue.main.async {
            weakself?.textField.resignFirstResponder()
        }
        
        return false
    }
    
    public func getSearchTerm() -> String {
        return self.currentText
    }
    /************************************************************************/
    /************************************************************************/
    //MARK:- TextField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        weak var weakself = self
        DispatchQueue.main.async {
            weakself?.textField.typingAttributes = [String:Any]()
            let tx = weakself?.textField.text
            weakself?.textField.text = tx
            weakself?.currentText = tx ?? ""
            weakself?.resetAll()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //Replace the characters that need replacing
        let subString1 = (textField.text!.capitalized as NSString).replacingCharacters(in: range, with: string)
        print("Substring: \(subString1)")
        
        //format the substring by dropping the autocomplete characters
        let subString = formatSubstring(subString: subString1)  //what's actually typed
        if(subString1 == "") {
            DispatchQueue.main.async {
                textField.text = ""
            }
            
            return true
        }
        
        self.currentText = subString
        if(self.currentText.count == 0) {
            self.resetAll()
            DispatchQueue.main.async {
                textField.text = ""
            }
            return true
        }
        
        if(DataManager.isConnectedToNetwork() == true) {
            weak var weakSelf = self
            DataManager.instance.getUsernameSuggestions(substring: self.currentText, complete: {(temp:[String]) in
                Alerter.hidePreloader()
                weakSelf?.autocompletePossibilities = temp
                //weakSelf?.possibilitiesUpdated()
            })
        }
        
        
        if self.currentText.count == 0 {
            self.resetValues()
        } else {
            self.searchForAutocomplete(userQuery: self.currentText)
        }
        
        
        return true
    }
    
    /************************************************************************/
    /************************************************************************/
    //MARK:- Callbacks
    /**
     A callback from
     */
    public func possibilitiesUpdated() {
        
        if self.currentText.count == 0 {
            self.resetValues()
        } else {
            self.searchForAutocomplete(userQuery: self.currentText)
        }
        
    }
    
    
    /************************************************************************/
    /************************************************************************/
    //MARK:- Utils
    /**
     Format the string by dropping the last autoCompleteCharacterCount characters
     */
    func formatSubstring(subString: String) -> String {
        let formatted = String(subString.dropLast(autoCompleteCharacterCount))//.lowercased().capitalized
        print("Formatted: \(formatted)")
        return formatted
    }
    
    /**
     Reset the autocomplete characters and the textField text
     */
    func resetValues() {
        autoCompleteCharacterCount = 0
    }
    
    func resetAll() {
        autoCompleteCharacterCount = 0
        self.autocompletePossibilities = [String]()
    }
    
    /************************************************************************/
    /************************************************************************/
    //MARK:- Search
    /**
     Search for autocomplete possibility
     @param substring:String - The substring to search for
     */
    func searchForAutocomplete(userQuery: String) {
        
        let fieldString = self.textField?.text ?? ""
        
        //Redeclare to lowercase
        let userQuery = userQuery.lowercased()
        
        if self.autocompletePossibilities.count > 0 {
            
            let result = self.autocompletePossibilities[0]
            
            
            var remainderString = ""
            if(result.hasPrefix(userQuery)) {
                
                
                if let substringRange = result.range(of: userQuery)
                {
                    remainderString = result
                    remainderString.removeSubrange(substringRange)
                }
                
                
                
                timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in
                    self.putColourFormattedTextInTextField(autocompleteResult: remainderString, userQuery: userQuery)
                    self.moveCaretToEndOfUserQueryPosition(userQuery: userQuery)
                })
                
                
                
            }
            else {
                
                
                
                //let subString = formatSubstring(subString: fieldString)
                let formatted = String(fieldString.dropLast(autoCompleteCharacterCount))
                
                
                
                weak var weakself = self
                DispatchQueue.main.async {
                    weakself?.textField.text = formatted
                }
                
                timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in
                    //self.moveCaretToEndOfUserQueryPosition(userQuery: formatted)
                })
                self.resetValues()
            }
            
            
            
            //let index = autocompleteResult.index(autocompleteResult.startIndex, offsetBy: fieldString.count)..<autocompleteResult.endIndex
            //let newString = autocompleteResult.removeSubrange(index)
            
           
            
            autoCompleteCharacterCount = remainderString.count
            
            /*
             timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in
             
             let autocompleteResult = self.formatAutocompleteResult(substring: substring, possibleMatches: suggestions)
             self.putColourFormattedTextInTextField(autocompleteResult: autocompleteResult, userQuery : userQuery)
             self.moveCaretToEndOfUserQueryPosition(userQuery: userQuery)
             
             })
             */
        } else {
            //timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in //7
            //self.textField.text = substring
            //})
            
            
            putColourFormattedTextInTextField(autocompleteResult: "", userQuery: fieldString)
            autoCompleteCharacterCount = 0
        }
        
    }
    
    /**
     Get an autocomplete suggestion for the user provided text
     @param userText:String - the text to auto complete
     */
    func getAutocompleteSuggestions(userText: String) -> [String]{
        var possibleMatches: [String] = []
        
        for item in autocompletePossibilities {
            
            let myString:NSString! = item as NSString
            let substringRange :NSRange! = myString.range(of: userText)
            if (substringRange.location == 0)
            {
                possibleMatches.append(item)
            }
            
        }
        return possibleMatches
    }
    
    
    /************************************************************************/
    /************************************************************************/
    //MARK:- Colored text
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
    
    
    
}
