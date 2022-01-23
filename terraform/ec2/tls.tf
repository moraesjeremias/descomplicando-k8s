resource "tls_private_key" "k8s_lab_key" {
  algorithm = "RSA"
}

resource "local_file" "local_key_pair" {
  filename = "./certs/${local.app_name}-key-pair.pem"
  sensitive_content = tls_private_key.k8s_lab_key.private_key_pem
  file_permission = "0400"
}

resource "aws_key_pair" "k8s_lab_key_pair" {
  key_name   = "${local.app_name}-key-pair"
  public_key = tls_private_key.k8s_lab_key.public_key_openssh
}