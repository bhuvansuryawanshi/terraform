#!/bin/bash
apt update -y
apt install apache2 -y
systemctl start apache2
systemctl enable apache2

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Welcome to My EC2 Website</title>
    <style>
        body {
            background-color: #f2f2f2;
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 100px;
        }
        h1 {
            color: #333366;
        }
        p {
            color: #555555;
        }
        .box {
            background: white;
            padding: 30px;
            border-radius: 10px;
            display: inline-block;
            box-shadow: 0px 0px 15px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="box">
        <h1>Welcome to My First EC2 Website!</h1>
        <p>Hosted on Apache server running on an EC2 instance 🚀</p>
    </div>
</body>
</html>
EOF
