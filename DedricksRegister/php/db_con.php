<?php
    // setup variables
    $server_name = "localhost";// or 127.0.0.1
    $user_name   = "root";
    $password    = "";
    $db_name     = "dedricks";


    // establish a connection to mysql
    // API: http://php.net/manual/en/book.mysqli.php
    $con = mysqli_connect($server_name, $user_name, $password, $db_name);

    if(!$con) {die("Connection Failed: ".mysqli_connect_error());}


?>