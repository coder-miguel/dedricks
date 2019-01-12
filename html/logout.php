<?php
require('../php/server.php');
session_destroy();
header('location: ../index.php?logout_success');
?>