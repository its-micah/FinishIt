//
//  TweetCollectionViewCell.swift
//  Finish It
//
//  Created by Micah Lanier on 6/4/16.
//  Copyright © 2016 Micah Lanier Design and Illustration. All rights reserved.
//

import UIKit

class TweetCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var handleLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!


    func configureWithTweet(tweet: Tweet) {
        nameLabel.text = tweet.twitterUsername
        handleLabel.text = tweet.screenName
        timeLabel.text = tweet.time
        tweetImageView.kf_setImageWithURL(NSURL(string: tweet.twitterUserImageURL)!, placeholderImage: nil)
        tweetImageView.kf_setImageWithURL(NSURL(string: tweet.imageURL)!, placeholderImage: nil)
        userImageView.downloadFrom(link: tweet.twitterUserImageURL, contentMode: .ScaleAspectFill)
        self.layoutSubviews()

    }
}
