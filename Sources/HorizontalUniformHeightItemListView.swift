//
//  HorizontalUniformHeightItemListView.swift
//  HorizontalUniformHeightItemListView
//
//  Created by Henry on 2018/12/15.
//  Copyright © 2018 Henry. All rights reserved.
//

import Foundation
import UIKit

///
/// - Note:
///     You cannot use this view in IB because IB cannot use generic UIView classes.
///     Instead, make another view which contains this view inside.
///
///
@IBDesignable
final class HorizontalUniformHeightItemListView: UIView {
    private let scrollView = UIScrollView()
    private var layoutEngine = LayoutEngine(
        config: LayoutEngine.Config(
            itemHeight: 30,
            wordSpacing: 5,
            lineSpacing: 10,
            maxLineCount: 10,
            containerWidth: 100))
    private func install() {
        addSubview(scrollView)
        var r = SystemRandomNumberGenerator()
        func rfx() -> Int {
            return Int(r.next() % UInt64(Int.max))
        }
        var ws = [10, 20, 30, 40, 50, 60, 70, 80, 90] as [CGFloat]
        for _ in 0..<100 {
            let v = UIView()
            v.backgroundColor = .red
            let a = ws[rfx() % ws.count]
            let b = ws[rfx() % ws.count]
            v.frame.size = CGSize(width: a, height: b)
            scrollView.addSubview(v)
        }
    }

    ////

    public struct Config {
        public var itemHeight = CGFloat(50)
    }

    ////

    override init(frame: CGRect) {
        super.init(frame: frame)
        install()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        install()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        layoutEngine.config.containerWidth = bounds.width
        let zs = scrollView.subviews.map({ $0.frame.size })
        let (w,fs) = layoutEngine.findBoundingWidthAndFrames(for: zs)
        fs.enumerated().forEach({ i,f in scrollView.subviews[i].frame = f })
        scrollView.contentSize = CGSize(width: w, height: fs.last?.maxY ?? 0)
    }
}
