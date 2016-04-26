//
//  AppDelegate.swift
//  01-表情键盘
//
//  Created by lynn on 16/3/23.
//  Copyright © 2016年 joyios. All rights reserved.
//
import Foundation

/// 表情包管理器
class EmoticonManager {
    
    /// 单例
    static let sharedManager = EmoticonManager()
    
    /// 表情包数组
    lazy var packages = [EmoticonPackage]()
    
    /// 添加最近表情符号
    func addFavorite(em: Emoticon) {
        em.times++
        
        // 判断是否在最近分组
        if !packages[0].emoticons.contains(em) {
            packages[0].emoticons.insert(em, atIndex: 0)
            // 删除倒数第二个表情
            packages[0].emoticons.removeAtIndex(packages[0].emoticons.count - 2)
        }
        
        // 排序
        packages[0].emoticons.sortInPlace { $0.times > $1.times }
        
        print(packages[0].emoticons as NSArray)
    }
    
    // MARK: - 构造函数
    private init() {
        // 0. 添加最近分组
        packages.append(EmoticonPackage(dict: ["group_name_cn": "最近"]))
        
        // 1. emoticons.plist 路径
        guard let path = NSBundle.mainBundle().pathForResource("emoticons", ofType: "plist", inDirectory: "Emoticons.bundle") else {
            print("emoticons 文件不存在")
            return
        }
        
        // 2. 加载字典
        guard let dict = NSDictionary(contentsOfFile: path) else {
            print("数据加载错误")
            return
        }
        
        // 3. 提取 packages 中的 id 字符串对应的数组
        let array = (dict["packages"] as! NSArray).valueForKey("id") as! [String]
        
        // 4. 遍历数组，字典转模型
        for id in array {
            loadInfoPlist(id)
        }
        
        print(packages)
    }

    /// 加载 id 目录下的 info.plist 文件
    private func loadInfoPlist(id: String) {
        // 1. 创建路径
        let path = NSBundle.mainBundle().pathForResource("info", ofType: "plist", inDirectory: "Emoticons.bundle/\(id)")!
        
        // 2. 加载字典
        let dict = NSDictionary(contentsOfFile: path) as! [String: AnyObject]
        
        // 3. 字典转模型
        packages.append(EmoticonPackage(dict: dict))
    }
}