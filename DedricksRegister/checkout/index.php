<?php
    
    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }
    //$_SESSION['return'] = urlencode("/DedricksRegister/checkout/");

    //Load the inventory into session memory
    if(!isset($_SESSION['inventory']) || !isset($_SESSION['measurements'])){
       include("../php/set_inventory.php");
    }

    //redirected post here if item's measurement required user input
    //finish putting the item in the cart
    if(isset($_POST['measqty']))
    {
        //insertion point
        $finitem     = $_SESSION['tempitem'];
        $finmeas     = $_SESSION['tempmeas'];
        $finmeasqty  = $_POST['measqty'];
        $cartindex   = $finitem['ItemCode']."".$finmeasqty;

        //if(!isset($_SESSION['cart'][$cartindex])){
            $_SESSION['cart'][$cartindex] = array('item' => $finitem, 'meas' => $finmeas, 'measqty' => $finmeasqty);
            $_SESSION['cart'][$cartindex]['qty'] = 1;
        //}else{
            //$_SESSION['cart'][$cartindex]['qty']++;
        //}
        //end insertion
    }
      

?>
<!DOCTYPE html>
<html>


    <head>
        <meta charset="UTF-8">
        <title>Checkout</title>
        <link href="../css/style.css" rel="stylesheet" type="text/css">
        <link href="../css/register.css" rel="stylesheet" type="text/css">

    </head>


    <body onload="initialize()" onclick="focusInput()">


            <div class="navbar">
                <a class="sp" onclick="show('byn'); hide('byu')">Search</a>
                <a class="sp" onclick="show('byu'); hide('byn')">Scan</a>
                <a class="a" href="../../">Home</a>
                <a class="a" href="../">Log Out</a>
            </div>
    <!-- --------------------------------------------------------------------------------------------------------------------------------- -->
    <!-- ----- UPC Scanner Input redirects here as a GET ---- -->
    <!-- ----- So that UPC conflic can be resolved ---------- -->
            <?php 
                if (isset($_GET['upc']))
                {
                    include('includes/place_cart_item.php');
                }
            ?>
    <!-- --------------------------------------------------------------------------------------------------------------------------------- -->
    <!-- -------- Cart Area  ---------------- -->

            <div class="cart">
                  <form class="cart-box" id="cart-form" action="cashout.post.php" onchange='newPrice()' method="post">

                        <div class="container" style="padding-left: 24px">

            <!-- -------------------------------------------------------------------------------------------------- -->
            <!-- -------- PHP Display the Cart from the $_SESSION variable 'cart' -------- -->
                            <?php
                                if(isset($_SESSION['cart'])){

                                    include("includes/display_cart.php");
                                }
                            ?> 


                        </div>


                        

                  </form>
                  <div class="cart-submit">
                        <div class="subtotal">
                        <label>SubTotal:$<span id='subtotal'></span></label></div>
                        <div class="subButton"> 
                        <button onclick="updateQtysAndGo('../checkout/index.php?submit=true')">Cash Out</button>
                        </div>
                            
                  </div>
            </div>

    <!-- -------- Cart Area  ---------------- -->
    <!-- --------------------------------------------------------------------------------------------------------------------------------- -->
    


            <div id="byn" class="search-bar" onclick="hide('byu')">
              
                  <form class="search-box animate-slide-left" id="by-name" action="../php/search.php" method="post">
                      
                        <div class="container">
                            <input id="search-input" type="text" placeholder="Search" name="like-name">
                        </div>  

                        <div class="container container-foot" style="background-color:#f1f1f1;">
                            <button class="search-button" type="submit">Search By Name</button>
                        </div>

                  </form>
            </div>

            <div id="byu" class="search-bar" onclick="hide('byn')" style="display: none">
              
                  <form class="search-box animate-slide-left" id="by-upc"> <!-- action="../php/add_item.php" method="post"> -->

                        <div class="container" style = "margin-top: 12px">
                          <label for="upc"><b>UPC: </b></label><br>
                          <textarea id="upc" placeholder="Universal Product Code" onkeydown="checkKey(event)"></textarea>
                            <!-- <p>Uni-Char: <span id="key-pressed"></span></p> -->
                        </div>

                  </form>
            </div>


            <!-- -------- Search Queue Under Development  ---------------- -->
            <div id="q01" class="search-q">  
                  <form class="search-box" id="by-name" style="border:none;" action="../php/search.php" method="post">
                        <div class="container">
                            <h1>
                                Inventory:
                            </h1>
                            <p id='jsstuff'></p>
                                <?php
                                    if(isset($_SESSION['query'])){

                                    }

                                ?>
                            <div class="search-results">

                            </div>
                        </div>    
                  </form>
            </div>



            <!-- -------- Hidden Form  ---------------- -->
            <div style='display: none; z-index: -1'>
                <form class="qtyform" id="qtys" action="update_qtys.php" method="post">
                    <input type="hidden" id='hidin' name="newqtys" value=''>  
                </form>
            </div>



    </body>

    <script type="text/javascript">

        //var qty = [];
        var nitms = 0;
        var upcfocus = true;

        <?php 
            if(isset($_SESSION['cart'])){
                foreach ($_SESSION['cart'] as $cartitm) {
                    echo "nitms++;";
                }
            }

            if(isset($_GET['submit'])){
                //include("includes/display_cart.php");
                echo "
                    document.getElementById('cart-form').submit();
                ";
            }
        ?>

        function newPrice(){

            var subTotal = 0;
            var curprc = 0;
            var curqty = 0;
            var curmqt = 0;
            var curwgt = 0;

            for(i = 0; i<nitms; i++){
                curqty = Number(document.getElementById("qty"+i).innerHTML);
                curprc = Number(document.getElementById("prc"+i).innerHTML);
                curmqt = Number(document.getElementById("mqt"+i).innerHTML);
                curwgt = Number(document.getElementById("wgt"+i).innerHTML);
                subTotal += curqty*(curprc*(curmqt/curwgt));
            }
            subTotal = subTotal.toFixed(2);
            document.getElementById('subtotal').innerHTML = subTotal;

        }

        function updateQtysAndGo(loc){

            var vartoPost = "";
            for(i = 0; i<nitms; i++){
                var toappend = document.getElementById("qty"+i).innerHTML;
                vartoPost += toappend+"|";
            }
            vartoPost+=loc;
            document.getElementById('hidin').value = vartoPost;
            document.getElementById('qtys').submit();
        }

        function addTo(key){

            var indx = "qty"+key;
            var curQty = Number(document.getElementById(indx).innerHTML);
            curQty++;
            document.getElementById(indx).innerHTML = curQty;
            newPrice();

        }

        function rmFrom(key){

            var indx = "qty"+key;
            var curQty = Number(document.getElementById(indx).innerHTML);
            curQty--;
            document.getElementById(indx).innerHTML = curQty;
            newPrice();

            var cartitem = document.getElementById(key).value.split('|');

            if(curQty<=0){                                          //TODO find the unique cart index
                updateQtysAndGo("../checkout/includes/place_cart_item.php?remove=true&id1="+cartitem[0]+"&id2="+cartitem[1]);
            }

        }


        function checkKey(e){

            if(document.getElementById('cm1')!=null){
                if(e.keyCode == 27 || e.keyCode == 13){
                    document.getElementById('cm1').style.display='none';
                }
            }
            if(!document.getElementById("upc").value.trim() == ""){
                var keye    = e.keyCode;
                if (keye ==13){
                    var upcval = document.getElementById("upc");
                    var upc    = upcval.value.replace(/\s/g, "");
                    updateQtysAndGo("../checkout/index.php?upc="+upc);
                }  
            }
        }

        function hide(id){
            document.getElementById(id).style.display='none'
        }

        function show(id){
            document.getElementById(id).style.display='block'
        }

        function focus(id){
            document.getElementById(id).focus();
        }

        
        function focusInput(){
            if(upcfocus){
                var upcbox    = document.getElementById('byu');
                var upc       = document.getElementById('upc');
                var searchin  = document.getElementById('search-input');

                if(upcbox.style.display === 'block')
                    upc.focus();
                else
                    searchin.focus();
            }
        }

        function scrolledDown(id){
            var objDiv = document.getElementById(id);
            objDiv.scrollTop = objDiv.scrollHeight;
        }

        function initialize(){
            show('byu');
            hide('byn');
            focus('upc');
            scrolledDown('cart-form');
            newPrice();
        }



    </script>

</html>

