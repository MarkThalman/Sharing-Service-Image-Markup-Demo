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
        imageView.image = Bundle.main.image(forResource: "DSC_0008.JPG")
        if let pathname = Bundle.main.path(forResource: "DSC_0008", ofType: "JPG") {
            filenameLabel.stringValue = pathname
        }
    }
    
    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        if menuItem.action == #selector(ViewController.markupImage) {
            return true
        }
        return false
    }

    @IBAction func markupImage(_ sender: AnyObject) {
        if imageView.image != nil {
            let service = NSSharingService(named: "com.apple.Preview.Markup")
            service?.delegate = self
            let url = NSURL(fileURLWithPath: filenameLabel.stringValue)
            service?.perform(withItems: [url])
        }
    }
    
    func sharingService(_ sharingService: NSSharingService, sourceFrameOnScreenForShareItem item: AnyObject) -> NSRect {
        var rect = NSZeroRect
        let image = NSImage(byReferencing: item as! URL)
        rect = NSMakeRect(0, 0, image.size.width, image.size.height)

        return rect
    }
    
    func sharingService(_ sharingService: NSSharingService, sourceWindowForShareItems items: [AnyObject], sharingContentScope: UnsafeMutablePointer<NSSharingContentScope>) -> NSWindow? {
        return self.view.window
    }

    func sharingService(_ sharingService: NSSharingService, didShareItems items: [AnyObject]) {
        let itemProvider : NSItemProvider = items[0] as! NSItemProvider
    
        itemProvider.loadItem(forTypeIdentifier: itemProvider.registeredTypeIdentifiers[0] as! String,
                              options: nil,
                              completionHandler: {(item, error) -> Void in
                self.imageView.image = NSImage(byReferencing: item as! URL)
        })
    }
}

