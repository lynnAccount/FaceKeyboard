//
//  AppDelegate.swift
//  01-表情键盘
//
//  Created by lynn on 16/3/23.
//  Copyright © 2016年 joyios. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    /// 表情键盘视图
    private lazy var emoticonView: EmoticonView = EmoticonView { [weak self] (emoticon) -> () in
        self?.textView.insertEmoticon(emoticon)
    }

    /// 显示完整的表情文字
    @IBAction func emoticonText(sender: AnyObject) {
        print(textView.emoticonText)
    }
    
    @IBOutlet weak var textView: UITextView!
    
    deinit {
        print("88")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.inputView = emoticonView
        textView.becomeFirstResponder()
        
        print(EmoticonManager.sharedManager)
        print(EmoticonManager.sharedManager)
    }
}

