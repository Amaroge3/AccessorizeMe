//
//  ViewController.swift
//  AccessorizeMe
//
//  Created by Andi Maroge on 1/8/19.
//  Copyright © 2019 Andi Maroge. All rights reserved.
//

import UIKit
import Foundation
import MobileCoreServices
class AccessoryArtViewController: UIViewController, UIDropInteractionDelegate, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    // MARK: - Camera
    @IBOutlet weak var cameraButton: UIBarButtonItem! {
        didSet {
            cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        }
    }
    @IBAction func loadBackgroundImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes = [kUTTypeImage as String]
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.presentingViewController?.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage
        if let imageData = image?.jpegData(compressionQuality: 1.0) {
            accessoryBackgroundImage = UIImage(data: imageData)
        }
        dismiss(animated: true)
    }
    
    // MARK: - Scroll View Layout Constraints Outlets
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    
    // MARK: - OUTLETS
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
    //Drop Zone Outlet
    @IBOutlet weak var dropZone: UIView! {
        didSet {
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    // Collection View Outlet
    @IBOutlet weak var accessoriesCollectionView: UICollectionView!{
        didSet {
            accessoriesCollectionView.dataSource = self
            accessoriesCollectionView.delegate = self
            accessoriesCollectionView.dragDelegate = self
            accessoriesCollectionView.dropDelegate = self
            addUICollectionViewRecognizer()
        }
    }
    
    // MARK: - Flow Layout
    var flowLayout: UICollectionViewFlowLayout? {
        return accessoriesCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    //accessories array for the images to load onto the collection view
    var accessories = [UIImage?]()
    
    //AccessoryArtModel instance
    var accessoryModel = AccessoryArtModel()
    
    //collection view width
    var collectionViewWidth: CGFloat = 50 {
        didSet{
            flowLayout?.invalidateLayout()
        }
    }
    
    // Subpath that's retrieved from the Table View and sent to the File Manager for lookup.
    var accessorySubPath: String? {
        didSet {
            updateCollectionViewFromMaster()
        }
    }
    
    
    // MARK: - Scroll View
    
    /**
     # Scroll View Did Zoom
     When the scroll view zooms, change the content height and width of the scroll view.
     */
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewWidth.constant = scrollView.contentSize.width
        scrollViewHeight.constant = scrollView.contentSize.height
        
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return accessoryArtView
    }
    
    // MARK: - Images Properties
    
    //Accessory image
    var accessoryArtView = AccessoryArtView()
    
    //Background Image
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
    
    
    // MARK: - VIEW DID LOAD
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
    
    // MARK: - VIEW DID APPEAR
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    // MARK: - Drop Interaction
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: UIImage.self) { images in
            if let image = images.first as? UIImage {
                self.accessoryBackgroundImage = image
            }
        }
    }
    // MARK: - Collection View - Data Source
    
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
    // MARK: - Collection View Drag Delegates
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
                collectionViewWidth *= recognizer.scale
                recognizer.scale = 1.0
                accessoriesCollectionView.dragInteractionEnabled = true
                accessoriesCollectionView.allowsSelection = true
            
            
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
