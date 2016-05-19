//: Playground - noun: a place where people can play

import UIKit

typealias Distance = Double

struct Position {
  var x: Double
  var y: Double
}

extension Position {
  func minus(p: Position) -> Position {
    return Position(x: x - p.x, y: y - p.y)
  }
  var length: Double {
    return sqrt(x * x + y * y)
  }
}

struct Ship {
  var position: Position
  var firingRange: Distance
  var unsafeRange: Distance
}

//Instead of defining an object or struct to represent regions, we represent a region by a function that determines if a given point is in the region or not
typealias Region = Position -> Bool
//returns a regiona nd taht region is a position that returns a Bool
func circle(radius: Distance) -> Region {
  return { point in point.length <= radius }
}
let circleWithRad10 = circle(10) //creating Region function with a circle with radius 10
//moves the region to thr gith and up by offset.x and offset.y
func shift(region: Region, offset: Position) -> Region {
  return { point in region(point.minus(offset)) }
}
//passing in a Region function with circl that has a radius of 10, along with the position of it
shift(circleWithRad10, offset: Position(x: 5, y:5))
//the resulting region consists of all the point soutside the original region
func invert(region: Region) -> Region {
  return { point in !region(point) }
}
//the _ overrides you having to do intersection(Region, region2: Region)
func intersection(region1: Region, _ region2: Region) -> Region {
  return { point in region1(point) && region2(point) }
}

func union(region1: Region, _ region2: Region) -> Region {
  return { point in region1(point) || region2(point) }
}

func difference(region: Region, minus: Region) -> Region {
  return intersection(region, invert(minus))
}

extension Ship {
  func canSafelyEngageShip(target: Ship, friendly: Ship) -> Bool {
    let rangeRegion = difference(circle(firingRange), minus: circle(unsafeRange))
    let firingRegion = shift(rangeRegion, offset: position)
    let friendlyRegion = shift(circle(unsafeRange), offset: friendly.position)
    let resultRegion = difference(firingRegion, minus: friendlyRegion)
    return resultRegion(target.position)
  }
}

































