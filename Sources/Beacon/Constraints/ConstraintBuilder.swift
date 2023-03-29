//
//  ConstraintBuilder.swift
//  
//
//  Created by Pavel Skaldin on 3/25/23.
//  Copyright © 2023 Pavel Skaldin. All rights reserved.
//

import Foundation

@resultBuilder
public enum ConstraintBuilder {
    public static func buildBlock(_ components: [Constraint]...) -> [Constraint] {
        components.flatMap { $0 }
    }

    public static func buildExpression(_ expression: Constraint) -> [Constraint] {
        [expression]
    }

    public static func buildExpression(_ expression: [Constraint]) -> [Constraint] {
        expression
    }

    public static func buildOptional(_ components: [Constraint]?) -> [Constraint] {
        components ?? []
    }

    public static func buildEither(first components: [Constraint]) -> [Constraint] {
        components
    }

    public static func buildEither(second components: [Constraint]) -> [Constraint] {
        components
    }
}
