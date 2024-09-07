resource "aws_db_instance" "ep_database_dev" {
  allocated_storage      = var.settings.database.allocated_storage
  engine                 = var.settings.database.engine
  instance_class         = var.settings.database.instance_class
  db_name                = var.settings.database.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.ep_db_subnet_group.id
  vpc_security_group_ids = [aws_security_group.ep_db_sg.id]
  skip_final_snapshot    = var.settings.database.skip_final_snapshot
}

resource "aws_instance" "ep_app_dev" {
  count                  = var.settings.web_app.count
  ami                    = data.aws_ami.rhel_9-3.id
  instance_type          = var.settings.web_app.instance_type
  subnet_id              = aws_subnet.ep_private_app_subnet[count.index].id
  key_name               = "web-kp"
  vpc_security_group_ids = [aws_security_group.ep_web_sg.id]
  user_data = file("app_config.sh")

  tags = {
    Name = "ep-app-dev-${count.index+1}"
  }
}

resource "aws_instance" "ep_web" {
  count                  = var.settings.web_app.count
  ami                    = data.aws_ami.rhel_9-3.id
  instance_type          = var.settings.web_app.instance_type
  subnet_id              = aws_subnet.ep_private_web_subnet[count.index].id
  key_name               = "web-kp"
  vpc_security_group_ids = [aws_security_group.ep_web_sg.id]
  user_data = file("web_config.sh")

  tags = {
    Name = "ep-web-dev-${count.index+1}"
  }
}

resource "aws_instance" "ep_bastion" {
  count                  = var.settings.bastion.count
  ami                    = data.aws_ami.rhel_9-3.id
  instance_type          = var.settings.bastion.instance_type
  subnet_id              = aws_subnet.ep_public_subnet[count.index].id
  key_name               = "web-kp"
  vpc_security_group_ids = [aws_security_group.ep_bastion_sg.id]
  user_data = file("bastion_config.sh")

  tags = {
    Name = "ep-bastion-dev-${count.index+1}"
  }
}