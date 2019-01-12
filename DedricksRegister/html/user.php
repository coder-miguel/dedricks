<?php 
    include ('../php/session.php');
    $_SESSION['user'] = 'user';
?>
<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
        <title>User Page</title>
        <link href="../css/style.css" rel="stylesheet" type="text/css">
    </head>


    <body>
        <div class='navigation' id='nav_bar'>
            <ul>
                <li><a href="index.php">Login</a></li>
                <li><a href="html/contact.php">About/Contact</a></li>
                <li><a href="html/order.php">Order Online</a></li>
                <li><a href="html/inventory.php">Inventory</a></li>
                <li><a href="html/bakery.php">Bakery</a></li>
                <li><a href="html/comments.php">Comments</a></li>
            </ul>
        </div>
    </body>


</html>