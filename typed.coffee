# This is an attempt at translating the TypeScript samples from
# https://github.com/jashkenas/coffeescript/wiki/TypeScript-Output
# into JSDoc using CoffeeScript.

# Type Annotations

greeter = (###* @type {string} ### person) ->

# Note that in constructors, param type intellisense is messed up. Maybe fixable
class Student
  #
  ###*
  # @param firstName {string}
  # @param middleInitial {string}
  # @param lastName {string}
  ###
  constructor: (@firstName, @middleInitial, @lastName) ->


#
###* @type {Array<number>} ###
list = [1, 2, 3]

# Type Assertions

# Does not work: Possible with JSDoc
# https://www.typescriptlang.org/docs/handbook/jsdoc-supported-types.html#casts
# but here, type is wrongly `HTMLElement | null` because cs compiler strips parentheses :(
# So probably impossible right now
someCanvas = ###* @type {HTMLCanvasElement} ### (document.getElementById "main_canvas")

# Nonnull assertion

liveDangerously = (###* @type {number=}) ### x) ->
  # No error
  # There is no JSDoc non-null assertion, so we need to
  # fall back to type casts, but they don't work (same as above)
  console.log (###* @type {number} ###(x)).toFixed()


# Type Predicates

#
###*
# @param pet {Student | HTMLCanvasElement}}
# @return {pet is Student}
###
isFish = (pet) ->
  pet.firstName != undefined


# Generic Functions

#
###*
# @template Type
# @param arr {Type[]}
# @return {Type}
###
firstElement = (arr) -> 
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

#
###*
# @typedef {{
#   firstName: string
#   lastName: string
# }} Person
###

# Composing Types

#
###*
# @typedef { "open" | "closed" | "minimized" } WindowStates
# @typedef { string | number } BotId
###

# Enum

#
###* @enum {number | string} ### 
BooleanLikeHeterogeneousEnum =
  No: 0
  Yes: "YES"


# Optional Parameters

###*
# @param first {string}
# @param last {string=}
###
buildName = (first, last) ->
  if last then return first + " " + last
  return first

# Public, private, and protected modifiers

class Donut
  constructor: (###* @type {string} ### name) ->
    #
    ###*
    # @private
    # @type {string}
    ###
    @id
    #
    ###* @protected ###
    @name = name
  #
  ###* @public ###
  move: (###* @type {number} ### distanceInMeters) ->
    console.log "#{@name} moved #{distanceInMeters}m."



# Readonly modifier

class Octopus
  constructor: (###* @type {string} ### name) ->
    #
    ###* @readonly ###
    @name = name
    #
    ###* @readonly ###
    @numberOfLegs = 8

# Accessors (ES6)

class Employee
  constructor: ->
    #
    ###*
    # @private
    # @type {string}
    ###
    @_fullName
# This works but does not yield in intellisense (not yet researched)
Object.defineProperty Employee, 'fullName',
  get: ->
    @_fullName
  set: (###* @type {string} ### newName) ->
    if newName.length > 10
      throw new Error "fullName has a max length of 10"
    @_fullName = newName

# Abstract Classes

# Not yet supported by JSDoc
# https://github.com/microsoft/TypeScript/issues/17227

# Declaration

# Impossible I think, but in these rare cases you can just put them in a separate file

#############################

# Test area for IntelliSense

# All blocks below should contain an error

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

#
###* @type {Person} ###
person = firstName: '123'

#
###* @type {WindowStates} ###
windowState = 'exploded'

#
##* @type {BooleanLikeHeterogeneousEnum} ##
maybe = 'maybe' # TODO: why no error?

new Donut('donut').id

o = new Octopus('octopus')
o.name = '123'
