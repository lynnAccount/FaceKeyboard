//
//  EmoticonPackage.swift
//  01-表情键盘
//
//  Created by 刘凡 on 15/10/23.
//  Copyright © 2015年 joyios. All rights reserved.
//

import Foundation

/// 表情包模型
class EmoticonPackage: NSObject {
    
    /// 表情包路径名，浪小花的数据需要修改
    var id: String?
    /// 表情包名称
    var group_name_cn: String?
    /// 表情包数组
    lazy var emoticons = [Emoticon]()
    
    init(dict: [String: AnyObject]) {
        super.init()
        
        id = dict["id"] as? String
        group_name_cn = dict["group_name_cn"] as? String

        if let array = dict["emoticons"] as? [[String: String]] {
            var index = 0

            for var d in array {
                if let png = d["png"], let dir = id {
                    d["png"] = dir + "/" + png
                }
                
                emoticons.append(Emoticon(dict: d))
                
                // 追加删除按钮
                if ++index == 20 {
                    emoticons.append(Emoticon(isRemoved: true))
                    index = 0
                }
            }
        }
        
        appendEmptyButton()
    }
    
    /// 追加空白按钮
    private func appendEmptyButton() {
        let count = emoticons.count % 21
        
        print("数组剩余按钮 \(count)")
        
        if emoticons.count > 0 && count == 0 {
            return
        }
        
        for _ in count..<20 {
            emoticons.append(Emoticon(isEmpty: true))
        }
        // 末尾追加删除按钮
        emoticons.append(Emoticon(isRemoved: true))
    }
    
    override var description: String {
        let keys = ["id", "group_name_cn", "emoticons"]
        
        return dictionaryWithValuesForKeys(keys).description
    }
}
