//
//  PieChart.swift
//  Hotswitch
//
//  Created by Mike Maxim on 4/11/22.
//

import SwiftUI


fileprivate struct PieChartSlice : View {
  var center: CGPoint
  var radius: Double
  var startAngle: Angle
  var endAngle: Angle
  var color: Color
  var lastSlice: Bool
  
  var body: some View {
    ZStack {
    Path { path in
      path.addArc(center: center, radius: radius, startAngle: startAngle,
                  endAngle: endAngle, clockwise: false)
      path.addLine(to: center)
    }
    .fill(color)
      
    /*  Path { path in
        path.addArc(center: center, radius: radius, startAngle: startAngle,
                    endAngle: endAngle, clockwise: false)
        if !lastSlice || true {
        path.addLine(to: center)
        }
      }
      .stroke(.black, lineWidth: 6)*/
    }
    
  }
}
 
fileprivate struct DrawSpec : Hashable {
  var startAngle: Angle
  var endAngle: Angle
}

fileprivate let sliceColors : [Color] = [.blue, .red, .orange, .purple, .green]

struct PieChart: View {
  var data: [Double]
  
  fileprivate func calcDrawSpecs(center: CGPoint, radius: Double) -> [DrawSpec] {
    let total = data.reduce(0, {(x, y) in
      x + y
    })
    let circ = radius * 2 * Double.pi
    var curAngle = Angle(radians: 0)
    return data.map({(val) in
      let arcLength = val * circ / total
      let angle = Angle(radians: arcLength / radius)
      
      let startAngle = curAngle
      curAngle += angle
      let endAngle = curAngle
      
      return DrawSpec(startAngle: startAngle, endAngle: endAngle)
    })
  }
  
  
  var body: some View {
    GeometryReader { geometry in
      let width = geometry.size.width * 0.95
      let height = geometry.size.height * 0.95
      let center = CGPoint(x: geometry.size.width / 2.0, y: geometry.size.height / 2.0)
      let radius = width / 2.0
      let specs = calcDrawSpecs(center: center, radius: radius)
      ZStack {
        //PieChartSlice(center: center, radius: geometry.size.width/2.0,
        //              startAngle: .degrees(0), endAngle: .degrees(360),
         //             color: Color.black, lastSlice: true)
        ForEach(0..<specs.count, id: \.self) { index in
          let spec = specs[index]
          PieChartSlice(center: center, radius: radius, startAngle: spec.startAngle, endAngle: spec.endAngle,
                        color: sliceColors[index], lastSlice: index == specs.count-1)
        }
      }
    }
  }
}

struct PieChart_Previews: PreviewProvider {
  static var previews: some View {
    PieChart(data: [2,8,4,21,4])
      .frame(width: 500, height: 500)
      .background(Color.white)
  }
}
