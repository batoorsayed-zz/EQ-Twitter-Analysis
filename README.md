# EQ-Twitter-Analysis
FYI this is a quick analysis done during 'bored' time over couple cups of tea. It could be improved upon. If you do, let me know!

Step 1 : Fire up your one and only RStudio.

Step 2 : Load up them libraries under 'Prep Work', if any missing, install. (You will definitaley not use all of 'em.)

Step 3 : setwd to your favorite directory.

Step 4 : Get your Twitter keys and secrets and tokens and all that fun stuff, then plug it right up between line 15-18.

Step 5 : Spice up your search queries as your heart wishes.

         n is the number of samples you will be pulling. Beware, you can only pull 18K at a time, then you will have to wait 
         15 mins. Don't worry, retryOnRateLimit will do that for you, just take a quick walk, or nap.
         
         lang is the language, change it if you must. Delete it if you want to get all the languages.
         
         UPDATE SINCE AND UNTIL. Twitter only allows past 10 days, so... Your past days. Unless youre rich.
         
Step 6 : write.cvs so you dont have to start all over again if R crashes.

Step 7 : If you followed these steps correctly and loaded all the libraries, you're good to go. Everthing is commented. Enjoy the analysis!


