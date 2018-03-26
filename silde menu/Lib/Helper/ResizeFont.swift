//
//  ResizeFont.swift
//  vHealth
//
//  Created by Sakkaphong Luaengvilai on 12/5/2559 BE.
//  Copyright © 2559 MaDonRa. All rights reserved.
//

import UIKit

class ResizeFont: NSObject {

    private var LabelArray = [UILabel]()
    private var TextFieldArray = [UITextField]()
    private var ButtonArray = [UIButton]()
    private var TextViewArray = [UITextView]()
    
    internal func LabelFontSizeArray (_ LabelArray:[UILabel]) {

        for Label in LabelArray {
            guard !self.LabelArray.contains(Label), let FontName = Label.font?.fontName else { return }
            Label.font = UIFont(name: FontName,size: CGFloat(Int(ScreenSize.SCREEN_HEIGHT/667 * Label.font.pointSize)))
            self.LabelArray.append(Label)
        }
    }
    
    internal func TextFieldFontSizeArray (_ TextFieldArray:[UITextField]) {
        
        for TextField in TextFieldArray {
            guard !self.TextFieldArray.contains(TextField), let TextFieldFont = TextField.font else { return }
            TextField.font = UIFont(name: TextFieldFont.fontName,size: CGFloat(Int(ScreenSize.SCREEN_HEIGHT/667 * TextFieldFont.pointSize)))
            self.TextFieldArray.append(TextField)
        }
    }
    
    internal func ButtonFontSizeArray (_ ButtonArray:[UIButton]) {
        
        for Button in ButtonArray {
            guard !self.ButtonArray.contains(Button), let ButtonFont = Button.titleLabel else { return }
            Button.titleLabel?.font = UIFont(name: ButtonFont.font.fontName , size: CGFloat(Int(ScreenSize.SCREEN_HEIGHT/667 * ButtonFont.font.pointSize)))
            self.ButtonArray.append(Button)
        }
    }
    
    internal func TextViewFontSizeArray (_ TextViewArray:[UITextView]) {
        
        for TextView in TextViewArray {
            guard !self.TextViewArray.contains(TextView), let TextViewFont = TextView.font else { return }
            TextView.font = UIFont(name: TextViewFont.fontName , size: CGFloat(Int(ScreenSize.SCREEN_HEIGHT/667 * TextViewFont.pointSize)))
            self.TextViewArray.append(TextView)
        }
    }
}
