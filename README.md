# Flutter Drawing App 
##### Changed App Icon:


![ic_launcher](https://user-images.githubusercontent.com/72070007/110005718-d03c7700-7d3e-11eb-8940-dfee0fa15c58.png)

###### App Name: Delineate_it

Screenshots of App: 


|------------|-------------|
| <img src="https://user-images.githubusercontent.com/72070007/110010001-cbc68d00-7d43-11eb-8b87-544caec5d31d.jpeg" width="250"> | <img src="https://user-images.githubusercontent.com/72070007/110010009-ce28e700-7d43-11eb-9966-2cd4dca1d524.jpeg" width="250"> 


| col 1      | col 2      |
|------------|-------------|
| <img src="https://user-images.githubusercontent.com/72070007/110010026-d3863180-7d43-11eb-972e-f43ec9bfe214.jpeg" width="250"> | <img src="https://user-images.githubusercontent.com/72070007/110010036-d719b880-7d43-11eb-8aac-fcb6fca2e384.jpeg" width="250"> 






Screen Recording: 

https://user-images.githubusercontent.com/72070007/110006426-a899de80-7d3f-11eb-84b0-75d2e4a45c5d.mp4

##### Some Features:
- The Homescreen consists of a List View made using ListView Builder which on Button click adds a new item.
- On Swiping the list item left or right it gets dismissed from the list.
- On clicking the Drawing , Drawing Screen opens which offers:
  1. Color Picker ( I chose the one which looked more elegant as compared to other color pickers)
  2. Stroke width Slider , which also changes color according to the one picked by user
  3. Clear Screen Button
  4. Save Button which saves the drawing to Firebase server

##### Some Features currently working on:
- Once the user goes back to home screen the drawing is not visible anymore which needs to be fixed
- Renaming the List Items
- Adding Search Bar once rename feature is added
- Different Pen Styles
- Undo/Redo and Erase buttons
The apk file has been uploaded along with other files (***NOTE : For devices with screen size less than 5 inches there may be a pixel overflow on the drawing screen in the apk uploaded however the code in ```DrawingScreen.dart``` has been updated to support all screen sizes***)

