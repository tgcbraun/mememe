//
//  CollectionsViewController.swift
//  Meme Me 0.1
//
//  Created by Thiago Graça Couto Braun on 3/23/15.
//  Copyright (c) 2015 GCBraun. All rights reserved.
//

import UIKit

class CollectionsViewController: UICollectionViewController {
    
    
    @IBOutlet weak var gridButton: UIBarButtonItem!
    @IBOutlet weak var tableButton: UIBarButtonItem!
    
    
    override func viewWillAppear(animated: Bool) {
        self.collectionView!.reloadData()
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (UIApplication.sharedApplication().delegate as AppDelegate).memes.count
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        println((UIApplication.sharedApplication().delegate as AppDelegate).memes.count)
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as CollectionViewCell
        let meme = (UIApplication.sharedApplication().delegate as AppDelegate).memes[indexPath.row]
        
        // Set the name and image
        
        cell.textOne.textAlignment = NSTextAlignment.Center
        cell.textTwo.textAlignment = NSTextAlignment.Center
        cell.textOne.text = meme.text1
        cell.textTwo.text = meme.text2
        cell.collectionImageView?.image = meme.image
        
        return cell
    }
    
  
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailedViewController")! as MemeDetailedViewController
        detailController.meme = (UIApplication.sharedApplication().delegate as AppDelegate).memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }

}
