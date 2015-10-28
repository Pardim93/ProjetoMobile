//
//  InserirTextView.swift
//  DesignTest
//
//  Created by Andre Lucas Ota on 22/09/15.
//  Copyright © 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

class InserirTextView: UITextView, UITextViewDelegate {
    
    var placeHolderActive = true
    var placeholder = ""
    var limitChar = 0
    var limitHeight: CGFloat = 0
    var enableScroll = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.configFont()
        self.configBorder()
        self.showsHorizontalScrollIndicator = false
//        self.contentSize = CGSizeMake(horizontalSize, self.contentSize.height)
    }
    
    override func willMoveToWindow(newWindow: UIWindow?) {
        if(self.placeHolderActive){
            self.insertPlaceHolder()
        }
    }

//    MARK: Config
    func configFont(){
        self.font = UIFont(name: "Avenir Book", size: 16)
    }
    
    func configBorder(){
        self.layer.borderWidth = 0.3
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.makeBlack()
    }
    
    func insertPlaceHolder(){
        self.placeHolderActive = true
        self.text = placeholder
        self.textColor = UIColor.lightGrayColor()
    }
    
    func removePlaceholder() {
        self.placeHolderActive = false
        self.text = ""
        self.textColor = UIColor.blackColor()
    }
    
//    MARK: Edition
    func textViewDidBeginEditing(textView: UITextView) {
        if(placeHolderActive){
            self.moveCursorToStart(self)
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (self.text.characters.count == 0){
            self.insertPlaceHolder()
        }
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        self.moveCursorToStart(self)
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        if (self.text == ""){
            self.insertPlaceHolder()
            self.moveCursorToStart(self)
        }
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        self.moveCursorToStart(self)
    }
    
    func moveCursorToStart(aTextView: UITextView){
        if(placeHolderActive){
            dispatch_async(dispatch_get_main_queue(), {
                aTextView.selectedRange = NSMakeRange(0, 0);
            })
        }
    }
    
    override func deleteBackward() {
        if (!placeHolderActive){
            super.deleteBackward()
        }
    }
    
//    override func selectionWillChange(textInput: UITextInput?) {
//        if(placeHolderActive){
//            self.moveCursorToStart(self)
//        }
//    }
    
//    MARK: Validation
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        var newText = textView.text as NSString
        newText = newText.stringByReplacingCharactersInRange(range, withString: text)
        
        if(newText != placeholder && newText != "" && placeHolderActive){
            self.removePlaceholder()
        } else{
            if(newText == placeholder || newText == ""){
                self.insertPlaceHolder()
            }
        }
        
        if(self.contentSize.height >= limitHeight && enableScroll && !scrollEnabled){
            self.scrollEnabled = true
            return true
        }
        
        if (self.contentSize.height > limitHeight && enableScroll){
            return true
        }
        
        scrollEnabled =  false
        
        return (((newText.length <= limitChar) && (self.contentSize.height < self.limitHeight)) || (text == ""))
    }
    
    func makeRed(){
        self.layer.borderColor = UIColor.redColor().CGColor
    }
    
    func makeBlack(){
        self.layer.borderColor = UIColor.blackColor().CGColor
    }
}
