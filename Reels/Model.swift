//
//  Model.swift
//  Reeli Clone
//
//  Created by IPS-149 on 19/03/24.
//

import Foundation

struct Video: Codable {
    let id: String
    let title: String
    let thumbnailUrl: String
    let duration: String
    let uploadTime: String
    let views: String
    let author: String
    let videoUrl: String
    let description: String
    let subscriber: String
    let isLive: Bool
}
