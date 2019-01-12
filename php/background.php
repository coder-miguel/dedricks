<?php

$value = 'nothing';
//if(!isset($value)){
if(!isset($_SESSION['changeback'])){
	$background = "<style>body{background-image: url(images/wall.jpg);}</style>";
}
else if(isset($_SESSION['changeback'])){
	$value = $_SESSION['changeback'];
	$background = changebackground($value);
	
}


function changebackground($value){
	

		
if($value == "Spring"){
		$change = "<style>body{background-image: url(images/spring.jpg);}</style>";
	}
	elseif($value == "Winter"){
		$change = "<style>body{background-image: url(images/winter.jpg);}</style>";
	}
	elseif($value == "Fall"){
		$change = "<style>body{background-image: url(images/fall.jpg);}</style>";
	}
	elseif($value == "Summer"){
		$change = "<style>body{background-image: url(images/summer.jpg);}</style>";
	}
	return $change;

	}





?>