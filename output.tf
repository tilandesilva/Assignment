output "pub_subnets"{
  value = aws_subnet.pub_subnets.*.id
}
output "ec2public_ip"{
  value = aws_instance.web.*.public_ip
}