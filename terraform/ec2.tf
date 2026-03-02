# Create the EC2 instance
resource "aws_instance" "free_tier_instance" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro" # Free tier eligible instance type
  
  # Associate the security group
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "FreeTierAmazonLinuxInstance"
  }
}

# Output the public IP address of the instance
output "public_ip" {
  value = aws_instance.free_tier_instance.public_ip
  description = "The public IP address of the EC2 instance"
}
