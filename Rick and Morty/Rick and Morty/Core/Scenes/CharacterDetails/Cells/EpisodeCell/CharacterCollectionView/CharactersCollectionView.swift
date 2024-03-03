//
//  CharactersCollectionView.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 03.03.24.
//

import UIKit

class CharactersCollectionView: UICollectionView {
    
    private typealias Dimensions = CharactersCollectionViewConstants.Dimensions
    
    private var model: [UIImage]?
    
    private let layout: CharacterCollectionViewFlowLayout = {
        let layout = CharacterCollectionViewFlowLayout(cellWidth: Dimensions.collectionViewCellWidth)
        layout.itemSize = Dimensions.collectionViewItemSize
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Dimensions.collectionViewSpacing
        return layout
    }()
    
    // MARK: Main Constructor
    convenience init(withModel model: [UIImage]) {
        self.init()
        self.configure(withModel: model)
    }
    
    init() {
        super.init(frame: .zero, collectionViewLayout: layout)
        self.setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withModel model: [UIImage]) {
        self.model = model
        reloadData()
    }

}
// MARK: - Private Functions

extension CharactersCollectionView {
    
    private func setup() {
        configureDelegates()
        registerCells()
        configureUI()
    }
    
    private func configureDelegates() {
        self.delegate = self
        self.dataSource = self
    }
    
    private func registerCells() {
        self.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CharacterCollectionViewCell.self))
    }
    
    private func configureUI() {
        self.backgroundColor = Colors.RickDomColorPalette.white
    }

}
// MARK: - UICollectionViewDataSource

extension CharactersCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model?.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CharacterCollectionViewCell.self) ,
            for: indexPath)
        if let cell = cell as? CharacterCollectionViewCell  {
            if let model = model  {
                cell.configure(with: model[indexPath.item])
            }
            return cell
        }
        return cell
    }
    
}
// MARK: - UIScrollViewDelegate

extension CharactersCollectionView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if let indexPath = self.indexPathForItem(at: scrollView.centerPoint) {
            self.reloadData()
            self.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
}
// MARK: - UICollectionViewDelegateFlowLayout

extension CharactersCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  Dimensions.collectionViewItemSize
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        Dimensions.collectionViewInsets
    }
}
