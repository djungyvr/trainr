provider "aws" {
  access_key    = "${var.access_key}"
  secret_key    = "${var.secret_key}"
  region        = "${var.region}"
}

resource "aws_security_group" "trainr_sg" {
  # Open ssh
  ingress { from_port = 22 to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Open outbound
  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ami" {
  owners = ["099720109477"]
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_volume_attachment" "att" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.volume.id}"
  instance_id = "${aws_instance.ec2.id}"

  depends_on = ["aws_instance.ec2", "aws_ebs_volume.volume"]
}

resource "aws_instance" "ec2" {
  ami           = "${data.aws_ami.ami.id}"
  instance_type = "t2.micro"
  availability_zone = "${var.az}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.trainr_sg.id}"]

  connection {
    user = "ubuntu"
  }

  provisioner "file" {
    source = "${var.script}"
    destination = "/tmp/${var.script}"
  }
}

resource "aws_ebs_volume" "volume" {
  availability_zone = "${var.az}"
  size              = "${var.size}"
}

resource "null_resource" "mount" {
  connection {
    type = "ssh"
    host = "${aws_instance.ec2.public_ip}"
    private_key = "${file(var.private_key)}"
    user = "ubuntu"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo mkfs -F -t ext4 /dev/xvdh",
      "sudo mkdir /trainr-data",
      "sudo mount /dev/xvdh /trainr-data",
    ]
  }
  depends_on = ["aws_volume_attachment.att"]
}

resource "null_resource" "collect" {
  connection {
    type = "ssh"
    host = "${aws_instance.ec2.public_ip}"
    private_key = "${file(var.private_key)}"
    user = "ubuntu"
  }
  provisioner "remote-exec" {
    inline = [
      "ls /trainr-data",
      "sudo chmod +x /tmp/${var.script}",
      "cd /trainr-data; sudo /tmp/${var.script}",
      "ls /trainr-data",
    ]
  }
  depends_on = ["null_resource.mount"]
}

resource "null_resource" "unmount" {
  connection {
    type = "ssh"
    host = "${aws_instance.ec2.public_ip}"
    private_key = "${file(var.private_key)}"
    user = "ubuntu"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo umount /trainr-data",
    ]
  }
  depends_on = ["null_resource.collect"]
}

output "volume_id" {
  value = "${aws_ebs_volume.volume.id}"
}
