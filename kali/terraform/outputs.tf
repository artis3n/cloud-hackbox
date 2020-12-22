output "kali_id" {
  value = aws_instance.kali.id
}

output "kali_ip" {
  value = aws_instance.kali.public_ip
}
