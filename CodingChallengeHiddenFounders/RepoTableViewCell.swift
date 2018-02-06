//
//  RepoTableViewCell.swift
//  CodingChallengeHiddenFounders
//
//  Created by Gotzon Zabala on 27/1/18.
//  Copyright © 2018 Gotzon Zabala. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {

    @IBOutlet var repoName: UILabel!
    @IBOutlet var repoDescription: UILabel!
    @IBOutlet var ownerImage: UIImageView!
    @IBOutlet var ownerName: UILabel!
    @IBOutlet var totalStars: UILabel!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
