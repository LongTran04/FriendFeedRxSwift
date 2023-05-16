//
//  PageViewViewController.swift
//  FriendFeedRxSwift
//
//  Created by Long Tran on 11/05/2023.
//

import UIKit
import RxSwift
import RxCocoa

class PageViewViewController: UIViewController {

    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var pageTableView: UITableView!
    
    let bag = DisposeBag()
    
    var currentIndex = 0
    
    var invitationViewModel = InvitationViewModel()
    var friendViewModel = FriendViewModel()
            
    let titleLabelTextSubject = PublishSubject<String>()
    let addUserFriendModelSubject = PublishSubject<UserFriendModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabelTextSubject.bind(to: pageTitleLabel.rx.text).disposed(by: bag)
        setupUI()
    }
    
    static func getInstance(index: Int) -> PageViewViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PageViewViewController") as! PageViewViewController
        vc.currentIndex = index
        vc.readData(currentIndex: index)
        return vc
    }
    
    func setupUI() {
        setupTitleLabelText()
        pageTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        bindTableView()
        pageTableView.rx.setDelegate(self).disposed(by: bag)
    }
    
    func readData(currentIndex: Int) {
        switch currentIndex {
        case 0:
            invitationViewModel.readJSONFile(fileName: "invitation")
        case 1:
            invitationViewModel.readJSONFile(fileName: "suggestFriend")
        case 2:
            friendViewModel.readJSONFile(fileName: "Friend")
        default:
            friendViewModel.readJSONFile(fileName: "Sent")
        }
    }
    
    func setupTitleLabelText() {
        guard let invitationCount = try? invitationViewModel.filterModels.value().count else {return}
        guard let friendCount = try? friendViewModel.filterModels.value().count else {return}
        if ViewController.isExitSearchButtonHiden {
            switch currentIndex {
            case 0:
                titleLabelTextSubject.onNext("\(invitationCount) lời mời kết bạn")
            case 1:
                titleLabelTextSubject.onNext("Gợi ý kết bạn")
            case 2:
                titleLabelTextSubject.onNext("\(friendCount) người bạn")
            default:
                titleLabelTextSubject.onNext("\(friendCount) lời mời đã gửi")
            }
        }
        else {
            switch currentIndex {
            case 0:
                titleLabelTextSubject.onNext("Lời mời kết bạn")
            case 1:
                titleLabelTextSubject.onNext("Gợi ý kết bạn")
            case 2:
                titleLabelTextSubject.onNext("Bạn bè")
            default:
                titleLabelTextSubject.onNext("Lời mời đã gửi")
            }
        }
        
    }
    
    func bindInvitationViewModelTableView() {
        invitationViewModel.filterModels.bind(to: pageTableView.rx.items(cellIdentifier: "TableViewCell", cellType: TableViewCell.self)) { (row, item, cell) in
            cell.setupCell(currentIndex: self.currentIndex, data: item)
            cell.tapDeleteButtonSubject.subscribe(onNext: { model in
                self.invitationViewModel.deleteModel(model: model)
                self.setupTitleLabelText()
            }).disposed(by: cell.bag)
            cell.tapAddFriendButtonSubject.subscribe(onNext: { model in
                let userFriendModel = self.invitationViewModel.convertInvitaionToFriendModel(model: model)
                self.addUserFriendModelSubject.onNext(userFriendModel)
                self.invitationViewModel.deleteModel(model: model)
                self.setupTitleLabelText()
            }).disposed(by: cell.bag)
        }.disposed(by: bag)
    }
    
    func bindFriendViewModelTableView() {
        friendViewModel.filterModels.bind(to: pageTableView.rx.items(cellIdentifier: "TableViewCell", cellType: TableViewCell.self)) { (row, item, cell) in
            cell.setupCell(currentIndex: self.currentIndex, data: item)
            cell.tapTrashButtonSubject.subscribe(onNext: { model in
                self.friendViewModel.deleteModel(model: model)
                self.setupTitleLabelText()
            }).disposed(by: cell.bag)
        }.disposed(by: bag)
    }
    
    func bindTableView() {
        switch currentIndex {
        case 0,1:
            bindInvitationViewModelTableView()
        default:
            bindFriendViewModelTableView()
        }
    }

}

extension PageViewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch currentIndex {
        case 0,1:
            return 120
        default:
            return 85
        }
    }
}
