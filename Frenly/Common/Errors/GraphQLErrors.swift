//
//  GraphQLErrors.swift
//  Frenly
//
//  Created by Владислав on 02.11.2022.
//

import Foundation

enum GraphQLErrors: LocalizedError {
    case noChallengeReturned
    case unauthorized
    case profileNotCreated
    case noUpvote
}
