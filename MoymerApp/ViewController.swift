//
//  ViewController.swift
//  MoymerApp
//
//  Created by Pedro on 20/04/17.
//  Copyright © 2017 Pedro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let DAO = informationsDAO.sharedInstance
    let transition = Transition()
    var positionTouch = CGPoint.zero
    var indexCellSelected = 0
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerImages: UIView!
    @IBOutlet weak var imageText: UIImageView!
    @IBOutlet weak var imageSun: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarView: UIView!
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var collectionFlowLayout: UICollectionViewFlowLayout!
    
    
    let color : UIColor = UIColor(red: 17/255.0, green: 127/255.0, blue: 204/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DAO.loadVideosInfos()
        
        self.collection.dataSource = self
        self.collection.delegate = self
        
        self.customizeSearchBar()
        
        let tapSearch = UITapGestureRecognizer(target: self, action: #selector(ViewController.tappedSearchBar(gesture:)))
        self.searchBarView.addGestureRecognizer(tapSearch)
        
        UIView.animate(withDuration: 15, delay: 0, options: [.repeat , .curveLinear], animations: {
            self.imageSun.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }, completion: nil)
        
        self.scrollView.isScrollEnabled = false
        

    }
    
    override func viewDidLayoutSubviews() {
        roundBorder(self.searchBar, borderRadius: 2.2, borderWidth: 10, borderColor: color)
        
        self.collection.frame = CGRect(x: 0, y: UIScreen.main.bounds.height + 5, width: self.view.frame.width, height:  self.collection.collectionViewLayout.collectionViewContentSize.height)
        
        self.scrollView.contentSize.height = self.containerImages.frame.height + self.collection.collectionViewLayout.collectionViewContentSize.height
        
        
        let halfViewWidth = self.view.frame.width/2
        
        let percentage = (halfViewWidth*30)/100
        
        let widthSize = halfViewWidth-(percentage)
        let heightSize = halfViewWidth-(percentage)
        
        self.collectionFlowLayout.itemSize = CGSize(width: widthSize, height: heightSize)
        self.collectionFlowLayout.minimumInteritemSpacing = percentage/2
        
        self.collectionFlowLayout.minimumLineSpacing = percentage/2
        
        self.collectionFlowLayout.sectionInset = UIEdgeInsetsMake(percentage/2, percentage/2, percentage/2, percentage/2)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondVC = segue.destination as! PageViewController
        
        let cell = sender as! CollectionViewCell
        self.positionTouch = CGPoint(x: self.collection.frame.minX + cell.frame.minX + cell.center.x, y: self.collection.frame.minY + cell.frame.minY + cell.center.y)
        
        secondVC.transitioningDelegate = self
        secondVC.modalPresentationStyle = .custom
        
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    func customizeSearchBar(){
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        textFieldInsideSearchBar?.backgroundColor = color
        
        textFieldInsideSearchBar?.attributedPlaceholder = NSAttributedString(string: "Search for videos", attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        if let imageIcon = textFieldInsideSearchBar?.leftView as? UIImageView {
            imageIcon.image? = (imageIcon.image?.transform(withNewColor: UIColor.white))!
            imageIcon.frame = CGRect(x: imageIcon.frame.minX-3,
                                     y: imageIcon.frame.minY+3,
                                     width: imageIcon.frame.width+3,
                                     height: imageIcon.frame.height+3)
        }
        
        if let textField = textFieldInsideSearchBar {
            textField.font = UIFont(name: (textField.font?.fontName)!, size: 16)
        }
        
        searchBar.isUserInteractionEnabled = false
    }
    
    func tappedSearchBar(gesture: UITapGestureRecognizer) {
        
        
        UIView.animate(withDuration: 0.2, animations: {
            self.searchBar.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                self.searchBar.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }, completion: { (_) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.searchBar.transform = CGAffineTransform.identity
                }, completion: { (_) in
                    self.collection.reloadData()
                    self.scrollView.isScrollEnabled = true
                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
                        self.searchBar.alpha = 0
                        self.searchBarView.isUserInteractionEnabled = false
                        
                        
                        self.containerImages.frame = CGRect(x: self.containerImages.frame.minX,
                                                           y: self.containerImages.frame.minY - self.containerImages.frame.height*0.3, width: self.containerImages.frame.width, height: self.containerImages.frame.height)
                        
                        self.imageText.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                        
                        self.collection.frame = CGRect(x: self.containerImages.frame.minX, y: self.containerImages.frame.maxY + 30, width: self.view.frame.width, height: self.view.frame.height)
                        
                        self.scrollView.isScrollEnabled = true
                        
                    }, completion: nil)
                    
                })
            })
        }
    }


}

extension ViewController : UIViewControllerTransitioningDelegate {
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.transitionMode = .dismiss
        transition.startingPoint = self.positionTouch
        return transition
        
    }
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.transitionMode = .present
        transition.startingPoint = self.positionTouch
        //transition.image.image = DAO.getVideoInfo(index: self.indexCellSelected).getThumb()
        return transition
    }
    
}

extension ViewController : UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        
        if self.DAO.getCount() > 0 {
            cell.title.text = self.DAO.getVideoInfo(index: indexPath.row).getTitle().uppercased()
            cell.backgroundImage.backgroundColor = color
            cell.backgroundImage.image = self.DAO.getVideoInfo(index: indexPath.row).getThumb()
            cell.backgroundImage.layer.cornerRadius = cell.backgroundImage.frame.size.height / 8
            cell.backgroundImage.layer.masksToBounds = true
            cell.backgroundImage.contentMode = .scaleAspectFill
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
}

extension ViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexCellSelected = indexPath.row
        DAO.setCellSelected(value: self.indexCellSelected)
        print(DAO.getCellSelected())
        
        UIView.animate(withDuration: 0.2, animations: {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                let cell = collectionView.cellForItem(at: indexPath)
                cell?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            })
        }
        
        
    }
    
}

extension UIImage {
    
    func transform(withNewColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: cgImage!)
        
        color.setFill()
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
}


