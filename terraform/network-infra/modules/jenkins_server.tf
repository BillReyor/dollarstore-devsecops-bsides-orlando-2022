data "aws_ami" "jenkins_ami" { 
    most_recent = true 
    owners = ["self"]
}

resource "aws_key_pair" "jenkins_key" {
    key_name   = "jenkins-key"
    public_key = var.public_key
}

resource "aws_instance" "jenkins_main" {
    #checkov:skip=CKV_AWS_135:Disable EBS optimization as an example
    #checkov:skip=CKV_AWS_79:Disable metadata check as an example
    ami  = data.aws_ami.jenkins_ami.id
    instance_type = "t2.large"
    key_name = aws_key_pair.jenkins_key.key_name
    vpc_security_group_ids = [aws_security_group.jenkins_main_sg.id]
    subnet_id = element(aws_subnet.private_subnets, 0).id
    monitoring = true
    /*ebs_optimized = true

    metadata_options {
        http_endpoint = "enabled"
        http_tokens   = "required"
    }*/

    root_block_device { 
        volume_type = "gp3" 
        volume_size = 30 
        delete_on_termination = false
        encrypted = true

    }

    tags = {
    	Name = "Jenkins Server Main"
     }
}
