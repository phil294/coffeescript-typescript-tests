# This is an attempt at translating the TypeScript samples from
# https://github.com/jashkenas/coffeescript/wiki/TypeScript-Output
# into JSDoc using CoffeeScript.

# Type Annotations

greeter = (person ~ string) ->

# Note that in constructors, param type intellisense is messed up. Maybe fixable
class Student
  constructor: (@firstName ~ string, @middleInitial ~ string, @lastName ~ string) ->


list ~ number[] = [1, 2, 3]

# Type Assertions

# Does not work: Possible with JSDoc
# https://www.typescriptlang.org/docs/handbook/jsdoc-supported-types.html#casts
# but here, type is wrongly `HTMLElement | null` because cs compiler strips parentheses :(
# So probably impossible right now
someCanvas = ###* @type {HTMLCanvasElement} ### (document.getElementById "main_canvas")

# Nonnull assertion

liveDangerously = (x? ~ number) ->
  # No error
  # There is no JSDoc non-null assertion, so we need to
  # fall back to type casts, but they don't work (same as above)
  console.log (###* @type {number} ###(x)).toFixed()


# Type Predicates

###*
# @return {pet is Student}
###
isFish = (pet ~ typeof Student | HTMLCanvasElement) ->
  pet.firstName != undefined


# Generic Functions

firstElement = <Type>(arr ~ Type[]) ~ Type -> 
  arr[0]

# Function Overloads

# There's no proper function overloading via TS JSDoc yet
# https://github.com/microsoft/TypeScript/issues/25590
# So the below does not work

#
###*
# @param timestamp {number}
# @return {Date}
###
#
###*
# @param m {number}
# @param d {number}
# @param y {number}
# @return {Date}
###
makeDate = (mOrTimestamp, d, y) -> 
  if d? and y?
    new Date y, mOrTimestamp, d
  else
    new Date mOrTimestamp

d1 = makeDate 12345678
d2 = makeDate 5, 5, 5

# Interfaces

`interface Person {
  firstName: string
  lastName: string
}`

# Composing Types

`type WindowStates = "open" | "closed" | "minimized"`
`type BotId = string | number`

# Enum

`enum BooleanLikeHeterogeneousEnum {
  No: 0,
  Yes: "YES"
}`

# Optional Parameters

buildName = (first ~ string, last? ~ string) ->
  if last then return first + " " + last
  return first

# Public, private, and protected modifiers

class Donut
  constructor: (name ~ string) ->
    ###*
    # @private
    # @type {string}
    ###
    @id
    ###* @protected ###
    @name = name
  #
  ###* @public ###
  move: (distanceInMeters ~ number) ->
    console.log "#{@name} moved #{distanceInMeters}m."



# Readonly modifier

class Octopus
  constructor: (name ~ string) ->
    ###* @readonly ###
    @name = name
    ###* @readonly ###
    @numberOfLegs = 8

# Accessors (ES6)

class Employee
  constructor: ->
    ###*
    # @private
    # @type {string}
    ###
    @_fullName
# This works but does not yield in intellisense (not yet researched)
Object.defineProperty Employee, 'fullName',
  get: ->
    @_fullName
  set: (newName ~ string) ->
    if newName.length > 10
      throw new Error "fullName has a max length of 10"
    @_fullName = newName

# Abstract Classes

# Not yet supported by JSDoc
# https://github.com/microsoft/TypeScript/issues/17227

# Declaration

`declare global {
  interface Array<T> {
    toObservable(): Promise<T>;
  }
}`
export default {}

Array::toObservable = -> Promise.resolve @

#############################

# Test area for IntelliSense

# All blocks below should contain an error

numbr = 1
numbr = '1'

greeter 123

new Student('a', 'b', 123)

new Student('a', 'b', 'c').invalidProp

list.push '123'

pet =
  if Math.random() > 0.5
    new HTMLCanvasElement
  else
    new Student 'a','b','c'
if isFish pet
  pet.normalize()

firstElement(["1", "2"]).toFixed()

person ~ Person = firstName: '123'
#
windowState ~ WindowStates = 'exploded'

maybe ~ BooleanLikeHeterogeneousEnum = 'maybe'

new Donut('donut').id

o = new Octopus('octopus')
o.name = '123'
