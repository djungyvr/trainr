provider "aws" {
  access_key    = "${var.access_key}"
  secret_key    = "${var.secret_key}"
  region        = "${var.region}"
}

resource "aws_volume_attachment" "att" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.volume.id}"
  instance_id = "${aws_instance.ec2.id}"
}

resource "aws_instance" "ec2" {
  ami           = "ami-0afae182eed9d2b46"
  instance_type = "t2.micro"
  availability_zone = "${var.az}"

  provisioner "file" {
    source      = "${var.local_script_path}"
    destination = "${var.remote_script_path}"
  }

  provisioner "remote-exec" {
    inline = [
      "${var.remote_script_path}",
    ]
  }
}

resource "aws_ebs_volume" "volume" {
  availability_zone = "${var.az}"
  size              = "${var.size}"
  tags {
    Name = "${var.size}"
  }
}
