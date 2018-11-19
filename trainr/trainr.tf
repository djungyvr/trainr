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
}

data "aws_ebs_snapshot" "snapshot" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "tag:Name"
    values = ["trainr"]
  }
}

resource "aws_ebs_volume" "volume" {
  snapshot_id       = "${data.aws_ebs_snapshot.snapshot.id}"
  size              = "${var.size}"
  availability_zone = "${var.az}"
}

resource "aws_volume_attachment" "att" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.volume.id}"
  instance_id = "${aws_instance.trainr.id}"

  depends_on = ["aws_instance.trainr", "aws_ebs_volume.volume"]
}

resource "aws_instance" "trainr" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  availability_zone = "${var.az}"
  vpc_security_group_ids = ["${aws_security_group.trainr_sg.id}"]

  connection {
    user = "ubuntu"
  }

  provisioner "file" {
    source = "${var.script}"
    destination = "/tmp/${var.script}"
  }
}

resource "null_resource" "train" {
  connection {
    type = "ssh"
    host = "${aws_instance.trainr.public_ip}"
    private_key = "${file(var.private_key)}"
    user = "ubuntu"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/${var.script}",
      "sudo /tmp/${var.script}",
    ]
  }
  depends_on = ["aws_volume_attachment.att"]
}
