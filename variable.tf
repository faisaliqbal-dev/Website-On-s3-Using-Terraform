variable "bucketname" {
  default = "mystatic-wesite-using-terraform"
  type    = string

}
variable "access_key" {
  type      = string
  sensitive = true

}
variable "secret_key" {
  type      = string
  sensitive = true

}