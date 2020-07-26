output "kali_id" {
  value = aws_spot_instance_request.kali.spot_instance_id
}

output "kali_ip" {
  value = aws_spot_instance_request.kali.public_ip
}
