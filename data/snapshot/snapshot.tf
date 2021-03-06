provider "aws" {
  access_key    = "${var.access_key}"
  secret_key    = "${var.secret_key}"
  region        = "${var.region}"
}

resource "aws_ebs_snapshot" "data" {
  volume_id = "${var.volume}"

  tags {
    Name = "trainr"
  }
}

output "volume_id" {
  value = "${var.volume}"
}

output "snapshot_id" {
  value = "${aws_ebs_snapshot.data.id}"
}
