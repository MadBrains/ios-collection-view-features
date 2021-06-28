//
//  ExpandableCell.swift
//  TableCollectionFeatures
//
//  Created by Alexander Khiger on 28.06.2021.
//

import UIKit
import SnapKit

class ExpandableCell: UICollectionViewCell {
    
    // MARK: Переопределяем isSelected, чтобы на каждое изменение вызывать updateAppearance()
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    // MARK: Констрейнт для расширенного состояния
    private var expandedConstraint: Constraint!
    
    // MARK: Констрейнт для сжатого состояния
    private var collapsedConstraint: Constraint!
    
    private lazy var mainContainer = UIView()
    private lazy var topContainer = UIView()
    private lazy var bottomContainer = UIView()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "arrow_down")!.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureView()
    }
    
    // MARK: При изменении состояния выбора ячейки переключаем констрейнты и анимируем поворот стрелки
    private func updateAppearance() {
        collapsedConstraint.isActive = !isSelected
        expandedConstraint.isActive = isSelected

        UIView.animate(withDuration: 0.3) {
            let upsideDown = CGAffineTransform(rotationAngle: .pi * -0.999 )
            self.arrowImageView.transform = self.isSelected ? upsideDown : .identity
        }
    }
    
    private func configureView() {
        mainContainer.clipsToBounds = true
        topContainer.backgroundColor = UIColor.systemYellow
        bottomContainer.backgroundColor = UIColor.systemGreen
        
        contentView.cornerRadius = 12
        contentView.clipsToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        
        makeConstraints()
        updateAppearance()
    }
    
    private func makeConstraints() {
        contentView.addSubview(mainContainer)
        
        mainContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainContainer.addSubviews([topContainer, bottomContainer])
        
        topContainer.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        // MARK: Констрейнт для сжатого состояния (низ ячейки совпадает с низом верхнего контейнера)
        topContainer.snp.prepareConstraints { make in
            collapsedConstraint = make.bottom.equalToSuperview().constraint
            collapsedConstraint.layoutConstraints.first?.priority = .defaultLow
        }
        
        topContainer.addSubview(arrowImageView)
        
        arrowImageView.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        bottomContainer.snp.makeConstraints { make in
            make.top.equalTo(topContainer.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        // MARK: Констрейнт для расширенного состояния (низ ячейки совпадает с низом нижнего контейнера)
        bottomContainer.snp.prepareConstraints { make in
            expandedConstraint = make.bottom.equalToSuperview().constraint
            expandedConstraint.layoutConstraints.first?.priority = .defaultLow
        }
    }
    
}
