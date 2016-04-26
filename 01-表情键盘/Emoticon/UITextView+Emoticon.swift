//
//  AppDelegate.swift
//  01-表情键盘
//
//  Created by lynn on 16/3/23.
//  Copyright © 2016年 joyios. All rights reserved.
//

import UIKit

extension UITextView {
    
    /// 完整的属性文本字符串
    var emoticonText: String {
        
        var strM = String()
        
        let attrString = attributedText
        attrString.enumerateAttributesInRange(NSRange(location: 0, length: attrString.length), options: []) { dict, range, _ in
            
            if let attachment = dict["NSAttachment"] as? EmoticonAttachment {
                strM += attachment.chs ?? ""
            } else {
                strM += (attrString.string as NSString).substringWithRange(range)
            }
        }
        
        return strM
    }
    
    /// 插入表情符号
    ///
    /// - parameter em: 表情符号
    func insertEmoticon(em: Emoticon) {
        // 1. 空白表情
        if em.isEmpty {
            return
        }
        
        // 2. 删除按钮
        if em.isRemoved {
            deleteBackward()
            return
        }
        
        // 3. emoji
        if let emoji = em.emoji {
            replaceRange(selectedTextRange!, withText: emoji)
            return
        }
        
        // 4. 属性文本
        // 1> 创建图像附件文本
        let imageText = EmoticonAttachment.imageText(em, font: font!)
        
        // 2> 获取 textView 的属性文本
        let textM = NSMutableAttributedString(attributedString: attributedText)
        
        // 替换属性文本内容
        textM.replaceCharactersInRange(selectedRange, withAttributedString: imageText)
        
        // 3> 重新更新 textView 中的属性文本
        // 1) 记录光标位置
        let range = selectedRange
        // 2) 设置属性文本
        attributedText = textM
        // 3) 恢复光标位置
        selectedRange = NSRange(location: range.location + 1, length: 0)
    }
}
