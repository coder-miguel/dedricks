<?php

    
    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }

    if(isset($_POST)){
        require("../php/db_con.php");

        mysqli_query($con, "INSERT INTO Cart() VALUES ()");
        $results = mysqli_query($con, "SELECT cartid FROM cart ORDER BY cartid DESC LIMIT 1");
        $cartid  = mysqli_fetch_assoc($results)['cartid'];

        foreach ($_POST as $posted)
        {
            $vars = explode("|", $posted);
            $itemcode  = $vars[0];
            $qtymeas   = $vars[1];
            $index     = $itemcode."".$qtymeas;
            $amttosell = $_SESSION['cart'][$index]['qty'];
            
            $prep = mysqli_stmt_init($con);
            $prep = mysqli_prepare($con, "INSERT INTO Cart_Item(CartID, ItemCode, AmtToSell, MeasQuantity) VALUES(?, ?, ?, ?)");
            mysqli_stmt_bind_param($prep, "ssss", $cartid, $itemcode, $amttosell, $qtymeas);
            mysqli_execute($prep);

        }
        unset($_SESSION['cart']);
    }
    $return = urldecode($_SESSION['return']);
    header("location: ../checkout?cashout=success");






?>