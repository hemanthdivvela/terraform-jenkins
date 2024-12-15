module "jenkins" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  

  name = "jenkins-tf"

  instance_type          = "t3.small"
  vpc_security_group_ids = ["sg-0e9b9d879e1385874"]
  subnet_id = "subnet-02c875ab2dec649fd"
  user_data = file("jenkins.sh")

  tags = {
    Name   = "jenkins-tf"
    
  }
}

module "jenkins_agent" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  

  name = "jenkins-agent"

  instance_type          = "t3.small"
  vpc_security_group_ids = ["sg-0e9b9d879e1385874"]
  subnet_id = "subnet-02c875ab2dec649fd"
  user_data = file("jenkins.sh")

  tags = {
    Name   = "jenkins-tf"
    
  }
}


# create R53 records for RDS endpoint

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 3.0"

  zone_name = var.zone_name

  records = [
    {
      name    = "jenkins" #web-cdn.daws78s.online
      type    = "A"
      ttl = 1
      records = [
        module.jenkins.public_ip
      ]
      allow_overwrite = true
      
    },
    {
      name    = "jenkins-agent" #web-cdn.daws78s.online
      type    = "A"
      ttl = 1
      records = [
        module.jenkins.private_ip
      ]
      allow_overwrite = true
      
    }
  ]
}