//
//  ViewController.swift
//  AutoScrollCollectionViewController
//
//  Created by toshi0383 on 2016/12/13.
//  Copyright © 2016 toshi0383. All rights reserved.
//

import Async
import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    private var focusUpdateTask: Async?
    private var fixContentOffsetTask: Async?
    private var _currentIndex: Int = 0
    private func updateCurrentIndex(_ index: Int) {
        _currentIndex = index
        collectionView.scrollToItem(at: currentIndexPath, at: .centeredVertically, animated: true)
        // This is also okay.
        //let point = CGPoint(x: 0, y: 290 + 540*index)
        //collectionView.setContentOffset(point, animated: true)
        updateFocusWithDelay()
    }
    func updateFocusWithDelay() {
        focusUpdateTask?.cancel()
        focusUpdateTask = Async.main(after: 0.5) {
            self.setNeedsFocusUpdate()
        }
    }
    private var currentIndexPath: IndexPath {
        return IndexPath(item: _currentIndex, section: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCurrentIndex(5)
    }

    // MARK: UIFocusEnvironment
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        let cell = collectionView?.cellForItem(at: currentIndexPath)
        return [cell].flatMap{$0}
    }

    // MARK: Delegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        guard let indexPath = context.nextFocusedIndexPath else {
            return
        }
        _currentIndex = indexPath.row
        fixContentOffsetTask?.cancel()
        fixContentOffsetTask = Async.main(after: 0.1) {
            self.updateCurrentIndex(self._currentIndex)
        }
    }
}

class Cell: UICollectionViewCell {
    @IBOutlet weak var imageview: UIImageView!
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if (context.nextFocusedItem as! Cell) == self {
            coordinator.addCoordinatedAnimations({
                self.imageview.image = UIImage(named: "dev-insights")
                self.imageview.addBorder()
            }, completion: nil)
        } else if (context.previouslyFocusedItem as! Cell) == self {
            coordinator.addCoordinatedAnimations({
                self.imageview.image = UIImage(named: "safari")
                self.imageview.removeBorder()
            }, completion: nil)

        }
    }
}

extension UIView {
    func addBorder() {
        layer.borderColor = UIColor.blue.cgColor
        layer.borderWidth = 4.0
    }
    func removeBorder() {
        layer.borderWidth = 0.0
    }
}
