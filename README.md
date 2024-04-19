  # NBAPal
<p align="center">
  <img src= "https://github.com/RomanAuersvald/NBAPal/assets/23071333/ba8308f4-0af7-49d7-9c60-cc565a1aec7d">
</p>

The project uses MVVM-C pattern for navigation control between views and to separate navigation logic code from SwiftUI and view itself. In addition Combine is used for data realted operations and navigation actions management.

Basic functionality:
  - Load list of NBA players where Players Name, Surname, Team Position and Team Name is showed.
    -  Results are paged after 35 items and new Players are loaded when reaching bottom of list.
  - Player selection shows Player's Detail.
  - Player's Detail has the possibility to show Player's Team Info.

App integrates https://app.balldontlie.io/ API for Player Data and Team Data loading.

Features:
  - Searching in Players list - for each search text is created new search query to server, then results are shown in Players List.
  - Team Hometown map - shown in Team View if possible to reverse geocode location data from teams hometown name.
  - App is localized for English and Czech languages.


