# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

# MineSweeper

# Analysis

- Board:
  - Generate new boards
    - Visit root url to generate
      - Email, board width, board height, number of mines, board name
      - Button submit named “Generate Board”, submitted then
        - store in db
        - redirect to detail page of created board
        - Use icon as requirements to display empty cells and bombs
      - Limit width and height
      - Number of mine <= width\*height
  - View previous boards
- Home page:
  - List out 10 most recently created boards
  - Each list item has: name of board, email creator, created date (nicely formatted)
  - Title of board as a link to detail
  - At last of the list, a LINK reads “View all generated boards” -> link to a page list all
    - Can pagination in this list all page
    - Can filter by board name, creator, created date
- Return 2D array of objects present state of a minesweeper
