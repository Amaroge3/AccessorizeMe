//
//  ViewController.swift
//  AccessorizeMe
//
//  Created by Andi Maroge on 1/8/19.
//  Copyright © 2019 Andi Maroge. All rights reserved.
//

import UIKit

class AccessoryArtViewController: UIViewController, UIDropInteractionDelegate, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
    }
    
   
    
    
    @IBOutlet weak var dropZone: UIView! {
        didSet {
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 0.2
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self
            scrollView.addSubview(accessoryArtView)
            
            
            
        }
    }
    
    var accessoryArtView = AccessoryArtView()
    @IBOutlet weak var accessoriesCollectionView: UICollectionView!{
        didSet {
            accessoriesCollectionView.dataSource = self

            accessoriesCollectionView.delegate = self
            accessoriesCollectionView.dragDelegate = self
            
            accessoriesCollectionView.dropDelegate = self
            
        }
    }
    
    var accessoryBackgroundImage: UIImage? {
        get {
            return accessoryArtView.backgroundImage
        }
        set {
            accessoryArtView.backgroundImage = newValue
            let size = newValue?.size ?? CGSize.zero
            accessoryArtView.frame = CGRect(origin: CGPoint.zero, size: size)
            scrollView?.contentSize = size
            scrollView?.zoomScale = 1.0

            
        }
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return accessoryArtView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accessoryBackgroundImage = UIImage(named: "IMG_2525")
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = true
        
    }
    var fm = FileManager.default
    
    let path = Bundle.main.resourcePath
    var accessories = [UIImage(named: "sun-glasses")]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accessories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccessoryCell", for: indexPath)
        if let accessoryCell = cell as? AccessoryCollectionViewCell {
            let image = accessories[indexPath.item]
            accessoryCell.accessoryImage?.image = image
            
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let image = (accessoriesCollectionView.cellForItem(at: indexPath) as? AccessoryCollectionViewCell)?.accessoryImage?.image {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: image))
            
            dragItem.localObject = image
            return [dragItem]
        }
        else {
            return []
        }
    }
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = session.localDragSession?.localContext as? UICollectionView == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
}

