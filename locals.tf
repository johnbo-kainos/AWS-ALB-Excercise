locals {

  //Using a local, this gets all the IDs of the dynamically created EC2 instances from both zones and addes them two one list of IDs
  web_instance_ids = concat(aws_instance.web_zone_a[*].id, aws_instance.web_zone_b[*].id)

}