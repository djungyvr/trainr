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

}

resource "null_resource" "train" {
  connection {
    type = "ssh"
    host = "${aws_instance.trainr.public_ip}"
    private_key = "${file(var.private_key)}"
    user = "ubuntu"
  }

  # Mount the volume
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /trainr-data",
      "sudo mount /dev/xvdh /trainr-data",
      "sudo chown ubuntu:ubuntu /trainr-data",
    ]
  }
  # Copy over training files
  provisioner "file" {
    source = "${var.script}"
    destination = "/trainr-data/${var.script}"
  }
  provisioner "file" {
    source = "${var.keras_script}"
    destination = "/trainr-data/${var.keras_script}"
  }
  # Run the training files
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /trainr-data/${var.script}",
      "cd /trainr-data; ./${var.script}",
      # Sleep so the disk is no longer busy
      "sleep 15",
      "cd /; sudo umount /trainr-data",
    ]
  }
  depends_on = ["aws_volume_attachment.att"]
}
