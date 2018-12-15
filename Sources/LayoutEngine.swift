//
//  LayoutEngine.swift
//  HorizontalItemListView
//
//  Created by Henry on 2018/12/15.
//  Copyright © 2018 Henry. All rights reserved.
//

import Foundation
import CoreGraphics

///
/// Finds layout for horizontally flowing tags precisely.
///
/// Worst Case Time Complexity: O(n log n)
///
struct LayoutEngine {
    var config = Config()
    struct Config {
        var itemHeight = CGFloat(50)
        var wordSpacing = CGFloat(10)
        var lineSpacing = CGFloat(10)
        ///
        /// Layout algorithm try to find most line count near this value,
        /// but never ovrflow this.
        ///
        var maxLineCount = 5
        ///
        /// If there's too few items, so it cannot fill
        /// the container height, it should fill the container width first.
        ///
        var containerWidth = CGFloat(500)
    }

    typealias Measurement = (boundingWidth: CGFloat, itemFrames: [CGRect])
    func findBoundingWidthAndFrames(for items: [CGSize]) -> Measurement {
        guard items.count > 0 else { return (0, []) }
        // `totalW` is for the case of `maxLineCount == 1`.
        // Perform binary search for proper bounding width.
        let tolerance = CGFloat(1)
        // Includes ending word spacing for simpler calculation.
        let totalWidth = items.map({ $0.width }).reduce(0, +) + (config.wordSpacing * CGFloat(items.count - 1)) + tolerance
        let boundingWidthRange = config.containerWidth < totalWidth
            ? config.containerWidth..<totalWidth
            : config.containerWidth..<config.containerWidth
        // 1. divide range into two parts.
        // 2. measure line count range.
        // 3. choose range part which contains the line count.
        //    until only one remains.
        var r = boundingWidthRange
        var m = [CGFloat: LineList]()
        for _ in 0..<items.count {
            let w1 = r.lowerBound
            let w2 = r.lowerBound + round((r.upperBound - r.lowerBound) / 2)
            let w3 = r.upperBound
            let lines1 = findMinimumLines(for: items, in: w1, memo: &m)
            let lines2 = findMinimumLines(for: items, in: w2, memo: &m)
            let lines3 = findMinimumLines(for: items, in: w3, memo: &m)
            if lines3.count == config.maxLineCount { return (w3, lines3.flatMap({$0})) }
            if lines2.count == config.maxLineCount { return (w2, lines2.flatMap({$0})) }
            if lines1.count == config.maxLineCount { return (w1, lines1.flatMap({$0})) }
            if (lines3.count..<lines2.count).contains(config.maxLineCount) {
                r = w2..<w3
                continue
            }
            if (lines2.count..<lines1.count).contains(config.maxLineCount) {
                r = w1..<w2
                continue
            }
            // All three widths are same.
            // Just use referentially smallest one.
            return (w1, lines1.flatMap({$0}))
        }
        fatalError("It seems this algorithm has serious bug and running infinite loop...")
    }

    ///
    /// - Parameter memo:
    ///     Cache of this operation result.
    ///     This assumes you are providing same cache only for same `items`.
    ///
    private func findMinimumLines(for items: [CGSize], in boundingWidth: CGFloat, memo : inout [CGFloat: LineList]) -> LineList {
        if let cc = memo[boundingWidth] { return cc }
        guard items.count > 0 else { return [] }
        var p = CGPoint.zero
        var a = LineList()
        a.append(Line())
        func appendWord(_ f: CGRect) {
            a[a.count - 1].append(f)
        }
        func appendLine() {
            a.append(Line())
            p.x = 0
            p.y += config.itemHeight
            p.y += config.lineSpacing
        }
        for item in items.map({ CGSize(width: $0.width, height: config.itemHeight) }) {
            assert(a.count >= 0)
            // Append item frame...
            // Begine a new transaction in an isolated context...
            var p1 = p
            p1.x += item.width
            if p1.x < boundingWidth {
                // Make up a frame from before-movement point.
                let f = CGRect(origin: p, size: item)
                appendWord(f)
                // Commit transaction.
                p = p1

                // Append word spacing...
                p.x += config.wordSpacing
                if !(p.x <= boundingWidth) {
                    appendLine()
                }
            }
            else {
                // Abandon transaction. (rollback)
                appendLine()
                let f = CGRect(origin: p, size: item)
                appendWord(f)
            }
        }
        memo[boundingWidth] = a
        return a
    }
    private typealias LineList = [Line]
    private typealias Line = [CGRect]
}












