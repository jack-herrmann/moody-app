//
//  Constants.swift
//  Moody?
//
//  Created by Jack Herrmann on 22.02.21.
//

import Foundation
import SwiftUI

struct Constants {
    
    static let goldOutline = Color(red: 218.0 / 255.0, green: 165.0 / 255.0, blue: 32.0 / 255.0, opacity: 1.0)
    static let lightYellowAccent = Color(red: 255.0 / 255.0, green: 245.0 / 255.0, blue: 158.0 / 255.0, opacity: 1.0)
    static let yellowUnderline = Color(red: 255.0 / 255.0, green: 245.0 / 255.0, blue: 128.0 / 255.0, opacity: 1.0)
    
    static let myMoodBundles = [
        [myMood(name: "Unsure", img: "Unsure"), myMood(name: "Doubtful", img: "Doubtful"), myMood(name: "Confused", img: "Confused"), myMood(name: "Perplexed", img: "Perplexed"), myMood(name: "Overwhelmed", img: "Overwhelmed")],
        [myMood(name: "Unhappy", img: "Unhappy"), myMood(name: "Hurt", img: "Hurt"), myMood(name: "Sad", img: "Sad"), myMood(name: "Miserable", img: "Miserable"), myMood(name: "Heartbroken", img: "Heartbroken")],
        [myMood(name: "Irritated", img: "Irritated"), myMood(name: "Bad Tempered", img: "BadTempered"), myMood(name: "Angry", img: "Angry-1"), myMood(name: "Exasperated", img: "Exasperated"), myMood(name: "Furious", img: "Furious")],
        [myMood(name: "Energetic", img: "Energetic"), myMood(name: "Motivated", img: "Motivated"), myMood(name: "Productive", img: "Productive"), myMood(name: "Lethargic", img: "Lethargic"), myMood(name: "Exhausted", img: "Exhausted")],
        [myMood(name: "Brave", img: "Brave"), myMood(name: "Optimistic", img: "Optimistic"), myMood(name: "Encouraged", img: "Encouraged"), myMood(name: "Let Down", img: "LetDown"), myMood(name: "Powerless", img: "Powerless")],
        [myMood(name: "Tolerant", img: "Tolerant"), myMood(name: "Appreciated", img: "Appreciated"), myMood(name: "Caring", img: "Caring"), myMood(name: "Affectionate", img: "Affectionate"), myMood(name: "Devoted", img: "Devoted")],
        [myMood(name: "Quiet", img: "Quiet"), myMood(name: "Calm", img: "Calm"), myMood(name: "Ok", img: "Ok"), myMood(name: "Serene", img: "Serene"), myMood(name: "Confident", img: "Confident")],
        [myMood(name: "Distracted", img: "Distracted"), myMood(name: "Bored", img: "Bored"), myMood(name: "Interested", img: "Interested"), myMood(name: "Enthusiastic", img: "Enthusiastic"), myMood(name: "Obsessed", img: "Obsessed")],
        [myMood(name: "Lonely", img: "Lonely"), myMood(name: "Left Out", img: "LeftOut"), myMood(name: "Excluded", img: "Excluded"), myMood(name: "Isolated", img: "Isolated"), myMood(name: "Abandoned", img: "Abandoned")],
        [myMood(name: "Content", img: "Content"), myMood(name: "Pleased", img: "Pleased"), myMood(name: "Happy", img: "Happy"), myMood(name: "Delighted", img: "Delighted"), myMood(name: "Ecstatic", img: "Ecstatic")]
    ]
    
    static let myMoods = [
        myMood(name: "Happy", img: "Happy"),
        myMood(name: "Ok", img: "Ok"),
        myMood(name: "Sad", img: "Sad"),
        myMood(name: "Productive", img: "Productive"),
        myMood(name: "Encouraged", img: "Encouraged"),
        myMood(name: "Caring", img: "Caring"),
        myMood(name: "Silly", img: "Silly"),
        myMood(name: "Confused", img: "Confused"),
        myMood(name: "Angry", img: "Angry-1"),
        myMood(name: "Excluded", img: "Excluded"),
        myMood(name: "Interested", img: "Interested"),
        myMood(name: "Jealous", img: "Jealous"),
        myMood(name: "Innocent", img: "Innocent"),
        myMood(name: "Guilty", img: "Guilty"),
        myMood(name: "Special", img: "Special"),
        myMood(name: "Stupid", img: "Stupid"),
        myMood(name: "Funny", img: "Funny")
    ]
    
    static let stickers = [
        "Lock",
        "Balloon",
        "Cash",
        "Cloud",
        "Droplet",
        "Explosion",
        "Feather",
        "Flower",
        "Heart",
        "Leaf",
        "Moon",
        "OverArrow",
        "Star",
        "Stonks",
        "Sun",
        "Trophy",
        "Angry",
        "Umbrella",
        "Tongue",
        "Skull",
        "Heartbreak"
    ]
    static let lock = "Lock"
    
}
