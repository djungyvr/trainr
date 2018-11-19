provider "aws" {
  access_key    = "${var.access_key}" secret_key    = "${var.secret_key}"
  region        = "${var.region}"
}

resource "aws_security_group" "trainr_sg" {
  # Open ssh
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ebs_volume" "volume" {
  snapshot_id       = "${var.snapshot}"
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
    type = "ssh"
    private_key = "${file(var.private_key)}"
  }

  provisioner "file" {
    source = "${var.script}"
    destination = "/tmp/${var.script}"
  }
  provisioner "file" {
    source = "${var.keras_script}"
    destination = "/tmp/${var.keras_script}"
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
      "whoami",
      "sudo mkdir -p /trainr-data",
      "sudo mount /dev/nvme1n1 /trainr-data",
      "sudo chmod +x /tmp/${var.script}",
      "sudo cp /tmp/${var.script} /trainr-data/${var.script}",
      "sudo cp /tmp/${var.keras_script} /trainr-data/${var.keras_script}",
      "cd /trainr-data; ./${var.script}",
      "sudo umount /trainr-data",
    ]
  }
  depends_on = ["aws_volume_attachment.att"]
}
