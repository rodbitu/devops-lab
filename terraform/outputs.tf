# output "api_url" {
#   value = aws_apigatewayv2_api.http_api.api_endpoint
# }

output "static_site_url" {
  value = "http://${aws_s3_bucket_website_configuration.site.website_endpoint}"
}

output "ga_role_arn" {
  value = aws_iam_role.github_actions.arn
}

output "ecr_repo_url" {
  value = aws_ecr_repository.app.repository_url
}
