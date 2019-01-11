//
//  ViewController.swift
//  AccessorizeMe
//
//  Created by Andi Maroge on 1/8/19.
//  Copyright © 2019 Andi Maroge. All rights reserved.
//

import UIKit

class AccessoryArtViewController: UIViewController, UIDropInteractionDelegate, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var dropZone: UIView! {
        didSet {
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 0.5
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self
            scrollView.addSubview(accessoryArtView)
        }
    }
    
    var accessoryArtView = AccessoryArtView()
    @IBOutlet weak var accessoriesCollectionView: UICollectionView!{
        didSet {
            accessoriesCollectionView.delegate = self
            accessoriesCollectionView.dataSource = self
        }
    }
    
    var accessoryBackgroundImage: UIImage? {
        get {
            return accessoryArtView.backgroundImage
        }
        set {
            scrollView?.zoomScale = 1.0
            accessoryArtView.backgroundImage = newValue
            let size = newValue?.size ?? CGSize.zero
            accessoryArtView.frame = CGRect(origin: CGPoint.zero, size: size)
            scrollView?.contentSize = size
            
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
}

