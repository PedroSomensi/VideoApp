//
//  videoInfomartions.swift
//  MoymerApp
//
//  Created by Pedro on 20/04/17.
//  Copyright © 2017 Pedro. All rights reserved.
//

import UIKit

class videoInfomartions: NSObject {
    
    var title : String!
    var thumb : UIImage!
    var urlVideo : String!
    
    init(titleAux: String, thumbAux: String!, urlvideoAux: String!) {
        self.title = titleAux
        
        let urlThumb = URL(string: thumbAux)
        let data = NSData(contentsOf: urlThumb!)
        self.thumb = UIImage(data: data! as Data)
        
        self.urlVideo = urlvideoAux
    }
    
    func getTitle() -> String! {
        return self.title
    }
    
    func getThumb() -> UIImage! {
        return self.thumb
    }
    
    func getUrlVideo() -> String! {
        return self.urlVideo
    }

    
    
}
