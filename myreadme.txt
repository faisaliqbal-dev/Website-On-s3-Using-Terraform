✅ 1. S3 Bucket Create Karna
resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname

  tags = {
    Name = var.bucketname
  }
}
Ye ek S3 bucket create karta hai.

var.bucketname ka matlab hai: bucket ka naam aap variable se dere ho (jo variables.tf mein define hota).

Tags sirf bucket ka naam laga rahe ho for identification.

✅ 2. Public Access Allow Karna

AWS S3 by default public access block kar deta hai.

Ye resource woh block hata raha hai taake files ko public read access mil sake.

✅ 3. Public Read Policy Apply Karna

Ye bucket ko public banata hai — sab koi internet se index.html, css, images, etc. access kar sakta.

depends_on is liye lagaya gaya hai taake yeh tabhi chale jab public access allow ho jaye.

✅ 4. Static Files Upload Karna
resource "aws_s3_object" "website_files" {
  for_each = fileset("${path.module}/grandcoffee-master", "**")

  bucket       = aws_s3_bucket.mybucket.id
  key          = each.value
  source       = "${path.module}/grandcoffee-master/${each.value}"
  content_type = lookup(
    {
      html = "text/html"
      css  = "text/css"
      js   = "application/javascript"
    },
    split(".", each.value)[length(split(".", each.value)) - 1],
    "application/octet-stream"
  )
}

✅ for_each = fileset("${path.module}/grandcoffee-master", "**")
Yeh kya karta hai?

Aapke grandcoffee-master folder ke andar jitni bhi files hain, unko Terraform loop mein laata hai.

"**" ka matlab hai: all files and subfolders recursively.

Agar folder ke andar yeh files hain:
index.html
style.css
js/main.js
To yeh resource teen baar chalega — ek har file ke liye.

✅ bucket = aws_s3_bucket.mybucket.id
Iska matlab: sabhi files usi bucket mein upload hongi jo upar create ki thi (mybucket).

✅ key = each.value
S3 bucket mein har file ka ek path (key) hota hai.

each.value har file ka naam/path represent karta hai.

For example:

index.html ka key banega index.html

js/main.js ka key banega js/main.js

✅ source = "${path.module}/grandcoffee-master/${each.value}"
Ye batata hai ke actual file ka path local machine pe kya hai.

${path.module}: jahan aapki .tf file rakhi hai

${each.value}: file ka naam

✅ content_type = lookup(...)
S3 ko har file ke sath Content-Type dena chahiye (browser ko pata chale kaun si file kis format mein hai).

Yeh block file ka extension dekh kar correct content-type assign karta hai:

| Extension | Content-Type             |
| --------- | ------------------------ |
| html      | text/html                |
| css       | text/css                 |
| js        | application/javascript   |
| other     | application/octet-stream |

📦 Example:

style.css → text/css

main.js → application/javascript

index.html → text/html