resource "aws_eip" "ep_bastion_eip" {
  count    = var.settings.bastion.count
  instance = aws_instance.ep_bastion[count.index].id
  vpc      = true
  tags = {
    Name = "ep-web-eip-${count.index+1}"
  }
}

resource "aws_eip" "ep_nat_eip" {
  vpc = true
}