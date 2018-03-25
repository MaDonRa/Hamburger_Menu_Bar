//
//  GetImageFromDocumentsDirectory.swift
//  vHealth
//
//  Created by Sakkaphong Luaengvilai on 12/13/2559 BE.
//  Copyright © 2559 MaDonRa. All rights reserved.
//

import UIKit

class ImageFromDocumentsDirectory: NSObject {
  
    internal func GetImage(ImageName: String) -> UIImage? {
        
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).get(0) else { return nil }
        
        let fileURL = documentsURL.appendingPathComponent(ImageName)
        let image = UIImage(contentsOfFile: fileURL.path)
        return image
    }
    
    internal func RemoveOldFileIfExist(ImageName: String) {
 
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).get(0) else { return }
        
        let fileURL = documentsURL.appendingPathComponent(ImageName)
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }
        do {
            try FileManager.default.removeItem(atPath: fileURL.path)
        } catch {
            print(error)
        }
    }
    
    internal func SaveImage(ImageName:String ,Image : UIImage) {
        guard let documentsURL = try? FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else { return }
        let fileURL = documentsURL.appendingPathComponent(ImageName)

        //if !FileManager.default.fileExists(atPath: fileURL.path) { //เช็ค path นั้นว่าว่างไหม
            do {
                try  UIImageJPEGRepresentation(Image, 1.0)?.write(to: fileURL)
            } catch {
                print(error)
            }
        //}
    }
    
}
