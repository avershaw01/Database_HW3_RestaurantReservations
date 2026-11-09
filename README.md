# Database_HW3_RestaurantReservations
This is the group repository for Database HW3
Group Members: Nathan, Andre, Christian

#Set-Up Instructions:

Establish the library for connecting to MySQL:
 | In IntelliJ:
1. Open File → Project Structure.
2. Select Modules.
3. Select the Dependencies tab.
4. Click the + button.
5. Select JARs or Directories.
6. Navigate to lib and select your MySQL Connector/J .jar.
7. Make sure its scope is Compile.
8. Click Apply, then OK.

The .jar file is committed to the GitHub repository,
so no download is necessary.

Creating the MySQL Workbench Connection:
 | Open MySQL Workbench
1. Click the `+` icon to create a new connection
2. Fill the following fields:
   a. Connection Name = RestaurantReservations
   b. Hostname = 127.0.0.1
   c. Port = 3306
   c. Username = root (Or your configured MySQL username)
   c. Port = *** (The password you use for MySQL)
3. Open up the connection you just created
4. Next we will run the create table script to build the framework of our database
5. Select File -> Open SQL Script
6. Navigate to the repository, go to /sql/Create Table.SQL
7. Click to run the script
8. Verify it ran properly by running
```
SHOW DATABASES;

USE restaurant_db;
SHOW TABLES;
```

In summary, each user has to have their own MySQL workbench
and connection and has to execute the Java and SQL scripts independently.


Inside this repository, there are directories for organization:
/sql
    Contains sql scripts
/csv
    Contains the .csv files containing our data
/src
    Contains Java code/programs
/docs
    Contains the ERD/Crow's Foot diagrams and initial project instructions
