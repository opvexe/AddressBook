//
//  AddressBookTableViewCell.swift
//  AddressBook
//
//  Created by jieku on 2017/6/16.
//  Copyright © 2017年 jieku. All rights reserved.
//

import UIKit
import SnapKit

class AddressBookTableViewCell: UITableViewCell {
    
    fileprivate var username = UILabel.init()
    fileprivate var iphoneNumber = UILabel.init()
    
    var BookModel : AddressBookModel?{
        didSet{
            
            username.text = String.init(format: "%@%@", (BookModel?.contactNickname)!,(BookModel?.givenName)!)
            iphoneNumber.text = BookModel?.iphoneNumbers
        }
    }
    
    override init(style:UITableViewCellStyle, reuseIdentifier:String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        setupSingleLabel(styleLabel: username, textColor: UIColor.black, fontSize: 16)
        setupSingleLabel(styleLabel: iphoneNumber, textColor: UIColor.lightGray, fontSize: 12)
        
        contentView.addSubview(username)
        contentView.addSubview(iphoneNumber)
        
        snapMagin()
    }
    
    fileprivate func snapMagin()  {
        
        username.snp.makeConstraints { (make) in
            make.left.top.equalTo(self.contentView).offset(10)
        }
        iphoneNumber.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.top.equalTo(username.snp.bottom).offset(10)
        }
    }
    fileprivate func setupSingleLabel(styleLabel: UILabel ,textColor:UIColor ,fontSize:CGFloat){
        styleLabel.textColor = textColor
        styleLabel.numberOfLines = 1
        styleLabel.textAlignment = NSTextAlignment.left
        styleLabel.font = UIFont.init(name: "PingFangSC-Regular", size: fontSize)
        styleLabel.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
