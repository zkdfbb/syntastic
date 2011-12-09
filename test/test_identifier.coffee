path = require 'path'
vows = require 'vows'
assert = require 'assert'
coffeelint = require path.join('..', 'lib', 'coffeelint')


vows.describe('identifiers').addBatch({

    'Camel cased class names' :

        topic : """
            class Animal

            class Wolf extends Animal

            class BurmesePython extends Animal

            class Band

            class ELO extends Band

            class Eiffel65 extends Band
            """

        'are valid by default' : (source) ->
            errors = coffeelint.lint(source)
            assert.isEmpty(errors)

    'Non camel case class names' :

        topic : """
            class animal

            class wolf extends Animal

            class Burmese_Python extends Animal

            class canadaGoose extends Animal
            """

        'are rejected by default' : (source) ->
            errors = coffeelint.lint(source)
            assert.lengthOf(errors, 4)
            error = errors[0]
            assert.equal(error.line, 0)
            assert.equal(error.reason,  'Invalid class name')
            assert.equal(error.evidence,  'animal')

        'can be permitted' : (source) ->
            errors = coffeelint.lint(source, {camelCaseClasses: false})
            assert.isEmpty(errors)

}).export(module)
