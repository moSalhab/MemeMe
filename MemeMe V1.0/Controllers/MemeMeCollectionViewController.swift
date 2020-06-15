//
//  MemeMeCollectionViewController.swift
//  MemeMe V1.0
//
//  Created by Mohammad Salhab on 3/8/20.
//  Copyright © 2020 Mohammad Salhab. All rights reserved.
//

import UIKit

class MemeMeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let space:CGFloat = 3.0
        
        var dimension: CGFloat!
        
        let width = (view.frame.size.width - (2 * space)) / 2.0
        let height = (view.frame.size.height - (2 * space)) / 2.0

        if width < height {
            dimension = width
        } else {
            dimension = height
        }
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        // Do any additional setup after loading the view.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeMeCollectionViewCell", for: indexPath) as! MemeMeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]

        // Set the name and image
        cell.memeImage.image = meme.memedImage

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {

        // Grab the DetailVC from Storyboard
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailsViewController") as! MemeDetailsViewController

        //Populate view controller with data from the selected item
        detailController.meme = memes[(indexPath as NSIndexPath).row].memedImage

        // Present the view controller using navigation
        navigationController!.pushViewController(detailController, animated: true)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
