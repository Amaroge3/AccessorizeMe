//
//  ViewController.swift
//  AccessorizeMe
//
//  Created by Andi Maroge on 1/8/19.
//  Copyright © 2019 Andi Maroge. All rights reserved.
//

import UIKit
import Foundation

class AccessoryArtViewController: UIViewController, UIDropInteractionDelegate, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    
    // MARK: - Flow Layout
    var flowLayout: UICollectionViewFlowLayout? {
        return accessoriesCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    var accessories = [UIImage?]()
    var accessoryModel = AccessoryArtModel()
    var collectionViewWidth: CGFloat = 50 {
        didSet{
            flowLayout?.invalidateLayout()
        }
    }
    var accessorySubPath: String? {
        didSet {
            updateCollectionViewFromMaster()
        }
    }
    
    /**
     ### DropZone
     The view where the collection view items are dropped to.
     */
    @IBOutlet weak var dropZone: UIView! {
        didSet {
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    // MARK: - Scroll View
    /**
     ### Scroll View
     The scroll view in the storyboard that holds the accessoryArtView to scroll.
     */
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self
            scrollView.addSubview(accessoryArtView)
        }
    }
    /**
     When the scroll view zooms, change the content height and width of the scroll view.
     */
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewWidth.constant = scrollView.contentSize.width
        scrollViewHeight.constant = scrollView.contentSize.height
        
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return accessoryArtView
    }
    
    //Accessory image
    var accessoryArtView = AccessoryArtView()
    @IBOutlet weak var accessoriesCollectionView: UICollectionView!{
        didSet {
            accessoriesCollectionView.dataSource = self
            accessoriesCollectionView.delegate = self
            accessoriesCollectionView.dragDelegate = self
            accessoriesCollectionView.dropDelegate = self
            addUICollectionViewRecognizer()
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
            scrollView?.zoomScale = 0.5
            accessoryArtView.backgroundColor = .clear
            scrollViewHeight.constant = scrollView.contentSize.height
            scrollViewWidth.constant = scrollView.contentSize.width
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accessoryBackgroundImage = UIImage(named: "IMG_2525")
        scrollViewHeight.constant = scrollView.contentSize.height
        scrollViewWidth.constant = scrollView.contentSize.width
                //load the images to the accessories array from the model
        
                    for item in accessoryModel.imagesNamesFromFolder! {
                        let image = UIImage(named: item)
                        accessories.append(image)
                    }
        
    }
    
    //    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
    //        return session.canLoadObjects(ofClass: UIImage.self)
    //    }
    //    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
    //        return UIDropProposal(operation: .copy)
    //    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: UIImage.self) { images in
            if let image = images.first as? UIImage {
                self.accessoryBackgroundImage = image
            }
        }
    }
    // MARK: - Collection View
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionViewWidth, height: collectionView.bounds.height)
        
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
    
    // MARK: - Collection View Drag
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = session.localDragSession?.localContext as? UICollectionView == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                if let image = item.dragItem.localObject as? UIImage {
                    
                    collectionView.performBatchUpdates({
                        accessories.remove(at: sourceIndexPath.item)
                        accessories.insert(image, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath] )
                        collectionView.insertItems(at: [destinationIndexPath]  )
                    })
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            }
            
            
        }
    }
    /**
     Updates the collection view after a segue from the table view controller.
     */
    func updateCollectionViewFromMaster() {
        let newSubpath = "/\(accessorySubPath!)"
        
        accessoryModel.loadImagesFromFolder(in: newSubpath)
        let accessoriesFromModel = accessoryModel.imagesNamesFromFolder
        accessories = [UIImage?]()
        //load the images to the accessories array from the model
        for item in accessoriesFromModel! {
            let image = UIImage(named: item)
            accessories.append(image)
        }
        //refresh the collectionview
        DispatchQueue.main.async {
            self.accessoriesCollectionView.reloadData()
        }
    }
}



// MARK: - Extensions: ArtViewController
extension AccessoryArtViewController {
    func addUICollectionViewRecognizer() {
        accessoriesCollectionView.isUserInteractionEnabled = true
        
        accessoriesCollectionView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(increaseWidthOfCell(by:))))
    }
    @objc func increaseWidthOfCell(by recognizer: UIPinchGestureRecognizer) {
        
        switch recognizer.state {
        case .began:
            accessoriesCollectionView.dragInteractionEnabled = false
            accessoriesCollectionView.allowsSelection = false
        case .changed, .ended:
            if let collectionView = accessoriesCollectionView as? UICollectionView {
                collectionViewWidth *= recognizer.scale
                recognizer.scale = 1.0
                accessoriesCollectionView.dragInteractionEnabled = true
                accessoriesCollectionView.allowsSelection = true
            }
            
        default:
            break
        }
        
    }
    
}
extension AccessoryArtViewController {
    func centerScrollViewContent(_ scrollView: UIScrollView){
        let scrollViewSize = scrollView.bounds.size
        let imageSize = accessoryArtView.frame.size
        let horizontalSpace = imageSize.width < scrollViewSize.width
            ? (scrollViewSize.width - imageSize.width) / 2
            : 0
        let verticalSpace = imageSize.height < scrollViewSize.height
            ? (scrollViewSize.height - imageSize.height) / 2
            : 0
        scrollView.contentInset = UIEdgeInsets(top: verticalSpace, left: horizontalSpace, bottom: verticalSpace, right: horizontalSpace)
        
        
    }
    
    
}
