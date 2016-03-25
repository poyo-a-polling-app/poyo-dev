# Poyo
The location based polling application

##Required
- [x] As a poyoker, I can create a multiple choice poll with custom fields
- [x] As a poyoker, I can see live results of the poyo
- [x] As a poyoker, I can close a poll
- [x] As a poyee, I can see all of the polls in my range
- [x] As a poyee, I can answer a poll


##Optionals
- [ ] As a poyoker, I can see the surrounding poyees on a map
- [ ] Private polling (using password distributed offline)
- [ ] Color coded answer
- [ ] Map view
- [ ] User accounts (Recorded poyoker, but anonymous poyee)
- [ ] Comments section based on anonymous characters
- [ ] Anonimity based on character
- [ ] Animated graphs for results (Pie/Egg charts)
- [ ] Images with options
- [ ] Sort table view based on vote count
- [ ] Images in question

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

<img src='http://i.imgur.com/TUZTFTh.gifv' 'title='Video Walkthrough' width='' alt='Video Walkthrough' />
