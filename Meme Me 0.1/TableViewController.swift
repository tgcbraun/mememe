//
//  TableViewController.swift
//  Meme Me 0.1
//
//  Created by Thiago Graça Couto Braun on 3/24/15.
//  Copyright (c) 2015 GCBraun. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UITableViewDataSource {
    
    
    
    override func viewWillAppear(animated: Bool) {
        self.tableView!.reloadData()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (UIApplication.sharedApplication().delegate as AppDelegate).memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell") as TableViewCell
        let meme = (UIApplication.sharedApplication().delegate as AppDelegate).memes[indexPath.row]
        
        cell.textOne.textAlignment = NSTextAlignment.Center
        cell.textTwo.textAlignment = NSTextAlignment.Center
        cell.textOne.text = meme.text1
        cell.textTwo.text = meme.text2
        cell.tableImageView?.image = meme.image
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailedViewController")! as MemeDetailedViewController
        detailController.meme = (UIApplication.sharedApplication().delegate as AppDelegate).memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)

        
    }

}
