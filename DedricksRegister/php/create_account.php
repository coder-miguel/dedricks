<?php
    include ('session.php');
    $_SESSION['user'] = 'anon';
?>
    <main>
        <h1> Create Account </h1>
        <form action="includes/create_account.inc.php" method="post">
            <input type="text"      name="fname"    placeholder="First Name" required>
            <input type="text"      name="lname"    placeholder="Lirst Name" required>
            <input type="text"      name="phone"    placeholder="Phone">
            <input type="text"      name="mail"     placeholder="Email" required>
            <input type="password"  name="pw"       placeholder="Password" required>
            <input type="password"  name="pw2"      placeholder="Verify Password" required>
            <input type="Submit"    name="signup">
        </form>
    </main>

