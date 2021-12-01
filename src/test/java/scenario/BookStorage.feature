Feature: Book storage feature

  Background:
    * url baseUrl

  @Test
  Scenario: ST001.Check books stored on the server
    Given url baseUrl
    And path 'books'
    When method GET
    Then status 200
    And match response == '#[0]'

  @Test
  Scenario: ST002.Check book request data
    Given url baseUrl
    And path 'books'
    And request {"author": "testAuthor"}
    When method PUT
    Then match response.error == "Field 'title' is required"
    And path 'books'
    And request {"title": "testTitle"}
    When method PUT
    Then match response.error == "Field 'author' is required"

  @Test
  Scenario Outline: ST003.Check field cannot be empty
    Given url baseUrl
    And path 'books'
    And request {"author": "<author>","title": "<title>"}
    When method PUT
    Then match response.error == "Field '<field>' cannot be empty."
    Examples:
      | author | title | field  |
      |        | test  | author |
      | testau |       | title  |

  @Test
  Scenario: ST004.Check field cannot be empty
    Given url baseUrl
    And path 'books'
    And request {"author": "<author>","title": "<title>","id":1}
    When method PUT
    Then match response.error == "id field is read−only"

  @Test
  Scenario: ST005.Check field cannot be empty
    Given url baseUrl
    And path 'books'
    And request {"author": "testAuthor","title": "testTitle"}
    When method PUT
    Then status 200
    And def bookId = response.id
    And path 'books/' + bookId
    When method Get
    Then status 200
    And match response.author == "testAuthor"
    And match response.title == "testTitle"

  @Test
  Scenario: ST006.Check duplicate book
    Given url baseUrl
    And path 'books'
    When method Get
    Then status 200
    And def firstAuthor == response.author[0]
    And def firstTitle == response.title[0]
    And path 'books'
    And request {"author": firstAuthor,"title": firstTitle}
    When method PUT
    Then match response.error == "Another book with similar title and author already exists"