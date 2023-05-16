//
//  CollectionViewHeader.swift
//  FriendFeedRxSwift
//
//  Created by Long Tran on 11/05/2023.
//

import UIKit
import RxCocoa
import RxSwift

class CollectionViewHeader: UIView {
        
    let bag = DisposeBag()

    let titleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 363, height: 40), collectionViewLayout: layout)
        cv.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        return cv
    }()
    
    let selectedItemSubject = PublishSubject<Int>()
    
    let data = ["Lời mời", "Gợi ý kết bạn", "Bạn bè", "Đã gửi"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bindCollectionView()
        setupUI()
        selectItemTitleCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        bindCollectionView()
        setupUI()
        selectItemTitleCollectionView()
    }
    
    func setupUI() {
        addSubview(titleCollectionView)
        titleCollectionView.rx.setDelegate(self).disposed(by: bag)
        titleCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .top)
    }
    
    func bindCollectionView() {
        let titles = Observable.of(data)
        titles.bind(to: titleCollectionView.rx.items(cellIdentifier: "CollectionViewCell", cellType: CollectionViewCell.self)) { (row, item, cell) in
            cell.label.text = item
            cell.setUpCell()
        }.disposed(by: bag)
    }
    
    func selectItemTitleCollectionView() {
        titleCollectionView.rx.itemSelected.subscribe(
            onNext: { indexPath in
                if let cell = self.titleCollectionView.cellForItem(at: indexPath) as? CollectionViewCell {
                    cell.setUpCell()
                }
                self.selectedItemSubject.onNext(indexPath.row)
            }
        ).disposed(by: bag)
        titleCollectionView.rx.itemDeselected.subscribe(
            onNext: { indexPath in
                if let cell = self.titleCollectionView.cellForItem(at: indexPath) as? CollectionViewCell {
                    cell.setUpCell()
                }
            }
        ).disposed(by: bag)
    }
    
}

extension CollectionViewHeader: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = data[indexPath.row]
        label.sizeToFit()
        return CGSize(width: label.frame.width + 6, height: 30)
    }
}
