//
//  ViewController.swift
//  Sharing Service Image Markup Demo
//
//  Created by Mark Thalman on 8/5/16.
//  Copyright © 2016 Mark Thalman. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSSharingServiceDelegate
{
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var filenameLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image = NSBundle.mainBundle().imageForResource("DSC_0008")
        if let pathname = NSBundle.mainBundle().pathForImageResource("DSC_0008"){
            filenameLabel.stringValue = pathname
        }
    }
    
    override func validateMenuItem(menuItem: NSMenuItem) -> Bool {
        if menuItem.action == #selector(ViewController.markupImage) {
            return true
        }
        return false
    }

    @IBAction func markupImage(sender: AnyObject) {
        if imageView.image != nil {
            let service = NSSharingService(named: "com.apple.Preview.Markup")
            service?.delegate = self
            let url = NSURL(fileURLWithPath: filenameLabel.stringValue)
            service?.performWithItems([url])
        }
    }
    
    func sharingService(sharingService: NSSharingService, sourceFrameOnScreenForShareItem item: AnyObject) -> NSRect {
        let image = NSImage.init(byReferencingURL: item as! NSURL)
        let rect = NSMakeRect(0, 0, image.size.width, image.size.height)

        return rect
    }
    
    func sharingService(sharingService: NSSharingService, sourceWindowForShareItems items: [AnyObject], sharingContentScope: UnsafeMutablePointer<NSSharingContentScope>) -> NSWindow? {
        return self.view.window
    }

    func sharingService(sharingService: NSSharingService, didShareItems items: [AnyObject]) {
        let itemProvider : NSItemProvider = items[0] as! NSItemProvider
        
        itemProvider.loadItemForTypeIdentifier(itemProvider.registeredTypeIdentifiers[0] as! String, options: nil, completionHandler:
            {(item, error) -> Void in
                self.imageView.image = NSImage.init(byReferencingURL: item as! NSURL)
        })
    }
}

