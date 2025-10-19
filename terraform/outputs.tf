output "api_url" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}

output "static_site_url" {
  value = "http://${aws_s3_bucket_website_configuration.site.website_endpoint}"
}
