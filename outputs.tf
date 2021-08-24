# This file allows us to retrieve the resources' variables through the CLI or the output console 
output "webapp_url" {
    value = azurerm_app_service.webapp.default_site_hostname
}
output "webapp_ips" {
    value = azurerm_app_service.webapp.outbound_ip_addresses
}
output "mysql_server_id" {
    value = azurerm_mariadb_server.webapp_mariadb_server.id
}