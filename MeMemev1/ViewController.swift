//
//  ViewController.swift
//  MeMeme v1
//
//  Created by Anan Yousef on 8/18/20.
//  Copyright © 2020 Anan Yousef. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
   // Mark: Outlet Buttons

    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var share: UIBarButtonItem!
    @IBOutlet weak var camerabutton: UIBarButtonItem!
    @IBOutlet weak var Top: UITextField!
    @IBOutlet weak var bottom: UITextField!
    
    let textDelegate = textClearDelegate()
    var memedImage: UIImage!
    var meme : Meme!
    
    // Mark: View Func's
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
           self.Top.delegate = textDelegate
           self.bottom.delegate = textDelegate
        
        Top.defaultTextAttributes = memeTextAttributes
                  bottom.defaultTextAttributes = memeTextAttributes
               
           Top.textAlignment = .center
           Top.text = "TOP"
    
           bottom.textAlignment = .center
           bottom.text = "BOTTOM"
        
           
            share.isEnabled = false
      
       }
    
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
        camerabutton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
       
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    
    
    // Mark: Meme Sruct & Meme Generate

    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
    }
    
    
    func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memedImage
    }
    
    // Mark: Save Image
    func saveMemedImage(memedImage: UIImage) {
        
        let meme = Meme(topText: Top.text!, bottomText: bottom.text!, originalImage: imageview.image!, memedImage: memedImage)
       self.meme = meme
    }
    
    
 
    
    let memeTextAttributes: [NSAttributedString.Key: Any] =
        
        [
    
           NSAttributedString.Key.strokeColor: UIColor.black,
           NSAttributedString.Key.foregroundColor: UIColor.white,
           NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 36)!,
           NSAttributedString.Key.strokeWidth: 3.0
        
    
       ]
        
    
    
        
    

   // Mark: Keyboard Func's

    @objc func keyboardWillShow(_ notification:Notification) {
        if bottom.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
        
        }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // Mark: Action Button's

    @IBAction func pickAnImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
       present(imagePicker, animated: true, completion: nil)
        share.isEnabled = true
        
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        share.isEnabled = true
    }

    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
        imageview.image = image
        dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)

    
        }

    @IBAction func sharebutton(_ sender: Any) {
        
        let memeToShare = generateMemedImage()
            let sharingActivity = UIActivityViewController(activityItems: [memeToShare], applicationActivities: nil)
            sharingActivity.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) in
                
                if completed {
                    self.saveMemedImage(memedImage: memeToShare)
                    
                }
            }
            present(sharingActivity, animated: true, completion: nil)
        }
    }
    

