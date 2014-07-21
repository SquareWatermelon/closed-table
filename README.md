Raul Matias rem214
Robert Tolda rmt2131

Project 1

Website name: Closed Table

Access to site: 
user: square
password: blobfish 

Access to closed table as admin:
user: GradeMan
passord: GoodJob!

Use:

(IE not fully supported)
A user first logs in using their name and password.  If a user forgets their 
password, they can click the question mark next to it which will bring them to a
screen where they can have temporary password emailed to them.
They can also change their password once they log in. 
Regular users can view a interactive table where they can click to make or 
remove a reservation. They can also change their password, or view their history..
Admins can do all this and view total history, add and remove tables, add and 
remove users, and create and view a PDF of the reservations.


Front end: Robert Tolda
CSS:
    Various files for formating the document.
    Buttons
    CT.css
    Table.css
Images:
    Various images some for fun others for formating such as the corners
HTML in Pages:
    Various HTML files that are used in printing out pages.
Scripts:
    executer.pm: 
        Takes the given state and performs the appropriate action.
    validater.pm: 
        Handles the second stage of validation and Contains functions to 
        validate input strings.
    logger.pm: 
        For functions that only handle logging.
    misc: 
        Various useful functions.
    general.js:
        Some java script, mostly to help with the forms and page transfers.
    navPrinter.pm:
        Contains methods for printing out the Navigation bar.
    tablePrinter.pm:
        Contains methods for printing out the reservations tables.
    printer.pm:
        Contains methods for printing out the pages in general. The 3rd phase.
    ClosedTable.pl.cgi:
        The Main Controller which directs the execution of the program though 
        validation execution and response phases. 
Back end: Raul Matias
file:
tableMaker.pm
reservations.pm
userDatabase.pm
For the Back end I decided to store the information in text files. I decided to go this
route because I have no experience with databases and we needed a way to store the information.
The work is done by three perl files. The first is userDatabase.pm. This module
contains all the functions for creating and deleting users. reservations.pm contains the functions
for making reservation. tableMaker.pm is used for creating tables and their seating capacity. I used
md5 for the passwords and PDF::API2 for printing the pdf.

Other:
    The foreign folder contains the scripts we did not make ourselves.

Experience:
We had a great experience working on this project. We worked we'll together and learned a lot.
I (Raul) would also like to say that even though I did the back end, Robert helped me a great deal.
He has more experience than me and he helped me when I got get stuck. 
