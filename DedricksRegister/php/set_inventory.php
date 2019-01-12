<?php

    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }
    require ('../php/db_con.php');

    // $itemQ = mysqli_query($con, "SELECT * FROM Item");
    // $inventory = array(); 
    // while($row = mysqli_fetch_assoc($itemQ))
    // {
    //     $inventory[] = $row;
    // }
    // $_SESSION['inventory'] = $inventory;


    $measQ = mysqli_query($con, "SELECT * FROM Measurement");
    $measurements = array();
    while($row = mysqli_fetch_assoc($measQ))
    {
        $_SESSION['measurements'][$row['MeasID']] = $row['Measurement'];

    }

    
?>