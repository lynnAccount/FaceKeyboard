//
//  Emoticon.swift
//  01-表情键盘
//
//  Created by 刘凡 on 15/10/23.
//  Copyright © 2015年 joyios. All rights reserved.
//

import UIKit

/// 表情模型
class Emoticon: NSObject {
    
    /// 表情文字
    var chs: String?
    /// 表情图片文件名
    var png: String?
    /// 完整的图像路径
    var imagePath: String {
        return png == nil ? "" : NSBundle.mainBundle().bundlePath + "/Emoticons.bundle/" + png!
    }
    /// emoji 编码
    var code: String? {
        didSet {
            emoji = code?.emoji
        }
    }
    /// emoji 字符串
    var emoji: String?
    /// 是否删除按钮
    var isRemoved = false
    /// 是否空白按钮
    var isEmpty = false
    /// 使用次数
    var times = 0

    // MARK: - 构造函数
    init(isEmpty: Bool) {
        self.isEmpty = isEmpty
    }

    init(isRemoved: Bool) {
        self.isRemoved = isRemoved
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    override var description: String {
        let keys = ["chs", "png", "code", "emoji", "isRemoved"]
        
        return dictionaryWithValuesForKeys(keys).description
    }
}
