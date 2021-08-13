//
//  MainViewController.swift
//  TableCollectionFeatures
//
//  Created by Alexander Khiger on 28.06.2021.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import SwifterSwift

class MainViewController: BaseViewController {
    
    // MARK: Важно выставить allowsMultipleSelection для множественного выбора
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.allowsMultipleSelection = true
        view.alwaysBounceVertical = true
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    private func configureView() {
        title = "Главная"
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        
        collectionView.register(cellWithClass: ExpandableCell.self)
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withClass: ExpandableCell.self, for: indexPath)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        5
    }
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: Фиксированная высота ячеек - 50 в свернутом и 150 в развернутом состояниях
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let isSelected = collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
        return CGSize(width: collectionView.bounds.width - 40, height: isSelected ? 150 : 50)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        24
    }
    
}

extension MainViewController: UICollectionViewDelegate {
    
    // MARK: Переопределяем метод для анимированного сворачивания ячейки
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        collectionView.deselectItem(at: indexPath, animated: true)
        collectionView.performBatchUpdates(nil)
        return true
    }
    
    // MARK: Переопределяем метод для анимированного разворачивания ячейки
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        collectionView.performBatchUpdates(nil)
        return true
    }
    
}
