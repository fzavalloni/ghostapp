locals {
  default_mysql_options = {
    require_secure_transport = var.ssl_enforced ? "ON" : "OFF"
  }
}