//
//  ViewController.swift
//  AutoScrollCollectionViewController
//
//  Created by toshi0383 on 2016/12/13.
//  Copyright © 2016 toshi0383. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = IndexPath(item: 5, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
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
