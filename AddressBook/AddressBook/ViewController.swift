//
//  ViewController.swift
//  AddressBook
//
//  Created by jieku on 2017/6/16.
//  Copyright © 2017年 jieku. All rights reserved.
//

import UIKit
import ContactsUI
import MJExtension

class ViewController: UIViewController {
    
    fileprivate lazy var AddressBookTableview : UITableView = {[weak self] in
        
        let AddressBookTableview        = UITableView.init(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
        AddressBookTableview.delegate   = self
        AddressBookTableview.dataSource = self
        AddressBookTableview.backgroundColor = UIColor.clear
        AddressBookTableview.tableFooterView = UIView.init()
        AddressBookTableview.separatorStyle  = UITableViewCellSeparatorStyle.singleLine
        AddressBookTableview.rowHeight       = 60.0
        return  AddressBookTableview
        }()
    
    fileprivate var  AuthorStore = CNContactStore.init()
    fileprivate var iphoneSouceArray = NSMutableArray.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "通讯录"
        view.addSubview(AddressBookTableview)
        
        AuthorAddressBook()  //load Contact Book
    }
}

extension ViewController {   //author AddressBook
    
    fileprivate func AuthorAddressBook() {
        let AuthorStatue = CNContactStore.authorizationStatus(for: CNEntityType.contacts)      //init Contact
        
        guard AuthorStatue == CNAuthorizationStatus.authorized else {           //access contact data.
            
            if AuthorStatue == CNAuthorizationStatus.notDetermined {         //user has not yet made a choice
                
                AuthorStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (isAuthor, error) in
                    
                    if isAuthor == true {   // access contact data
                        self.loadAddressPerson()
                    }else{
                        print("user has not  access")
                    }
                })
            }
            return
        }
        loadAddressPerson()
    }
}

extension ViewController {  //load Contact Book
    
    fileprivate func loadAddressPerson() {
        
        DispatchQueue(label: "loadAddressBook", qos: DispatchQoS.utility, attributes: .concurrent).sync(execute: {
            
            let keys = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey];
            let request = CNContactFetchRequest.init(keysToFetch: keys as [CNKeyDescriptor]);
            
            try?AuthorStore.enumerateContacts(with: request, usingBlock: { (contact, iStop) in

                let contactModel = AddressBookModel.init()
                let contactNickname = contact.familyName    //First name
                let lastName = contact.givenName;           //last name
                contactModel.contactNickname = contactNickname
                contactModel.givenName = lastName
                
                let iphoneNumbers = contact.phoneNumbers    //号码 stringValue ，label 住宅字段
                for item in iphoneNumbers{
                    let numbers = item as CNLabeledValue
                    let phoneNumber = numbers.value.stringValue
                    contactModel.iphoneNumbers = phoneNumber
                }
                self.iphoneSouceArray.add(contactModel)
            });
            
            DispatchQueue.main.async {          //main reload UI
                self.AddressBookTableview.reloadData()
            }
        })
    }
}

extension ViewController {
    
    fileprivate  func getFirstLetterFromString(aString: String) -> (String) { //返回大写首字母
        
        if aString.characters.count > 0 {
            let mutableString = NSMutableString.init(string: aString)
            CFStringTransform(mutableString as CFMutableString, nil, kCFStringTransformToLatin, false)
            let pi1wnyinString = mutableString.folding(options: String.CompareOptions.diacriticInsensitive, locale: NSLocale.current)
            let strPinYin = polyphoneStringHandle(nameString: aString, pinyinString: pi1wnyinString).uppercased()
            let firstString = strPinYin.substring(to: strPinYin.index(strPinYin.startIndex, offsetBy:1))
            let regexA = "^[A-Z]$"
            let predA = NSPredicate.init(format: "SELF MATCHES %@", regexA)
            return predA.evaluate(with: firstString) ? firstString : "#"
        }else {
            return "#"
        }
    }
    
    fileprivate func polyphoneStringHandle(nameString:String, pinyinString:String) -> String {   //多音字处理
        if nameString.hasPrefix("长") {return "chang"}
        if nameString.hasPrefix("沈") {return "shen"}
        if nameString.hasPrefix("厦") {return "xia"}
        if nameString.hasPrefix("地") {return "di"}
        if nameString.hasPrefix("重") {return "chong"}
        return pinyinString;
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.iphoneSouceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        var cell = tableView.dequeueReusableCell(withIdentifier:NSStringFromClass(AddressBookTableViewCell.self)) as?AddressBookTableViewCell
        if cell == nil {
            cell = AddressBookTableViewCell.init(style: .default, reuseIdentifier: NSStringFromClass(AddressBookTableViewCell.self))
        }
        
        cell?.BookModel = self.iphoneSouceArray[indexPath.row] as? AddressBookModel
        return cell!
    }
}

// 预加载 scrollViewDidScroll  _page  + =1 解决 卡顿问题 ; +(void)load 程序刚启动的时候调用，



