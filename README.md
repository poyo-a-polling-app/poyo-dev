# Poyo
The location based polling application

##Required
- [x] As a poyoker, I can create a multiple choice poll with custom fields
- [x] As a poyoker, I can see live results of the poyo
- [x] As a poyoker, I can close a poll
- [x] As a poyee, I can see all of the polls in my range
- [x] As a poyee, I can answer a poll


##Optionals
- [x] Asynchronous network connection and delayed Parse update
- [x] Color coded answer
- [x] Images with options (add-images branch can perfrom action)
    - [ ] Selfie feature
- [x] Comments section
    - [ ] Comments identified with anonymous characters
- [ ] Sort table view based on vote count
- [ ] Private polling (using password distributed offline) {1}
    - [ ] Credentials: Author Username and Distribution Key
- [ ] Map view of Answers to Poyos
- [x] User accounts (Recorded poyoker, but anonymous poyee)
- [x] Images in question
- [ ] Auto-fill question based on answer
    - [ ] Have a switch for custom question text
- [ ] Push notifications for comment on your Poyo
- [ ] Push notifications for votes on Poyo (occasional total)
- [ ] Push notifications for closed Poyo

##Super Optional
- [ ] Surrounding poyos on a map
- [ ] User color defaults for options
- [ ] Overall user statistics (total votes, total poyos, hatched since)
- [ ] Date limit


## UI Optionals
- [ ] Launch screen loader
- [ ] Blank screen for main feed
- [ ] Blank screen for user account
- [ ] Animated bar for resulting bar graph
- [ ] Color of answer based on image (might not be best)

###Date Recording
* Per User
* Answer to poll
* Datetime
* Location
* General
* Amount of votes recently (per time)

##Data Fields:

###User
* Poyos ([NSDictionary])
* Username
* Password
* Profile Picture
* Location
* user_id

###Poyo
* Question
* Options ([NSDictionary])
* text
* amount_of_votes
* image
* created_at
* creator_id
* poyo_id
* public / private boolean
* password (null for public)
* end_time
* number_of_answers

##Sprint 1

<img src='http://i.imgur.com/BCLkOxh.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

##Sprint 2

<img src='http://i.imgur.com/VBp6NQ9.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

##Sprint 3

<img src='http://i.imgur.com/TUZTFTh.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

##Sprint 4 - optionals

<img src='http://i.imgur.com/9VccgIu.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
