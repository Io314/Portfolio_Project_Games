##### **Overview**
This is a small project on video game sales I did, mainly to familiarize myself with SQL, Tableau and Python.
The data set includes the number of copies sold (in millions) for each video game, in each region and for each platform it was released for. It also contains information about the game's genre, its publisher and the year it was released.
This means that a single game title can be found multiple times in different rows, 'Dark Souls' for example has 12 entries, as it was released in 3 different consoles and there are 4 regions categorized in this set.


##### **Project Components**
1. In the first part I explore the data using MySQL, creating new tables as well as inspecting the top sales for each game, genre, region and the sales of each genre per year.

2. After exploring the data as tables, Tableau was used to [visualize](https://public.tableau.com/app/profile/john.lagatoras/viz/game_sales_17303126486020/Dashboard2#2) game sales per title and per genre in each region, givng insights on how each of the major gaming communities, during the timeframe of the data, (NA, EU, JP) differ in preferences.

3. Lastly, I tried building machine learning model in Python (jupyter Notebook), in an attempt to predict a game's success based only on the information available in this data set.


It is important to note that because the data set does not include a variety of information, the results are quite limited. Especially the prediction model, as it is obviously very hard to successfully predict the success of a game given only
its genre, publisher and console. These aspects could be completely irrelevant if proper modeling parameters were used, however i tried to challenge myself to see what I could achieve with this specific information. The result, as expected,
was not accurate at all, as the model predicted a lot more successes than there were in the testing set.



**[Source](https://www.databasestar.com/sample-database-video-games/)**
