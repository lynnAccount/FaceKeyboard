//
//  AppDelegate.swift
//  01-表情键盘
//
//  Created by lynn on 16/3/23.
//  Copyright © 2016年 joyios. All rights reserved.
//

import UIKit

/// 表情文本附件
class EmoticonAttachment: NSTextAttachment {

    var chs: String?
    
    /// 使用指定的表情符号，生成属性文本，并在附件中记录表情符号文本
    ///
    /// - parameter em:     表情符号模型
    /// - parameter font:   字体
    ///
    /// - returns: 属性字符串
    class func imageText(em: Emoticon, font: UIFont) -> NSAttributedString {
        let attachment = EmoticonAttachment()
        attachment.chs = em.chs
        
        attachment.image = UIImage(contentsOfFile: em.imagePath)
        let lineHeight = font.lineHeight
        attachment.bounds = CGRect(x: 0, y: -4, width: lineHeight, height: lineHeight)
        
        // 创建可变属性文本
        let imageText = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        // 添加字体
        imageText.addAttribute(NSFontAttributeName, value: font, range: NSRange(location: 0, length: 1))
        
        return imageText
    }
}
