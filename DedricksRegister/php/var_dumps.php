<?php

    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }
    unset($_SESSION['cart']);
    unset($_SESSION['inventory']);
    var_dump($_SESSION);
?>