//
//  PieChart.swift
//  Hotswitch
//
//  Created by Mike Maxim on 4/11/22.
//

import SwiftUI

private enum SliceMode {
  case stroke
  case fill
}

private struct PieChartSlice : View {
  var center: CGPoint
  var radius: Double
  var startAngle: Angle
  var endAngle: Angle
  var color: Color
  var sliceMode : SliceMode
  
  var body: some View {
    let path = Path { path in
      path.addArc(center: center, radius: radius, startAngle: startAngle,
                  endAngle: endAngle, clockwise: false)
      path.addLine(to: center)
    }
    switch (sliceMode) {
    case .fill:
      return AnyView(path.fill(color))
    case .stroke:
      return AnyView(path.stroke(color, lineWidth: 1))
    }
  }
}

private struct DrawSpec : Hashable {
  var startAngle: Angle
  var endAngle: Angle
}

private let sliceColors : [Color] = [.blue, .red, .orange, .purple, .green, .yellow,
                                         Color(NSColor.magenta.cgColor),
                                         Color(NSColor.brown.cgColor),
                                         Color(NSColor.cyan.cgColor),
                                         Color(NSColor.gray.cgColor),
                                         Color(NSColor.darkGray.cgColor)]

private struct SliceHoverInfo {
  var data: PieData
  var perc: Double
  var point: CGPoint
}

private struct SliceHoverView : View {
  fileprivate var info : SliceHoverInfo
  
  private func getPosition() -> CGPoint {
    var ret = info.point
    ret.y -= 20
    return ret
  }
  
  var body: some View {
    VStack {
      Text(info.data.label)
      Text(String(format: "%.2g%%", info.perc))
    }
    .padding(.horizontal, 16)
    .padding([.top, .bottom], 8)
    .font(.headline)
    .background(Color(.sRGB, white: 1, opacity: 0.8))
    .foregroundColor(Color.black)
    .cornerRadius(8)
    .position(getPosition())
  }
}

struct PieData {
  var label : String
  var value : Double
}

struct PieChart: View {
  var data: [PieData]
  @State private var hoverInfo : SliceHoverInfo?
  
  private func sumData() -> Double {
    data.reduce(0, { $0 + $1.value })
  }
  
  private func calcDrawSpecs(center: CGPoint, radius: Double) -> [DrawSpec] {
    let total = sumData()
    let circ = radius * 2 * Double.pi
    var curAngle = Angle(radians: 0)
    return data.map({(val) in
      let arcLength = val.value * circ / total
      let angle = Angle(radians: arcLength / radius)
      
      let startAngle = curAngle
      curAngle += angle
      let endAngle = curAngle
      
      return DrawSpec(startAngle: startAngle, endAngle: endAngle)
    })
  }
  
  private func dist(_ p1: CGPoint, _ p2: CGPoint) -> Double {
    return Double(hypotf(Float(p1.x) - Float(p2.x), Float(p1.y) - Float(p2.y)))
  }
    
  private func hoverInfoFromMouse(mouse nsmouse: NSPoint, center: CGPoint, radius: Double) -> SliceHoverInfo? {
    let mouse = NSPointToCGPoint(nsmouse)
    let distCenter = dist(NSPointToCGPoint(mouse), center)
    if distCenter > radius {
      return nil
    }
    let d = dist(NSPointToCGPoint(mouse), CGPoint(x: center.x+distCenter, y: center.y))
    var theta = acos(1 - (d*d)/(2*distCenter*distCenter))
    if mouse.y < center.y {
      theta = (Double.pi - theta) + Double.pi
    }
    let specs = calcDrawSpecs(center: center, radius: radius)
    var specIndex = 0
    for i in 0..<specs.count {
      if theta < specs[i].endAngle.radians {
        specIndex = i
        break
      }
    }
    let dat = data[specIndex]
    let perc = dat.value / sumData() * 100.0
    return SliceHoverInfo(data: dat, perc: perc, point: mouse)
  }
  
  var body: some View {
    GeometryReader { geometry in
      let frame = geometry.frame(in: .global)
      let _ = print(frame)
      let width = geometry.size.width * 0.95
      let height = geometry.size.height * 0.95
      let center = CGPoint(x: geometry.size.width / 2.0, y: geometry.size.height / 2.0)
      let radius = min(height / 2.0, width / 2.0)
      let specs = calcDrawSpecs(center: center, radius: radius)
      ZStack {
        ForEach(0..<specs.count, id: \.self) { index in
          let spec = specs[index]
          PieChartSlice(center: center, radius: radius, startAngle: spec.startAngle, endAngle: spec.endAngle,
                        color: sliceColors[index], sliceMode: .fill)
        }
        ForEach(0..<specs.count, id: \.self) { index in
          let spec = specs[index]
          PieChartSlice(center: center, radius: radius, startAngle: spec.startAngle, endAngle: spec.endAngle,
                        color: .black, sliceMode: .stroke)
        }
        if hoverInfo != nil {
          SliceHoverView(info: hoverInfo!)
        }
      }
      .trackingMouse(onMove: {
        hoverInfo = hoverInfoFromMouse(mouse: $0, center: center, radius: radius)
      })
      
    }
  }
}

struct PieChart_Previews: PreviewProvider {
  static var previews: some View {
    PieChart(data: [PieData(label: "Keybase", value: 2),
                    PieData(label: "Google Chrome", value: 8),
                    PieData(label: "Code", value: 4),
                    PieData(label: "Xcode", value: 21),
                    PieData(label: "Finder", value: 4)])
      .frame(width: 500, height: 500)
      .background(Color.white)
    SliceHoverView(info: SliceHoverInfo(data: PieData(label: "Keybase", value: 10), perc: 25.3,
                                        point: CGPoint(x: 100, y: 100)))
    .frame(width: 200, height: 200)
  }
}
