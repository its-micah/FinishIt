//
//  TweetTableViewCell.swift
//  Finish It
//
//  Created by Micah Lanier on 5/21/16.
//  Copyright © 2016 Micah Lanier Design and Illustration. All rights reserved.
//

import UIKit
import Kingfisher

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureWithTweet(tweet: Tweet) {
        usernameLabel.text = tweet.twitterUsername
        tweetImageView.kf_setImageWithURL(NSURL(string: tweet.twitterUserImageURL)!, placeholderImage: nil)
        tweetImageView.kf_setImageWithURL(NSURL(string: tweet.imageURL)!, placeholderImage: nil)
        userImageView.downloadFrom(link: tweet.twitterUserImageURL, contentMode: .ScaleAspectFill)
        self.layoutSubviews()

    }

}
