//
//  PageViewController.swift
//  MoymerApp
//
//  Created by Pedro on 20/04/17.
//  Copyright © 2017 Pedro. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var viewControllerList = [UIViewController]()
    var index = 0
    
    let DAO = informationsDAO.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        for i in 0..<DAO.getCount() {
            let vc = storyBoard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
            vc.loadVideo(videoUrl: DAO.getVideoInfo(index: i).getUrlVideo())
            vc.loadBackground(thumb: DAO.getVideoInfo(index: i).getThumb())
            vc.addtitle(text: DAO.getVideoInfo(index: i).getTitle().uppercased(), rect: CGRect(x: (self.view.center.x - ((self.view.frame.width*0.7)/2)), y: 30, width: self.view.frame.width*0.7, height: 30))
            self.viewControllerList.append(vc)
        }
        
        
        self.setViewControllers([viewControllerList[DAO.getCellSelected()]], direction: .forward, animated: true, completion: nil)
        
    }


}


extension PageViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        
        let nextIndex = vcIndex + 1
        
        
        guard viewControllerList.count != nextIndex else {
            return nil
        }
        
        guard viewControllerList.count > nextIndex else {
            return nil
        }
        
        return viewControllerList[nextIndex]
        
        
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0  else { return nil }
        
        guard viewControllerList.count > previousIndex else {return nil}
        
        return viewControllerList[previousIndex]
        
    }
}

