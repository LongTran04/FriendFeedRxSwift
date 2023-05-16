//
//  TableViewCell.swift
//  FriendFeedRxSwift
//
//  Created by Long Tran on 12/05/2023.
//

import UIKit
import RxCocoa
import RxSwift

class TableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userCompanyLabel: UILabel!
    @IBOutlet weak var userDepartmentLabel: UILabel!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var addFriendButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    
    var bag = DisposeBag()
    
    let tapAddFriendButtonSubject = PublishSubject<UserInvitationModel>()
    let tapDeleteButtonSubject = PublishSubject<UserInvitationModel>()
    let tapTrashButtonSubject = PublishSubject<UserFriendModel>()
        
    override func awakeFromNib() {
        super.awakeFromNib()
        addFriendButton.layer.cornerRadius = 10
        deleteButton.layer.cornerRadius = 10
        userImageView.clipsToBounds = true
        userImageView.layer.borderWidth = 2
        userImageView.layer.borderColor = UIColor.white.cgColor
        userImageView.layer.cornerRadius = userImageView.frame.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    func setupFriendCell(data: UserFriendModel) {
        if data.avatar == "" {
            userImageView.image = UIImage(systemName: "person.circle.fill")
        }
        else {
            userImageView.load(urlString: data.avatar)
        }
        setupUserNameLabel(text: data.displayName)
        let info: Info = data.info
        if info.work.count < 1 {
            userCompanyLabel.text = ""
            userDepartmentLabel.text = ""
        }
        else {
            userCompanyLabel.text = info.work[0].company
            let department = info.work[0].department ?? ""
            userDepartmentLabel.text = department
        }
        buttonStackView.isHidden = true
        tapTrashButton(model: data)
    }
    
    func setupInvitationCell(data: UserInvitationModel) {
        let urlUserImageView = data.avatar
        if urlUserImageView == "" {
            userImageView.image = UIImage(systemName: "person.circle.fill")
        }
        else {
            userImageView.load(urlString: urlUserImageView)
        }
        setupUserNameLabel(text: data.displayName)
        userCompanyLabel.text = data.work[0].company
        userDepartmentLabel.text = data.work[0].department
        trashButton.isHidden = true
        chatButton.isHidden = true
        tapAddFriendButton(model: data)
        tapDeleteButton(model: data)
    }
    
    func setupUserNameLabel(text: String) {
        if ViewController.isExitSearchButtonHiden {
            userNameLabel.highlightText(text, in: text)
        }
        else {
            if ViewController.searchText == "" {
                userNameLabel.highlightText(text, in: text)
            }
            else {
                userNameLabel.highlightSearchText(ViewController.searchText, in: text)
            }
        }
    }
    
    func setupCell<T>(currentIndex: Int, data: T) {
        switch currentIndex {
        case 0,1:
            setupInvitationCell(data: data as! UserInvitationModel)
        case 2:
            setupFriendCell(data: data as! UserFriendModel)
            trashButton.isHidden = true
        default:
            setupFriendCell(data: data as! UserFriendModel)
            chatButton.isHidden = true
        }
    }
    
    func tapAddFriendButton(model: UserInvitationModel) {
        addFriendButton.rx.tap.subscribe(onNext: {
            self.tapAddFriendButtonSubject.onNext(model)
        }).disposed(by: bag)
    }
    
    func tapDeleteButton(model: UserInvitationModel) {
        deleteButton.rx.tap.subscribe(onNext: {
            self.tapDeleteButtonSubject.onNext(model)
        }).disposed(by: bag)
    }
    
    func tapTrashButton(model: UserFriendModel) {
        trashButton.rx.tap.subscribe(onNext: {
            self.tapTrashButtonSubject.onNext(model)
        }).disposed(by: bag)
    }

}


