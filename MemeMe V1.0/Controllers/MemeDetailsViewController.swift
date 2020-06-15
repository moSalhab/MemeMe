//
//  MemeDetailsViewController.swift
//  MemeMe V1.0
//
//  Created by Mohammad Salhab on 3/8/20.
//  Copyright © 2020 Mohammad Salhab. All rights reserved.
//

import UIKit

class MemeDetailsViewController: UIViewController {

    
    @IBOutlet weak var memeImage: UIImageView!
    
    var meme: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        memeImage.image = meme
        // Do any additional setup after loading the view.
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
