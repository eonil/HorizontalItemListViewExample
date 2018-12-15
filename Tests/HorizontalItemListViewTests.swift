//
//  HorizontalItemListViewTests.swift
//  HorizontalItemListViewTests
//
//  Created by Henry on 2018/12/15.
//  Copyright © 2018 Henry. All rights reserved.
//

import XCTest
@testable import HorizontalItemListView

class HorizontalItemListViewTests: XCTestCase {

    func testNoInfiniteLoop() {
        var le = LayoutEngine()
        le.config.itemHeight = 30
        le.config.wordSpacing = 5
        le.config.lineSpacing = 10
        le.config.maxLineCount = 5
        le.config.containerWidth = 500
        let items = [
            CGSize(width: 100, height: 100),
            CGSize(width: 40, height: 40),
            CGSize(width: 20, height: 20),
            CGSize(width: 130, height: 130),
            CGSize(width: 60, height: 60),
            CGSize(width: 100, height: 100),
            CGSize(width: 40, height: 40),
            CGSize(width: 20, height: 20),
            CGSize(width: 130, height: 130),
            CGSize(width: 60, height: 60),
            CGSize(width: 100, height: 100),
            CGSize(width: 40, height: 40),
            CGSize(width: 20, height: 20),
            CGSize(width: 130, height: 130),
            CGSize(width: 60, height: 60),
            ]
        let (_, fs) = le.findBoundingWidthAndFrames(for: items)
        XCTAssertEqual(fs.count, items.count)
    }
    func testZeros() {
        var le = LayoutEngine()
        le.config.itemHeight = 0
        le.config.wordSpacing = 0
        le.config.lineSpacing = 0
        le.config.maxLineCount = 0
        le.config.containerWidth = 0
        let items = [
            CGSize(width: 100, height: 100),
            CGSize(width: 40, height: 40),
            CGSize(width: 20, height: 20),
            CGSize(width: 130, height: 130),
            CGSize(width: 60, height: 60),
            CGSize(width: 100, height: 100),
            CGSize(width: 40, height: 40),
            CGSize(width: 20, height: 20),
            CGSize(width: 130, height: 130),
            CGSize(width: 60, height: 60),
            CGSize(width: 100, height: 100),
            CGSize(width: 40, height: 40),
            CGSize(width: 20, height: 20),
            CGSize(width: 130, height: 130),
            CGSize(width: 60, height: 60),
            ]
        let (_, fs) = le.findBoundingWidthAndFrames(for: items)
        XCTAssertEqual(fs.count, items.count)
    }

}
