//
//  PageViewController.swift
//  FriendFeedRxSwift
//
//  Created by Long Tran on 11/05/2023.
//

import UIKit
import RxSwift
import RxCocoa

class PageViewController: UIPageViewController {
    
    let bag = DisposeBag()
    
    var currentIndex = 0
    
    let pageInvitationVC = PageViewViewController.getInstance(index: 0)
    let pageSuggestFriendVC = PageViewViewController.getInstance(index: 1)
    let pageFriendVC = PageViewViewController.getInstance(index: 2)
    let pageSentVC = PageViewViewController.getInstance(index: 3)
    
    var pageViewControllerList: [UIViewController] = []
    
    let searchSubject = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewControllerList = [pageInvitationVC, pageSuggestFriendVC, pageFriendVC, pageSentVC]
        setViewControllers([pageViewControllerList[0]], direction: .forward, animated: true)
        getSearchResults()
        addFriend()
        addSent()
    }
    
    func getSearchResults() {
        searchSubject.subscribe(onNext: { [self] text in
            pageInvitationVC.invitationViewModel.getSearchResults(searchText: text)
            pageSuggestFriendVC.invitationViewModel.getSearchResults(searchText: text)
            pageFriendVC.friendViewModel.getSearchResults(searchText: text)
            pageSentVC.friendViewModel.getSearchResults(searchText: text)
        }).disposed(by: bag)
        setupPageTitleLabel()
    }
    
    func changePageView(index: Int) {
        let direction: UIPageViewController.NavigationDirection
        if currentIndex < index {
            direction = .forward
        }
        else {
            direction = .reverse
        }
        setViewControllers([pageViewControllerList[index]], direction: direction, animated: true)
        currentIndex = index
    }
    
    func addFriend() {
        pageInvitationVC.addUserFriendModelSubject.subscribe(onNext: {model in
            self.pageFriendVC.friendViewModel.addModel(model: model)
            self.setupPageTitleLabel()
        }).disposed(by: bag)
    }
    
    func addSent() {
        pageSuggestFriendVC.addUserFriendModelSubject.subscribe(onNext: {model in
            self.pageSentVC.friendViewModel.addModel(model: model)
            self.setupPageTitleLabel()
        }).disposed(by: bag)
    }
    
    func setupPageTitleLabel() {
        pageInvitationVC.setupTitleLabelText()
        pageSuggestFriendVC.setupTitleLabelText()
        pageFriendVC.setupTitleLabelText()
        pageSentVC.setupTitleLabelText()
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
