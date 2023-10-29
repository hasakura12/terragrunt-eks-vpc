output "cluster_openid_connect_provider_arn" {
  description = "The ARN assigned by AWS for this provider."
  value       = aws_iam_openid_connect_provider.oidc_provider.arn
}

output "cluster_openid_connect_provider_url" {
  description = "(Required) The URL of the identity provider. Corresponds to the iss claim."
  value       = aws_iam_openid_connect_provider.oidc_provider.url
}

output "cluster_openid_connect_provider_client_id_list" {
  description = "(Required) A list of client IDs (also known as audiences). When a mobile or web app registers with an OpenID Connect provider, they establish a value that identifies the application. (This is the value that's sent as the client_id parameter on OAuth requests.)"
  value       = aws_iam_openid_connect_provider.oidc_provider.client_id_list
}

output "cluster_openid_connect_provider_thumbprint_list" {
  description = "(Required) A list of server certificate thumbprints for the OpenID Connect (OIDC) identity provider's server certificate(s)."
  value       = aws_iam_openid_connect_provider.oidc_provider.thumbprint_list
}
