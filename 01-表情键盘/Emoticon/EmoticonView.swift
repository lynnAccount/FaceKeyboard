//
//  AppDelegate.swift
//  01-表情键盘
//
//  Created by lynn on 16/3/23.
//  Copyright © 2016年 joyios. All rights reserved.
//

import UIKit

/// 可重用标识符号
private let EmoticonViewCellId = "EmoticonViewCellId"

/// 表情键盘视图
class EmoticonView: UIView {
    
    /// 选中表情回调函数
    private var selectedEmoticonCallBack: (emoticon: Emoticon) -> ()
    
    // MARK: - 监听方法
    /// 点击工具栏 item
    @objc private func clickItem(item: UIBarButtonItem) {
        let indexPath = NSIndexPath(forItem: 0, inSection: item.tag)
        
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: true)
    }
    
    // MARK: - 构造函数
    init(selectedEmoticon: (emoticon: Emoticon) -> ()) {
        self.selectedEmoticonCallBack = selectedEmoticon
        
        var rect = UIScreen.mainScreen().bounds
        rect.size.height = 216
        
        super.init(frame: rect)
        
        // 设置控件
        setupUI()
        
        // 跳转到默认分组
        let indexPath = NSIndexPath(forItem: 0, inSection: 1)
        dispatch_async(dispatch_get_main_queue()) {
            self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: false)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载控件
    /// 表情包数组
    private lazy var packages = EmoticonManager.sharedManager.packages
    /// 表情集合视图
    private lazy var collectionView = UICollectionView(frame: CGRectZero,
        collectionViewLayout: EmoticonViewLayout())
    /// 工具栏
    private lazy var toolbar = UIToolbar()
    
    /// 表情键盘视图布局
    private class EmoticonViewLayout: UICollectionViewFlowLayout {
        
        private override func prepareLayout() {
            super.prepareLayout()
            
            let col: CGFloat = 7
            let row: CGFloat = 3
            
            let w = collectionView!.bounds.width / col
            let margin = CGFloat(Int((collectionView!.bounds.height - row * w) * 0.5))
            
            itemSize = CGSize(width: w, height: w)
            minimumInteritemSpacing = 0
            minimumLineSpacing = 0
            sectionInset = UIEdgeInsets(top: margin, left: 0, bottom: margin, right: 0)
            
            scrollDirection = .Horizontal
            collectionView?.pagingEnabled = true
            collectionView?.bounces = false
        }
    }
}

// MARK: - UICollectionViewDataSource
extension EmoticonView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    /// 表情包数量
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return packages.count
    }

    /// 表情包中的表情数量
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(EmoticonViewCellId, forIndexPath: indexPath) as! EmoticonViewCell
        
        cell.emoticon = packages[indexPath.section].emoticons[indexPath.item]

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let em = packages[indexPath.section].emoticons[indexPath.item]
        
        selectedEmoticonCallBack(emoticon: em)
        
        // 添加最近使用的表情
        if indexPath.section > 0 {
            EmoticonManager.sharedManager.addFavorite(em)
        }
    }
}

// MARK: - 设置界面
private extension EmoticonView {
    
    func setupUI() {
        backgroundColor = UIColor.whiteColor()
        
        // 1. 添加控件
        addSubview(collectionView)
        addSubview(toolbar)
        
        // 2. 自动布局
        toolbar.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.snp_bottom)
            make.left.equalTo(self.snp_left)
            make.right.equalTo(self.snp_right)
            make.height.equalTo(36)
        }
        collectionView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp_top)
            make.bottom.equalTo(toolbar.snp_top)
            make.left.equalTo(self.snp_left)
            make.right.equalTo(self.snp_right)
        }
        
        // 3. 准备控件
        prepareToolbar()
        prepareCollectionView()
    }
    
    /// 准备工具栏
    func prepareToolbar() {
        tintColor = UIColor.darkGrayColor()
        
        var items = [UIBarButtonItem]()
        var index = 0
        for p in packages {
            let item = UIBarButtonItem(title: p.group_name_cn, style: .Plain, target: self, action: "clickItem:")
            items.append(item)
            items.last?.tag = index++
            items.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        
        toolbar.items = items
    }
    
    /// 准备表情集合视图
    func prepareCollectionView() {
        collectionView.backgroundColor = UIColor.whiteColor()
        
        // 注册 Cell
        collectionView.registerClass(EmoticonViewCell.self, forCellWithReuseIdentifier: EmoticonViewCellId)
        // 指定数据源
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - 表情 Cell
private class EmoticonViewCell: UICollectionViewCell {
 
    /// 表情符号
    var emoticon: Emoticon? {
        didSet {
            emoticonButton.setImage(UIImage(contentsOfFile: emoticon!.imagePath), forState: .Normal)
            emoticonButton.setTitle(emoticon?.emoji, forState: .Normal)
            
            // 是否删除按钮
            if emoticon!.isRemoved {
                emoticonButton.setImage(UIImage(named: "compose_emotion_delete"), forState: .Normal)
            }
        }
    }
    
    // MARK: - 搭建界面
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(emoticonButton)
        emoticonButton.backgroundColor = UIColor.whiteColor()
        emoticonButton.titleLabel?.font = UIFont.systemFontOfSize(32)
        emoticonButton.frame = CGRectInset(bounds, 4, 4)
        emoticonButton.userInteractionEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载控件
    /// 表情按钮
    private lazy var emoticonButton: UIButton = UIButton()
}