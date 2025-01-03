//
//  MoodShape.swift
//  Moody?
//
//  Created by Jack Herrmann on 22.02.21.
//
//
//import SwiftUI
//import CoreGraphics
//
//struct HexagonParameters {
//    struct Segment {
//        let line: CGPoint
//        let curve: CGPoint
//        let control: CGPoint
//    }
//
//    static let adjustment: CGFloat = 0.008
//
//    static let segments = [
//        Segment(
//            line:    CGPoint(x: 0.60, y: 0.05),
//            curve:   CGPoint(x: 0.40, y: 0.05),
//            control: CGPoint(x: 0.50, y: 0.00)
//        ),
//        Segment(
//            line:    CGPoint(x: 0.05, y: 0.20 + adjustment),
//            curve:   CGPoint(x: 0.00, y: 0.30 + adjustment),
//            control: CGPoint(x: 0.00, y: 0.25 + adjustment)
//        ),
//        Segment(
//            line:    CGPoint(x: 0.00, y: 0.70 - adjustment),
//            curve:   CGPoint(x: 0.05, y: 0.80 - adjustment),
//            control: CGPoint(x: 0.00, y: 0.75 - adjustment)
//        ),
//        Segment(
//            line:    CGPoint(x: 0.40, y: 0.95),
//            curve:   CGPoint(x: 0.60, y: 0.95),
//            control: CGPoint(x: 0.50, y: 1.00)
//        ),
//        Segment(
//            line:    CGPoint(x: 0.95, y: 0.80 - adjustment),
//            curve:   CGPoint(x: 1.00, y: 0.70 - adjustment),
//            control: CGPoint(x: 1.00, y: 0.75 - adjustment)
//        ),
//        Segment(
//            line:    CGPoint(x: 1.00, y: 0.30 + adjustment),
//            curve:   CGPoint(x: 0.95, y: 0.20 + adjustment),
//            control: CGPoint(x: 1.00, y: 0.25 + adjustment)
//        )
//    ]
//}
//
//struct MoodShape: View{
//
//    var moodColor: Color = .red
//
//    var body: some View {
//        GeometryReader { geometry in
//            Path { path in
//                var width: CGFloat = min(geometry.size.width, geometry.size.height)
//                let height = width
//                let xScale: CGFloat = 0.832
//                let xOffset = (width * (1.0 - xScale)) / 2.0
//                width *= xScale
//                path.move(
//                    to: CGPoint(
//                        x: width * 0.95 + xOffset,
//                        y: height * (0.20 + HexagonParameters.adjustment)
//                    )
//                )
//
//                HexagonParameters.segments.forEach { segment in
//                    path.addLine(
//                        to: CGPoint(
//                            x: width * segment.line.x + xOffset,
//                            y: height * segment.line.y
//                        )
//                    )
//
//                    path.addQuadCurve(
//                        to: CGPoint(
//                            x: width * segment.curve.x + xOffset,
//                            y: height * segment.curve.y
//                        ),
//                        control: CGPoint(
//                            x: width * segment.control.x + xOffset,
//                            y: height * segment.control.y
//                        )
//                    )
//                }
//            }
//            .fill(moodColor)
//            .animation(nil)
//        }
//        .aspectRatio(1, contentMode: .fit)
//    }
//}
//
//struct BadgeBackground_Previews: PreviewProvider {
//    static var previews: some View {
//        MoodShape()
//    }
//}
