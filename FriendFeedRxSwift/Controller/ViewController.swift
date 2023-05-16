//
//  ViewController.swift
//  FriendFeedRxSwift
//
//  Created by Long Tran on 11/05/2023.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var exitSearchButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionViewHeader: CollectionViewHeader!
    
    let bag = DisposeBag()
    let pageView = PageViewController()
    
    static var isExitSearchButtonHiden: Bool = true
    static var searchText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exitSearchButton.isHidden = true
        ViewController.isExitSearchButtonHiden = self.exitSearchButton.isHidden
        containerView.addSubview(pageView.view)
        tapExitSearchButton()
        tapSearchBar()
        editTextSearchBar()
        selectedItemCollectionViewHeader()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.layer.borderWidth = 1
        containerView.addSubview(pageView.view)
    }
    
    func tapExitSearchButton() {
        exitSearchButton.rx.tap.subscribe(
            onNext: {
                self.exitSearchButton.isHidden = true
                ViewController.isExitSearchButtonHiden = self.exitSearchButton.isHidden
                self.searchBar.resignFirstResponder()
                self.searchBar.text = ""
                ViewController.searchText = ""
                self.pageView.searchSubject.onNext("")
                self.pageView.setupPageTitleLabel()
            }
        ).disposed(by: bag)
    }
    
    func tapSearchBar() {
        searchBar.delegate = self
        searchBar.rx.textDidBeginEditing.subscribe(
            onNext: {
                self.exitSearchButton.isHidden = false
                ViewController.isExitSearchButtonHiden = self.exitSearchButton.isHidden
                self.pageView.setupPageTitleLabel()
            }
        ).disposed(by: bag)
    }
    
    func editTextSearchBar() {
        searchBar.rx.text.subscribe(onNext: {text in
            self.pageView.searchSubject.onNext(text ?? "")
            ViewController.searchText = text ?? ""
        }).disposed(by: bag)
    }
    
    func selectedItemCollectionViewHeader() {
        collectionViewHeader.selectedItemSubject.subscribe(onNext: {index in
            self.pageView.changePageView(index: index)
        }).disposed(by: bag)
    }
}

