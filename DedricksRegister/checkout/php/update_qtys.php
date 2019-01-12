<?php

    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }
    var_dump($_POST);
    if(isset($_POST['newqtys']))
    {
        $vals = explode("|", $_POST['newqtys']);
        $i=0;
        if (isset($_SESSION['cart'])){
            foreach ($_SESSION['cart'] as $key => $sesscart){
                //echo "<br><br>";
                //var_dump($sesscart);
                //echo "<br> $vals[$i]";
                $_SESSION['cart'][$key]['qty'] = (int)$vals[$i];
                $i++;
            }
        }

        //echo "<br><br><br>";
        //var_dump($_SESSION['cart']);
        header("location: $vals[$i]");
    }

?>
