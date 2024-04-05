//
//  GradienteViewModifier.swift
//  Gradiente
//
//  Created by Nico on 02/04/24.
//

import SwiftUI

public enum Position {
    case top
    case bottom
    
    var shadowGradient: LinearGradient {
        switch self {
        case .top:
            return LinearGradient(
                colors: [.clear, Color(.systemBackground)],
                startPoint: UnitPoint(x: 0, y: -0.25),
                endPoint: UnitPoint(x: 0, y: 1)
            )
        case .bottom:
            return LinearGradient(
                colors: [Color(.systemBackground), .clear],
                startPoint: UnitPoint(x: 0, y: 0),
                endPoint: UnitPoint(x: 0, y: 1.25)
            )
        }
    }
}

public struct Gradiente: ViewModifier {
    
    @State var position: Position
    @State var colors: [Color]?
    @State var gradient: Gradient?
    @State var opacity: Double
    @State var height: CGFloat
    
    init(position: Position, opacity: Double, height: CGFloat, colors: [Color]) {
        var colors = colors
        if colors.count > 1, colors.first != colors.last, let first = colors.first {
            colors.append(first)
        }
        if position == .bottom {
            colors.reverse()
        }
        self.colors = colors
        self.position = position
        self.opacity = opacity
        self.height = height
    }
    
    init(position: Position, opacity: Double, height: CGFloat, gradient: Gradient) {
        self.position = position
        self.gradient = gradient
        self.opacity = opacity
        self.height = height
    }
    
    func body(content: Content) -> some View {
        ZStack {
            VStack {
                
                if position == .bottom {
                    Spacer()
                }
                
                ZStack {
                    Rectangle()
                        .fill(angularGradient)
                        .blur(radius: 50.0, opaque: true)
                        .clipped()
                        .opacity(opacity)
                    
                    Rectangle()
                        .fill(position.shadowGradient)
                }
                .frame(height: height)
                
                if position == .top {
                    Spacer()
                }
            }
            .ignoresSafeArea()
            
            content
                .background(.clear)
        }
    }
    
    var angularGradient: AngularGradient {
        let center = UnitPoint(x: 0.5, y: 0.5)
        if let gradient {
            return AngularGradient(gradient: gradient, center: center)
        } else if let colors {
            return AngularGradient(colors: colors, center: center)
        } else {
            return AngularGradient(colors: [.accentColor], center: center)
        }
    }
}

extension View {
    public func gradienteBackground(position: Position = .top,
                                    opacity: Double = 1.0,
                                    height: CGFloat = 300.0,
                                    colors: [Color]) -> some View {
        modifier(Gradiente(position: position, opacity: opacity, height: height, colors: colors))
    }
    
    public func gradienteBackground(position: Position = .top,
                                    opacity: Double = 1.0,
                                    height: CGFloat = 300.0,
                                    gradient: Gradient) -> some View {
        modifier(Gradiente(position: position, opacity: opacity, height: height, gradient: gradient))
    }
}