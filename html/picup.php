<!DOCTYPE html>
<html>


<head>
	<title>Title of Webpage</title>
<link class="jsbin" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1/themes/base/jquery-ui.css" rel="stylesheet" type="text/css" />
<script class="jsbin" src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
<script class="jsbin" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.0/jquery-ui.min.js"></script>
<link href="../css/pic.css" rel="stylesheet" type="text/css">

<style>
  article, aside, figure, footer, header, hgroup, 
  menu, nav, section { display: block; }
</style>


</head>



<body>
<hr>
<h1>Load Pictures</h1>
<hr>
<div id="test">
<br><br><br><br>
<!-- <input type='file' onchange="readURL(this);" /> -->
    <img id="fileToUpload" src="#" alt="" />
<br><br>

<form action="../php/upload.php" method="post" enctype="multipart/form-data">
    Upload Image:
    <input type="file" name="fileToUpload" onchange="readURL(this);" id="fileToUpload"> <br><br>
    
    <input type="submit" value="Upload Image" name="submit">
    <input type="button" value="Go Back" onclick="window.location.href='adminconfig.php'" />
</form>

</div>

</body>



<script>
function readURL(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();

            reader.onload = function (e) {
                $('#fileToUpload')
                    .attr('src', e.target.result)
                    .width(280)
                    .height(250);
            };

            reader.readAsDataURL(input.files[0]);
        }
    }
</script>




</html>